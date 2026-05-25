import 'package:app/controller/cart/cart_delivery_utils.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/cart_preferences.dart';
import 'package:app/data/datasource/remot/coupons_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartCouponHandler {
  CartCouponHandler({
    required this.discountCodeController,
    required this.prefs,
    required this.onStateChanged,
    required this.getSubtotal,
  });

  final TextEditingController discountCodeController;
  final CartPreferences prefs;
  final VoidCallback onStateChanged;
  final double Function() getSubtotal;

  String? discountCode;
  double discountAmount = 0.0;
  double discountPercentage = 0.0;
  String? couponMessage;
  bool isCheckingCoupon = false;

  double get calculatedDiscount => calculateDiscount(
        subtotal: getSubtotal(),
        discountCode: discountCode,
        discountPercentage: discountPercentage,
        discountAmount: discountAmount,
      );

  Future<void> apply() async {
    final code = discountCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال كود الخصم');
      return;
    }

    isCheckingCoupon = true;
    couponMessage = null;
    onStateChanged();

    try {
      final response = await CouponsData(Get.find<Crud>()).couponsCheckData(code);

      if (response is StatusRequest) {
        _resetDiscount();
        _showError(response);
        isCheckingCoupon = false;
        onStateChanged();
        return;
      }

      if (response is Map<String, dynamic>) {
        final valid = response['valid'] == true;
        final message = response['message']?.toString();

        if (valid && message != null && message.isNotEmpty) {
          couponMessage = message;
          discountCode = code;
          discountPercentage = 0.0;
          discountAmount = 0.0;
          _applyDetails(response['details']);
          await prefs.saveDiscountCode(code);
          Get.snackbar('نجاح', message);
        } else {
          couponMessage = message ?? 'كود الخصم غير صالح';
          _resetDiscount();
          Get.snackbar('خطأ', couponMessage!);
        }
      } else {
        couponMessage = 'كود الخصم غير صالح';
        _resetDiscount();
        Get.snackbar('خطأ', couponMessage!);
      }
    } catch (_) {
      _resetDiscount();
      Get.snackbar('خطأ', 'حدث خطأ أثناء التحقق من الكوبون');
      isCheckingCoupon = false;
      onStateChanged();
      return;
    }

    isCheckingCoupon = false;
    onStateChanged();
  }

  void _applyDetails(dynamic details) {
    if (details is! Map<String, dynamic>) return;
    final type = details['type']?.toString().toLowerCase();
    final value = double.tryParse(details['value']?.toString() ?? '') ?? 0.0;
    if (type == 'fixed') {
      discountAmount = value;
    } else if (type == 'percent' || type == 'percentage') {
      discountPercentage = value.clamp(0.0, 100.0);
    }
  }

  void _resetDiscount() {
    discountCode = null;
    discountPercentage = 0.0;
    discountAmount = 0.0;
  }

  void _showError(StatusRequest status) {
    switch (status) {
      case StatusRequest.unauthorized:
        Get.snackbar('تنبيه', 'يجب تسجيل الدخول لاستخدام كود الخصم');
        break;
      case StatusRequest.offlinefailure:
        Get.snackbar('خطأ', 'لا يوجد اتصال بالإنترنت');
        break;
      case StatusRequest.serverfailure:
      case StatusRequest.serverException:
        Get.snackbar('خطأ', 'خطأ في الخادم، حاول لاحقاً');
        break;
      default:
        Get.snackbar('خطأ', 'كود الخصم غير صالح أو منتهي');
    }
  }

  Future<void> remove() async {
    discountCode = null;
    discountCodeController.clear();
    discountPercentage = 0.0;
    discountAmount = 0.0;
    couponMessage = null;
    await prefs.removeDiscountCode();
    onStateChanged();
  }

  void restoreFromPrefs(String? savedCode) {
    discountCode = savedCode;
    if (savedCode != null) {
      discountCodeController.text = savedCode;
    }
  }
}
