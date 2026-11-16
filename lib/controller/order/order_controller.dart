import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/profile/account_controller.dart';
import 'package:app/controller/order/order_active_session.dart';
import 'package:app/controller/order/order_error_handler.dart';
import 'package:app/controller/order/order_payload_builder.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/order_data.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

class OrderController extends GetxController {
  final OrderData orderData = OrderData(Get.find());
  final SessionService session = Get.find<SessionService>();
  late final OrderActiveSession _active = OrderActiveSession(session);

  StatusRequest orderState = StatusRequest.none;
  bool isCreatingOrder = false;

  int? get currentOrderId => _active.orderId;
  set currentOrderId(int? value) => _active.orderId = value;

  DateTime? get orderCreatedAt => _active.createdAt;
  set orderCreatedAt(DateTime? value) => _active.createdAt = value;

  Future<void> createOrder(String? notes) async {
    if (isCreatingOrder) return;

    final token = session.token;
    if (token == null || token.isEmpty || session.isGuest) {
      AppSnackbar.show('تنبيه', 'يجب تسجيل الدخول أولاً');
      Get.toNamed(AppRoutes.login);
      return;
    }

    if (!await Get.find<AccountController>().ensureName()) return;
    if (isCreatingOrder || !session.isLoggedIn) return;

    final cartController = Get.find<CartController>();
    if (cartController.isEmpty) {
      AppSnackbar.show('تنبيه', 'السلة فارغة');
      return;
    }

    final orderDataMap = buildOrderPayload(
      cart: cartController,
      notes: notes,
    );
    final items = (orderDataMap['cart'] as Map)['items'];
    if (items is! List || items.isEmpty) {
      AppSnackbar.show('تنبيه', 'تعذر تجهيز منتجات السلة. أعد إضافتها');
      return;
    }
    final latitude = orderDataMap['latitude'];
    final longitude = orderDataMap['longitude'];
    final address = orderDataMap['address']?.toString().trim() ?? '';
    if (latitude is! num ||
        longitude is! num ||
        latitude == 0 ||
        longitude == 0 ||
        address.isEmpty) {
      AppSnackbar.show('تنبيه', 'الرجاء اختيار عنوان توصيل بموقع صالح');
      return;
    }

    isCreatingOrder = true;
    orderState = StatusRequest.loading;
    update();

    try {
      final response = await orderData.createOrderData(orderDataMap);
      if (isClosed) return;
      orderState = handlingData(response);

      if (response is OrderRequestFailure) {
        orderState = response.status;
        showOrderError(orderState, detail: response.message);
      } else if (response is StatusRequest) {
        orderState = response;
        showOrderError(orderState);
      } else if (response is Map) {
        orderState = StatusRequest.success;
        final orderBody = Map<String, dynamic>.from(response);

        final orderId = _readOrderId(orderBody);
        if (orderId != null) {
          await _active.persist(orderId, DateTime.now());
          Get.toNamed(AppRoutes.orderConfirmation, arguments: orderId);
          return;
        }

        AppSnackbar.show('خطأ', 'فشل في الحصول على رقم الطلب');
        orderState = StatusRequest.failure;
      } else {
        orderState = StatusRequest.failure;
        AppSnackbar.show('خطأ', 'فشل في إنشاء الطلب');
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      AppSnackbar.show('خطأ', 'حدث خطأ: ${e.toString()}');
    } finally {
      isCreatingOrder = false;
      update();
    }
  }

  Future<void> confirmOrder(int orderId) async {
    final token = session.token;
    if (token == null || token.isEmpty) {
      AppSnackbar.show('تنبيه', 'يجب تسجيل الدخول أولاً');
      Get.toNamed(AppRoutes.login);
      return;
    }

    isCreatingOrder = false;
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
        AppSnackbar.show('نجاح', 'تم تأكيد الطلب بنجاح');
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      AppSnackbar.show('خطأ', 'حدث خطأ: ${e.toString()}');
    }

    update();
  }

  Future<void> cancelOrder(int orderId) async {
    final token = session.token;
    if (token == null || token.isEmpty) {
      AppSnackbar.show('تنبيه', 'يجب تسجيل الدخول أولاً');
      Get.toNamed(AppRoutes.login);
      return;
    }

    isCreatingOrder = false;
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
        AppSnackbar.show('تم الإلغاء', 'تم إلغاء الطلب بنجاح');
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      AppSnackbar.show('خطأ', 'حدث خطأ: ${e.toString()}');
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

  int? _readOrderId(Map<String, dynamic> body) {
    final direct = _asOrderId(body['order_id'] ?? body['id']);
    if (direct != null) return direct;

    final data = body['data'];
    if (data is Map) {
      final nested = _asOrderId(data['order_id'] ?? data['id']);
      if (nested != null) return nested;
    }

    final order = body['order'];
    if (order is Map) {
      return _asOrderId(order['order_id'] ?? order['id']);
    }
    return null;
  }

  int? _asOrderId(dynamic value) {
    if (value is int && value > 0) return value;
    if (value is num && value > 0) return value.toInt();
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  @override
  void onInit() {
    super.onInit();
    loadActiveOrder();
    checkTimerAndAutoConfirm();
  }
}
