import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/services/notifications_preferences.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:app/core/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// يحفظ الإشعار محلياً لمدة أسبوع ويحدّث الصفحة إن كانت مفتوحة.
class NotificationInbox {
  NotificationInbox._();

  static Future<bool> remember(NotificationModel item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.getBool(SessionService.accountNotificationsKey) != true) {
      return false;
    }
    if (item.id.isEmpty || item.isExpired) return false;
    if (await NotificationsPreferences.isDeleted(item.id)) return false;
    await NotificationsPreferences.upsert(item);
    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().upsertVisible(item);
    }
    return true;
  }

  static Future<void> rememberRemote(RemoteMessage message) async {
    await remember(
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
