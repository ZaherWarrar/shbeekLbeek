// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _localPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotifications() async {
//     // تهيئة flutter_local_notifications
//     const androidSettings = AndroidInitializationSettings('ic_notification');
//     const initSettings = InitializationSettings(android: androidSettings);
//     await _localPlugin.initialize(initSettings);

//     // ضبط العرض أثناء فتح التطبيق
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//   }

//   void _handleForegroundMessage(RemoteMessage message) {
//     final notification = message.notification;
//     final android = message.notification?.android;

//     if (notification != null && android != null) {
//       _localPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'channel_id',
//             'إشعارات عامة',
//             channelDescription: 'الإشعارات الواردة أثناء فتح التطبيق',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: 'ic_notification',
//           ),
//         ),
//       );
//     }
//   }
// }
