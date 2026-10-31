import 'dart:async';
import 'dart:convert';

import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/function/auth_headers.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/core/shared/notifications/notification_inbox.dart';
import 'package:app/core/shared/notifications/notification_router.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:app/data/datasource/remot/notifications_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// لازم يكون Top-Level حتى يشتغل والإشعار بالتطبيق مغلق.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationInbox.rememberRemote(message);
}

class NotificationApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
      );

  Future<void> init() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      }

      if (!kIsWeb) {
        await _initLocalNotifications();
      }

      await _initFirebaseListeners();

      final initial = await _firebaseMessaging.getInitialMessage();
      if (initial != null) {
        await NotificationInbox.rememberRemote(initial);
        NotificationRouter.hold(_modelFromRemote(initial));
      }

      _firebaseMessaging.onTokenRefresh.listen((_) {
        syncDeviceToken();
      });

      await getToken();
    } on FirebaseException catch (e, st) {
      debugPrint(
        '⚠️ FCM init skipped (${e.code}): ${e.message}\n'
        'تأكد من Google Play Services والإنترنت على الجهاز/المحاكي.',
      );
      debugPrint('$st');
    } catch (e, st) {
      debugPrint('⚠️ Notification init failed: $e');
      debugPrint('$st');
    }
  }

  Future<void> _initFirebaseListeners() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final model = _modelFromRemote(message);
      await NotificationInbox.remember(model);
      if (kIsWeb || (model.title.isEmpty && model.body.isEmpty)) return;

      _localNotifications.show(
        id: model.id.hashCode & 0x7fffffff,
        title: model.title,
        body: model.body,
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
        payload: jsonEncode(model.toPayload()),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final decoded = jsonDecode(payload);
        if (decoded is! Map) return;
        final model = NotificationModel.fromPush(
          data: Map<String, dynamic>.from(decoded),
        );
        _open(model);
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  void _handleMessage(RemoteMessage message) {
    _open(_modelFromRemote(message));
  }

  Future<void> _open(NotificationModel model) async {
    await NotificationInbox.remember(model);
    if (Get.isRegistered<NotificationsController>()) {
      await Get.find<NotificationsController>().markAsRead(model.id);
    }
    await NotificationRouter.open(model);
  }

  NotificationModel _modelFromRemote(RemoteMessage message) {
    return NotificationModel.fromPush(
      id: message.messageId,
      title: message.notification?.title,
      body: message.notification?.body,
      data: Map<String, dynamic>.from(message.data),
      createdAt: message.sentTime,
    );
  }

  Future<String?> getToken({int maxAttempts = 3}) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final token = await _firebaseMessaging
            .getToken()
            .timeout(const Duration(seconds: 8));
        if (kDebugMode && token != null) {
          debugPrint('FCM token: $token');
        }
        return token;
      } on TimeoutException {
        debugPrint('⚠️ FCM getToken timed out');
        return null;
      } on FirebaseException catch (e) {
        final isRetryable = e.code == 'unknown' &&
            (e.message?.contains('SERVICE_NOT_AVAILABLE') ?? false);
        if (!isRetryable || attempt == maxAttempts) {
          debugPrint('⚠️ FCM getToken failed (${e.code}): ${e.message}');
          return null;
        }
        await Future<void>.delayed(Duration(seconds: attempt * 2));
      } catch (e) {
        debugPrint('⚠️ FCM getToken failed: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> syncDeviceToken() async {
    try {
      if (!Get.isRegistered<SessionService>() || !Get.isRegistered<Crud>()) {
        return;
      }
      if (!AuthHeaders.hasToken) return;
      final token = await FirebaseMessaging.instance
          .getToken()
          .timeout(const Duration(seconds: 8));
      if (token == null || token.isEmpty) return;
      await NotificationsData(Get.find<Crud>()).registerDeviceToken(token);
    } catch (e) {
      debugPrint('⚠️ FCM token sync failed: $e');
    }
  }

  static Future<void> unregisterDeviceToken() async {
    try {
      if (!Get.isRegistered<Crud>() || !AuthHeaders.hasToken) return;
      final token = await FirebaseMessaging.instance
          .getToken()
          .timeout(const Duration(seconds: 8));
      if (token == null || token.isEmpty) return;
      await NotificationsData(Get.find<Crud>()).unregisterDeviceToken(token);
    } catch (e) {
      debugPrint('⚠️ FCM token remove failed: $e');
    }
  }
}
