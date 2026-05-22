import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 🔴 HANDLER للخلفية (Android + iOS فقط)
/// لازم يكون Top-Level
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📩 BG Title: ${message.notification?.title}');
  debugPrint('📩 BG Body: ${message.notification?.body}');
  debugPrint('📩 BG Data: ${message.data}');
}

class NotificationApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔔 Android Channel
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
      );

  /// 🔹 INIT (Android + iOS + Web)
  Future<void> init() async {
    // 🔹 طلب الإذن (iOS + Web)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 Background handler (غير Web)
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }

    // 🔹 تهيئة Local Notifications (Android + iOS فقط)
    if (!kIsWeb) {
      await _initLocalNotifications();
    }

    // 🔹 إعداد استقبال الإشعارات
    await _initFirebaseListeners();

    // 🔹 Token
    await getToken();
  }

  /// 🔹 Firebase listeners
  Future<void> _initFirebaseListeners() async {
    // iOS foreground
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📨 FG Message: ${message.notification?.title}');

      if (kIsWeb) {
        // Web → المتصفح يعرض الإشعار
        return;
      }

      final notification = message.notification;
      if (notification == null) return;

    _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    });

    // 🔹 فتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// 🔹 Local Notifications Init (Android + iOS)
  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) return;
        final data = jsonDecode(response.payload!);
        _handleMessage(RemoteMessage.fromMap({'data': data}));
      }, settings: settings,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  /// 🔹 Handle notification click
  void _handleMessage(RemoteMessage message) {
    debugPrint('👉 Opened Notification');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');
  }

  /// 🔹 FCM Token
  Future<String?> getToken() async {
    final token = await _firebaseMessaging.getToken();
    debugPrint('📱 FCM TOKEN: $token');
    return token;
  }
}
