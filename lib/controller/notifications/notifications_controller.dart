import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/auth_headers.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/notifications_preferences.dart';
import 'package:app/core/shared/notifications/notification_router.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:app/data/datasource/remot/notifications_data.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

class NotificationsController extends GetxController {
  final NotificationsData _data = NotificationsData(Get.find<Crud>());

  StatusRequest statusRequest = StatusRequest.none;
  List<NotificationModel> notifications = [];

  List<NotificationModel> get visibleNotifications => notifications
      .where((item) => item.id.isNotEmpty && !item.isExpired)
      .toList();

  int get unreadCount => visibleNotifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _showCachedThenRefresh();
  }

  Future<void> _showCachedThenRefresh() async {
    notifications = await NotificationsPreferences.load();
    statusRequest = notifications.isEmpty
        ? StatusRequest.none
        : StatusRequest.success;
    update();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (isClosed) return;
    await loadNotifications();
  }

  Future<void> loadNotifications({bool requireAuth = false}) async {
    final local = await NotificationsPreferences.load();
    notifications = local;
    if (notifications.isEmpty) {
      statusRequest = AuthHeaders.hasToken
          ? StatusRequest.loading
          : StatusRequest.unauthorized;
    }
    update();

    if (!AuthHeaders.hasToken) {
      if (requireAuth && notifications.isEmpty) {
        AppSnackbar.show('تنبيه', 'يجب تسجيل الدخول لعرض الإشعارات');
        Get.toNamed(AppRoutes.login);
      }
      return;
    }

    final result = await _data.fetchNotifications();
    final status = handlingData(result);

    if (status != StatusRequest.success || result is! List<NotificationModel>) {
      statusRequest = notifications.isNotEmpty
          ? StatusRequest.success
          : (result is StatusRequest ? result : StatusRequest.failure);
      update();

      if (requireAuth && statusRequest == StatusRequest.unauthorized) {
        AppSnackbar.show('تنبيه', 'انتهت الجلسة — الرجاء تسجيل الدخول');
        Get.toNamed(AppRoutes.login);
      }
      return;
    }

    notifications = await _merge(local, result);
    await NotificationsPreferences.saveAll(notifications);
    statusRequest = StatusRequest.success;
    update();
  }

  Future<void> openNotification(NotificationModel item) async {
    await markAsRead(item.id);
    await NotificationRouter.open(item);
  }

  void upsertVisible(NotificationModel item) {
    if (item.id.isEmpty || item.isExpired) return;
    final index = notifications.indexWhere((current) => current.id == item.id);
    if (index == -1) {
      notifications.insert(0, item);
    } else {
      final previous = notifications[index];
      notifications[index] = item.copyWith(isRead: previous.isRead || item.isRead);
    }
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    statusRequest = StatusRequest.success;
    update();
  }

  Future<void> markAsRead(String id) async {
    if (id.isEmpty) return;

    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1 || notifications[index].isRead) return;

    final previous = notifications[index];
    notifications[index] = previous.copyWith(isRead: true);
    await NotificationsPreferences.upsert(notifications[index]);
    update();

    if (!AuthHeaders.hasToken) return;

    final result = await _data.markAsRead(id);
    if (handlingData(result) != StatusRequest.success) {
      final failed = handlingData(result);
      if (failed == StatusRequest.unauthorized) {
        notifications[index] = previous;
        await NotificationsPreferences.upsert(previous);
        update();
        _showActionError(result);
      }
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;

    final previous = List<NotificationModel>.from(notifications);
    notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    await NotificationsPreferences.saveAll(notifications);
    update();

    if (!AuthHeaders.hasToken) return;

    final result = await _data.markAllAsRead();
    if (handlingData(result) != StatusRequest.success &&
        handlingData(result) == StatusRequest.unauthorized) {
      notifications = previous;
      await NotificationsPreferences.saveAll(previous);
      update();
      _showActionError(result);
    }
  }

  Future<bool> deleteNotification(String id) async {
    if (id.isEmpty) return false;

    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return false;

    final removed = notifications.removeAt(index);
    await NotificationsPreferences.markDeleted(id);
    statusRequest = notifications.isEmpty
        ? StatusRequest.success
        : statusRequest;
    update();

    if (!AuthHeaders.hasToken) return true;

    final result = await _data.deleteNotification(id);
    final status = handlingData(result);
    if (status == StatusRequest.unauthorized ||
        status == StatusRequest.offlinefailure) {
      notifications.insert(index, removed);
      await NotificationsPreferences.restore(removed);
      update();
      _showActionError(result);
      return false;
    }
    return true;
  }

  Future<List<NotificationModel>> _merge(
    List<NotificationModel> local,
    List<NotificationModel> remote,
  ) async {
    final merged = <String, NotificationModel>{
      for (final item in local.where((item) => !item.isExpired)) item.id: item,
    };
    for (final item in remote) {
      if (item.id.isEmpty || item.isExpired) continue;
      if (await NotificationsPreferences.isDeleted(item.id)) continue;
      final previous = merged[item.id];
      merged[item.id] = previous != null && previous.isRead && !item.isRead
          ? item.copyWith(isRead: true)
          : item;
    }
    return merged.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _showActionError(Object result) {
    final status = result is StatusRequest ? result : StatusRequest.failure;
    switch (status) {
      case StatusRequest.unauthorized:
        AppSnackbar.show('تنبيه', 'انتهت الجلسة — الرجاء تسجيل الدخول');
        Get.toNamed(AppRoutes.login);
        break;
      case StatusRequest.offlinefailure:
        AppSnackbar.show('خطأ', 'لا يوجد اتصال بالإنترنت');
        break;
      case StatusRequest.serverfailure:
      case StatusRequest.serverException:
        AppSnackbar.show('خطأ', 'خطأ في الخادم، حاول لاحقاً');
        break;
      default:
        AppSnackbar.show('خطأ', 'تعذّر تنفيذ العملية');
    }
  }
}
