import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_active_session.dart';
import 'package:app/controller/order/order_error_handler.dart';
import 'package:app/controller/order/order_payload_builder.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/order_data.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderData orderData = OrderData(Get.find());
  final SessionService session = Get.find<SessionService>();
  late final OrderActiveSession _active = OrderActiveSession(session);

  StatusRequest orderState = StatusRequest.none;

  int? get currentOrderId => _active.orderId;
  set currentOrderId(int? value) => _active.orderId = value;

  DateTime? get orderCreatedAt => _active.createdAt;
  set orderCreatedAt(DateTime? value) => _active.createdAt = value;

  Future<void> createOrder(String? notes) async {
    final token = session.token;
    if (token == null || token.isEmpty) {
      Get.snackbar('تنبيه', 'يجب تسجيل الدخول أولاً');
      Get.toNamed(AppRoutes.login);
      return;
    }

    final cartController = Get.find<CartController>();
    if (cartController.isEmpty) {
      Get.snackbar('تنبيه', 'السلة فارغة');
      return;
    }

    final orderDataMap = buildOrderPayload(cart: cartController, notes: notes);

    orderState = StatusRequest.loading;
    update();

    try {
      final response = await orderData.createOrderData(orderDataMap);
      orderState = handlingData(response);

      if (response is StatusRequest) {
        orderState = response;
        showOrderError(orderState);
      } else if (response is Map<String, dynamic>) {
        orderState = StatusRequest.success;

        final orderId = response['order_id'] as int?;
        if (orderId != null) {
          await _active.persist(orderId, DateTime.now());
          Get.toNamed(AppRoutes.orderConfirmation, arguments: orderId);
        } else {
          Get.snackbar('خطأ', 'فشل في الحصول على رقم الطلب');
          orderState = StatusRequest.failure;
        }
      } else {
        orderState = StatusRequest.failure;
        Get.snackbar('خطأ', 'فشل في إنشاء الطلب');
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar('خطأ', 'حدث خطأ: ${e.toString()}');
    }

    update();
  }

  Future<void> confirmOrder(int orderId) async {
    orderState = StatusRequest.loading;
    update();

    try {
      final response = await orderData.confirmOrderData(orderId);

      if (response is StatusRequest) {
        orderState = response;
        showOrderError(orderState);
      } else {
        orderState = StatusRequest.success;
        await _active.clear();
        Get.find<CartController>().clearCart();
        Get.snackbar('نجاح', 'تم تأكيد الطلب بنجاح');
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar('خطأ', 'حدث خطأ: ${e.toString()}');
    }

    update();
  }

  Future<void> cancelOrder(int orderId) async {
    orderState = StatusRequest.loading;
    update();

    try {
      final response = await orderData.cancelOrderData(orderId);

      if (response is StatusRequest) {
        orderState = response;
        showOrderError(orderState);
      } else {
        orderState = StatusRequest.success;
        await _active.clear();
        Get.snackbar('تم الإلغاء', 'تم إلغاء الطلب بنجاح');
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar('خطأ', 'حدث خطأ: ${e.toString()}');
    }

    update();
  }

  void loadActiveOrder() {
    _active.loadFromSession();
    update();
  }

  Future<void> checkTimerAndAutoConfirm() async {
    loadActiveOrder();
    final id = _active.orderId;
    if (id == null || !_active.shouldAutoConfirm()) return;
    await confirmOrder(id);
  }

  bool hasActiveOrder() => _active.hasActive;

  int getRemainingCancelSeconds() => _active.remainingCancelSeconds();

  @override
  void onInit() {
    super.onInit();
    loadActiveOrder();
    checkTimerAndAutoConfirm();
  }
}
