import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasorce/remot/order_data.dart';
import 'package:get/get.dart';
import 'package:app/view/adress/controller/address_controller.dart';

class OrderController extends GetxController {
  final OrderData orderData = OrderData(Get.find());
  final SessionService session = Get.find<SessionService>();

  StatusRequest orderState = StatusRequest.none;

  int? currentOrderId;
  DateTime? orderCreatedAt;

  // ================================
  // إنشاء طلب جديد
  // ================================
  Future<void> createOrder(String? notes) async {
    // التحقق من وجود token
    final token = session.token;
    if (token == null || token.isEmpty) {
      Get.snackbar("تنبيه", "يجب تسجيل الدخول أولاً");
      Get.toNamed(AppRoutes.login);
      return;
    }

    // الحصول على بيانات السلة
    final cartController = Get.find<CartController>();
    if (cartController.isEmpty) {
      Get.snackbar("تنبيه", "السلة فارغة");
      return;
    }

    // تحويل cartItems إلى الصيغة المطلوبة من API
    List<Map<String, dynamic>> items = cartController.cartItems
        .where((item) => item['productId'] != null)
        .map((item) {
      return {
        "product": {"id": item['productId'] as int},
        "quantity": item['quantity'] as int,
      };
    }).toList();

    // إعداد بيانات الطلب
    final addressController = Get.find<AddressController>();
    final defaultAddressList = addressController.addresses.where(
      (address) => address.isDefault,
    );

    double latitude;
    double longitude;
    if (defaultAddressList.isNotEmpty) {
      final address = defaultAddressList.first;
      latitude = address.lat;
      longitude = address.lng;
    } else {
      latitude = addressController.selectedLat.value;
      longitude = addressController.selectedLng.value;
    }

    Map<String, dynamic> orderDataMap = {
      "cart": {"items": items},
      "latitude": latitude,
      "longitude": longitude,
    };

    if (notes != null && notes.trim().isNotEmpty) {
      orderDataMap["notes"] = notes.trim();
    }

    orderState = StatusRequest.loading;
    update();

    try {
      var response = await orderData.createOrderData(orderDataMap);
      orderState = handelingData(response);

      if (response is StatusRequest) {
        orderState = response;
        _handleOrderError(orderState);
      } else if (response is Map<String, dynamic>) {
        orderState = StatusRequest.success;

        currentOrderId = response['order_id'] as int?;
        orderCreatedAt = DateTime.now();

        if (currentOrderId != null) {
          // حفظ الطلب النشط في SessionService
          await session.saveActiveOrder(currentOrderId!, orderCreatedAt!);

          // الانتقال لصفحة التأكيد
          Get.toNamed(AppRoutes.orderConfirmation,
              arguments: currentOrderId);
        } else {
          Get.snackbar("خطأ", "فشل في الحصول على رقم الطلب");
          orderState = StatusRequest.failure;
        }
      } else {
        orderState = StatusRequest.failure;
        Get.snackbar("خطأ", "فشل في إنشاء الطلب");
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar("خطأ", "حدث خطأ: ${e.toString()}");
    }

    update();
  }

  // ================================
  // تأكيد الطلب
  // ================================
  Future<void> confirmOrder(int orderId) async {
    orderState = StatusRequest.loading;
    update();

    try {
      var response = await orderData.confirmOrderData(orderId);

      if (response is StatusRequest) {
        orderState = response;
        _handleOrderError(orderState);
      } else {
        orderState = StatusRequest.success;

        // مسح الطلب النشط
        await session.clearActiveOrder();

        // مسح السلة
        final cartController = Get.find<CartController>();
        cartController.clearCart();

        currentOrderId = null;
        orderCreatedAt = null;

        Get.snackbar("نجاح", "تم تأكيد الطلب بنجاح");
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar("خطأ", "حدث خطأ: ${e.toString()}");
    }

    update();
  }

  // ================================
  // إلغاء الطلب
  // ================================
  Future<void> cancelOrder(int orderId) async {
    orderState = StatusRequest.loading;
    update();

    try {
      var response = await orderData.cancelOrderData(orderId);

      if (response is StatusRequest) {
        orderState = response;
        _handleOrderError(orderState);
      } else {
        orderState = StatusRequest.success;

        await session.clearActiveOrder();

        currentOrderId = null;
        orderCreatedAt = null;

        Get.snackbar("تم الإلغاء", "تم إلغاء الطلب بنجاح");
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar("خطأ", "حدث خطأ: ${e.toString()}");
    }

    update();
  }

  // ================================
  // تحميل الطلب النشط
  // ================================
  void loadActiveOrder() {
    final activeOrder = session.activeOrder;

    if (activeOrder != null) {
      currentOrderId = activeOrder['orderId'];
      orderCreatedAt = activeOrder['createdAt'];
      update();
    }
  }

  // ================================
  // التحقق من المؤقت
  // ================================
  Future<void> checkTimerAndAutoConfirm() async {
    loadActiveOrder();

    if (currentOrderId == null || orderCreatedAt == null) return;

    final remainingSeconds = getRemainingCancelSeconds();

    if (remainingSeconds <= 0) {
      await confirmOrder(currentOrderId!);
    }
  }

  // ================================
  // التحقق من وجود طلب نشط
  // ================================
  bool hasActiveOrder() {
    return session.hasActiveOrder;
  }

  // ================================
  // حساب الوقت المتبقي للإلغاء
  // ================================
  int getRemainingCancelSeconds() {
    if (orderCreatedAt == null) return 0;

    final now = DateTime.now();
    final difference = now.difference(orderCreatedAt!);

    const totalSeconds = 10 * 60;
    final remaining = totalSeconds - difference.inSeconds;

    return remaining > 0 ? remaining : 0;
  }

  @override
  void onInit() {
    super.onInit();
    loadActiveOrder();
    checkTimerAndAutoConfirm();
  }

  // ================================
  // معالجة الأخطاء
  // ================================
  void _handleOrderError(StatusRequest status) {
    switch (status) {
      case StatusRequest.unauthorized:
        Get.snackbar("خطأ", "غير مصرح لك. يرجى تسجيل الدخول");
        Get.toNamed(AppRoutes.login);
        break;

      case StatusRequest.forbidden:
        Get.snackbar("خطأ", "غير مسموح لك بهذا الإجراء");
        break;

      case StatusRequest.notFound:
        Get.snackbar("خطأ", "الطلب غير موجود");
        break;

      case StatusRequest.serverfailure:
        Get.snackbar("خطأ", "خطأ في الخادم");
        break;

      case StatusRequest.offlinefailure:
        Get.snackbar("خطأ", "لا يوجد اتصال بالإنترنت");
        break;

      default:
        Get.snackbar("خطأ", "فشل في العملية");
    }
  }
}