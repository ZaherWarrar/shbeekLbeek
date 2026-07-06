import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/auth_headers.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:app/data/datasource/remot/notifications_data.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final NotificationsData _data = NotificationsData(Get.find<Crud>());

  StatusRequest statusRequest = StatusRequest.none;
  List<NotificationModel> notifications = [];

  List<NotificationModel> get visibleNotifications => notifications;

  int get unreadCount =>
      visibleNotifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    if (AuthHeaders.hasToken) {
      loadNotifications();
    }
  }

  Future<void> loadNotifications({bool requireAuth = false}) async {
    if (!AuthHeaders.hasToken) {
      statusRequest = StatusRequest.unauthorized;
      notifications = [];
      update();
      if (requireAuth) {
        Get.snackbar('تنبيه', 'يجب تسجيل الدخول لعرض الإشعارات');
        Get.toNamed(AppRoutes.login);
      }
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    final result = await _data.fetchNotifications();
    final status = handlingData(result);

    if (status != StatusRequest.success || result is! List<NotificationModel>) {
      statusRequest = result is StatusRequest ? result : StatusRequest.failure;
      update();

      if (requireAuth && statusRequest == StatusRequest.unauthorized) {
        Get.snackbar('تنبيه', 'انتهت الجلسة — الرجاء تسجيل الدخول');
        Get.toNamed(AppRoutes.login);
      }
      return;
    }

    notifications = result;
    statusRequest = StatusRequest.success;
    update();
  }

  Future<void> markAsRead(String id) async {
    if (id.isEmpty) return;

    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1 || notifications[index].isRead) return;

    final previous = notifications[index];
    notifications[index] = previous.copyWith(isRead: true);
    update();

    final result = await _data.markAsRead(id);
    if (handlingData(result) != StatusRequest.success) {
      notifications[index] = previous;
      update();
      _showActionError(result);
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;

    final previous = List<NotificationModel>.from(notifications);
    notifications =
        notifications.map((n) => n.copyWith(isRead: true)).toList();
    update();

    final result = await _data.markAllAsRead();
    if (handlingData(result) != StatusRequest.success) {
      notifications = previous;
      update();
      _showActionError(result);
    }
  }

  Future<bool> deleteNotification(String id) async {
    if (id.isEmpty) return false;

    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return false;

    final result = await _data.deleteNotification(id);
    if (handlingData(result) != StatusRequest.success) {
      _showActionError(result);
      return false;
    }

    notifications.removeAt(index);
    update();
    return true;
  }

  void _showActionError(Object result) {
    final status = result is StatusRequest ? result : StatusRequest.failure;
    switch (status) {
      case StatusRequest.unauthorized:
        Get.snackbar('تنبيه', 'انتهت الجلسة — الرجاء تسجيل الدخول');
        Get.toNamed(AppRoutes.login);
        break;
      case StatusRequest.offlinefailure:
        Get.snackbar('خطأ', 'لا يوجد اتصال بالإنترنت');
        break;
      case StatusRequest.serverfailure:
      case StatusRequest.serverException:
        Get.snackbar('خطأ', 'خطأ في الخادم، حاول لاحقاً');
        break;
      default:
        Get.snackbar('خطأ', 'تعذّر تنفيذ العملية');
    }
  }
}
