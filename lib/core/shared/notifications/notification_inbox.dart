import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:get/get.dart';

/// يحدّث قائمة الإشعارات من الـ API عند وصول إشعار FCM.
class NotificationInbox {
  NotificationInbox._();

  static Future<void> refreshFromApi() async {
    if (!Get.isRegistered<NotificationsController>()) return;
    await Get.find<NotificationsController>().loadNotifications();
  }
}
