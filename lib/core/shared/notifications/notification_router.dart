import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/app_snackbar.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:app/data/datasource/remot/order_data.dart';
import 'package:app/view/orderDetails/order_details_view.dart';
import 'package:get/get.dart';

class NotificationRouter {
  NotificationRouter._();

  static NotificationModel? pending;

  static void hold(NotificationModel item) {
    pending = item;
  }

  static Future<void> flushPending() async {
    final item = pending;
    if (item == null) return;
    pending = null;
    await open(item);
  }

  static Future<void> open(NotificationModel item) async {
    if (Get.key.currentState == null) {
      pending = item;
      return;
    }

    switch (item.screen) {
      case 'order':
        await _openOrder(item.orderId);
      case 'product':
        _openProduct(item);
      case 'store':
        _openStore(item.storeId);
      case 'cart':
        Get.toNamed(AppRoutes.cartView);
      case 'wallet':
        Get.toNamed(AppRoutes.wallet);
      case 'home':
        Get.offAllNamed(AppRoutes.home);
      default:
        if (Get.currentRoute != AppRoutes.notifications) {
          Get.toNamed(AppRoutes.notifications);
        }
    }
  }

  static void _openProduct(NotificationModel item) {
    final productId = item.productId;
    if (productId == null || productId <= 0) {
      AppSnackbar.show('تنبيه', 'هذا الإشعار غير مرتبط بمنتج');
      return;
    }
    Get.toNamed(
      AppRoutes.productDetails,
      arguments: {
        'productId': productId,
        if (item.storeId != null) 'storeId': item.storeId,
      },
    );
  }

  static void _openStore(int? storeId) {
    if (storeId == null || storeId <= 0) {
      AppSnackbar.show('تنبيه', 'هذا الإشعار غير مرتبط بمتجر');
      return;
    }
    Get.toNamed(
      AppRoutes.resturantDetails,
      arguments: {'id': storeId, 'storeId': storeId},
    );
  }

  static Future<void> _openOrder(int? orderId) async {
    if (orderId == null || orderId <= 0) {
      Get.toNamed(AppRoutes.ordhis);
      return;
    }
    if (!Get.isRegistered<Crud>()) {
      Get.toNamed(AppRoutes.ordhis);
      return;
    }

    final response = await OrderData(Get.find<Crud>()).myOrdersData();
    if (handlingData(response) == StatusRequest.success) {
      final match = _extractOrders(response).cast<OrderHisModel?>().firstWhere(
            (order) => order?.id == orderId,
            orElse: () => null,
          );
      if (match != null) {
        Get.to(() => OrderDetailsView(order: match));
        return;
      }
    }

    AppSnackbar.show('تنبيه', 'تعذر العثور على الطلب، تم فتح سجل الطلبات');
    Get.toNamed(AppRoutes.ordhis);
  }

  static List<OrderHisModel> _extractOrders(dynamic response) {
    final raw = response is Map && response['orders'] is List
        ? response['orders'] as List
        : response is List
            ? response
            : const [];
    return raw
        .whereType<Map>()
        .map((item) => OrderHisModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
