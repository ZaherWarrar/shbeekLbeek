import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/services/notifications_preferences.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

/// يحفظ الإشعار محلياً لمدة أسبوع ويحدّث الصفحة إن كانت مفتوحة.
class NotificationInbox {
  NotificationInbox._();

  static Future<void> remember(NotificationModel item) async {
    if (item.id.isEmpty || item.isExpired) return;
    if (await NotificationsPreferences.isDeleted(item.id)) return;
    await NotificationsPreferences.upsert(item);
    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().upsertVisible(item);
    }
  }

  static Future<void> rememberRemote(RemoteMessage message) {
    return remember(
      NotificationModel.fromPush(
        id: message.messageId,
        title: message.notification?.title,
        body: message.notification?.body,
        data: Map<String, dynamic>.from(message.data),
        createdAt: message.sentTime,
      ),
    );
  }
}
