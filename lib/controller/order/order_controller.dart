import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/data/datasorce/remot/order_data.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  OrderData orderData = OrderData(Get.find());
  UserPreferences userPreferences = UserPreferences();

  StatusRequest orderState = StatusRequest.none;
  int? currentOrderId;
  DateTime? orderCreatedAt;

  // إنشاء طلب جديد
  Future<void> createOrder(String? notes) async {
    // التحقق من وجود token
    final token = await userPreferences.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "يجب تسجيل الدخول أولاً",
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.login);
      return;
    }

    // الحصول على بيانات السلة
    final cartController = Get.find<CartController>();
    if (cartController.isEmpty) {
      Get.snackbar("تنبيه", "السلة فارغة", snackPosition: SnackPosition.BOTTOM);
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
        })
        .toList();

    // إعداد بيانات الطلب
    Map<String, dynamic> orderDataMap = {
      "cart": {"items": items},
    };

    // إضافة الملاحظات إذا كانت موجودة
    if (notes != null && notes.trim().isNotEmpty) {
      orderDataMap["notes"] = notes.trim();
    }

    orderState = StatusRequest.loading;
    update();

    try {
      var response = await orderData.createOrderData(orderDataMap);
      orderState = handelingData(response);

      // التحقق من نوع response
      if (response is StatusRequest) {
        // إذا كان StatusRequest، يعني فشل
        orderState = response;
        _handleOrderError(orderState);
      } else if (response is Map<String, dynamic>) {
        // إذا كان Map، يعني نجاح
        orderState = StatusRequest.success;
        currentOrderId = response['order_id'] as int?;
        orderCreatedAt = DateTime.now();

        if (currentOrderId != null && orderCreatedAt != null) {
          // حفظ الطلب النشط في SharedPreferences
          await userPreferences.saveActiveOrder(
            currentOrderId!,
            orderCreatedAt!,
          );
          // الانتقال لصفحة التأكيد
          Get.toNamed(AppRoutes.orderConfirmation, arguments: currentOrderId);
        } else {
          Get.snackbar(
            "خطأ",
            "فشل في الحصول على رقم الطلب",
            snackPosition: SnackPosition.BOTTOM,
          );
          orderState = StatusRequest.failure;
        }
      } else {
        // حالة غير متوقعة
        orderState = StatusRequest.failure;
        Get.snackbar(
          "خطأ",
          "فشل في إنشاء الطلب. يرجى المحاولة مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  // تأكيد الطلب
  Future<void> confirmOrder(int orderId) async {
    orderState = StatusRequest.loading;
    update();

    try {
      var response = await orderData.confirmOrderData(orderId);

      if (response is StatusRequest) {
        // فشل
        orderState = response;
        _handleOrderError(orderState);
      } else {
        // نجاح
        orderState = StatusRequest.success;
        // مسح الطلب النشط من SharedPreferences
        await userPreferences.clearActiveOrder();
        // مسح السلة بعد التأكيد الناجح
        final cartController = Get.find<CartController>();
        cartController.clearCart();

        // إعادة تعيين المتغيرات
        currentOrderId = null;
        orderCreatedAt = null;

        Get.snackbar(
          "نجاح",
          "تم تأكيد الطلب بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );

        // الانتقال للصفحة الرئيسية
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar(
        "خطأ",
        "حدث خطأ: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  // إلغاء الطلب
  Future<void> cancelOrder(int orderId) async {
    orderState = StatusRequest.loading;
    update();

    try {
      var response = await orderData.cancelOrderData(orderId);

      if (response is StatusRequest) {
        // فشل
        orderState = response;
        _handleOrderError(orderState);
      } else {
        // نجاح
        orderState = StatusRequest.success;
        // مسح الطلب النشط من SharedPreferences
        await userPreferences.clearActiveOrder();
        Get.snackbar(
          "تم الإلغاء",
          "تم إلغاء الطلب بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );

        // إعادة تعيين المتغيرات
        currentOrderId = null;
        orderCreatedAt = null;

        // العودة للصفحة الرئيسية
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      orderState = StatusRequest.failure;
      Get.snackbar(
        "خطأ",
        "حدث خطأ: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  // التحقق من إمكانية الإلغاء (خلال 10 دقائق)
  bool canCancelOrder() {
    if (orderCreatedAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(orderCreatedAt!);
    return difference.inMinutes < 10;
  }

  // الحصول على الوقت المتبقي للإلغاء (بالثواني)
  int getRemainingCancelSeconds() {
    if (orderCreatedAt == null) return 0;
    final now = DateTime.now();
    final difference = now.difference(orderCreatedAt!);
    final totalSeconds = 10 * 60; // 10 دقائق بالثواني
    final remaining = totalSeconds - difference.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  // تحميل الطلب النشط من SharedPreferences
  void loadActiveOrder() {
    final activeOrder = userPreferences.getActiveOrder();
    if (activeOrder != null) {
      currentOrderId = activeOrder['orderId'] as int?;
      orderCreatedAt = activeOrder['createdAt'] as DateTime?;
      update();
    }
  }

  // التحقق من العداد والتأكيد التلقائي
  Future<void> checkTimerAndAutoConfirm() async {
    // تحميل الطلب النشط
    loadActiveOrder();

    if (currentOrderId == null || orderCreatedAt == null) {
      return;
    }

    // حساب الوقت المتبقي
    final remainingSeconds = getRemainingCancelSeconds();

    // إذا انتهى الوقت، تأكيد الطلب تلقائياً
    if (remainingSeconds <= 0) {
      await confirmOrder(currentOrderId!);
    }
  }

  // التحقق من وجود طلب نشط
  bool hasActiveOrder() {
    return userPreferences.hasActiveOrder();
  }

  @override
  void onInit() {
    super.onInit();
    // تحميل الطلب النشط عند بدء التطبيق
    loadActiveOrder();
    // التحقق من العداد والتأكيد التلقائي
    checkTimerAndAutoConfirm();
  }

  // معالجة أخطاء الطلب
  void _handleOrderError(StatusRequest status) {
    switch (status) {
      case StatusRequest.unauthorized:
        Get.snackbar(
          "خطأ",
          "غير مصرح لك. يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(AppRoutes.login);
        break;
      case StatusRequest.forbidden:
        Get.snackbar(
          "خطأ",
          "غير مسموح لك بهذا الإجراء",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case StatusRequest.notFound:
        Get.snackbar(
          "خطأ",
          "الطلب غير موجود",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case StatusRequest.serverfailure:
        Get.snackbar(
          "خطأ",
          "حدث خطأ في الخادم. يرجى المحاولة لاحقاً",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case StatusRequest.offlinefailure:
        Get.snackbar(
          "خطأ",
          "لا يوجد اتصال بالإنترنت",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      default:
        Get.snackbar(
          "خطأ",
          "فشل في العملية. يرجى المحاولة مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }
}
