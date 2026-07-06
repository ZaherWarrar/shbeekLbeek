import 'package:app/controller/cart/cart_coupon_utils.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/cart_preferences.dart';
import 'package:app/data/datasource/model/coupon_check_model.dart';
import 'package:app/data/datasource/remot/coupons_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartCouponHandler {
  CartCouponHandler({
    required this.discountCodeController,
    required this.prefs,
    required this.onStateChanged,
    required this.getCartItems,
  });

  final TextEditingController discountCodeController;
  final CartPreferences prefs;
  final VoidCallback onStateChanged;
  final List<Map<String, dynamic>> Function() getCartItems;

  String? discountCode;
  CouponDetails couponDetails = const CouponDetails(type: '', value: 0);
  CouponRestrictions couponRestrictions = const CouponRestrictions();
  String? couponMessage;
  bool isCheckingCoupon = false;

  double get discountAmount =>
      couponDetails.isFixed ? couponDetails.value : 0.0;

  double get discountPercentage =>
      couponDetails.isPercent ? couponDetails.value : 0.0;

  double get calculatedDiscount => calculateCouponDiscount(
        cartItems: getCartItems(),
        discountCode: discountCode,
        details: couponDetails,
        restrictions: couponRestrictions,
      );

  Future<void> apply({bool silent = false}) async {
    final code = discountCodeController.text.trim();
    if (code.isEmpty) {
      if (!silent) Get.snackbar('تنبيه', 'الرجاء إدخال كود الخصم');
      return;
    }

    isCheckingCoupon = true;
    if (!silent) couponMessage = null;
    onStateChanged();

    try {
      final response =
          await CouponsData(Get.find<Crud>()).couponsCheckData(code);

      if (response is StatusRequest) {
        _resetDiscount();
        if (!silent) _showError(response);
        isCheckingCoupon = false;
        onStateChanged();
        return;
      }

      if (response is Map<String, dynamic>) {
        _applyCouponResult(CouponCheckModel.fromJson(response), code, silent);
      } else {
        couponMessage = 'كود الخصم غير صالح';
        _resetDiscount();
        if (!silent) Get.snackbar('خطأ', couponMessage!);
      }
    } catch (_) {
      _resetDiscount();
      if (!silent) {
        Get.snackbar('خطأ', 'حدث خطأ أثناء التحقق من الكوبون');
      }
      isCheckingCoupon = false;
      onStateChanged();
      return;
    }

    isCheckingCoupon = false;
    onStateChanged();
  }

  void _applyCouponResult(
    CouponCheckModel result,
    String code, [
    bool silent = false,
  ]) {
    final message = result.message;

    if (!result.valid) {
      couponMessage = message ?? 'كود الخصم غير صالح';
      _resetDiscount();
      if (!silent) Get.snackbar('خطأ', couponMessage!);
      return;
    }

    if (!result.details.isPercent && !result.details.isFixed) {
      couponMessage = message ?? 'كود الخصم غير صالح';
      _resetDiscount();
      if (!silent) Get.snackbar('خطأ', couponMessage!);
      return;
    }

    discountCode = code;
    couponDetails = result.details;
    couponRestrictions = result.restrictions;
    couponMessage = message;

    final discount = calculatedDiscount;
    if (discount <= 0) {
      couponMessage = result.restrictions.appliesToWholeCart
          ? (message ?? 'الكوبون لا ينطبق على السلة الحالية')
          : 'الكوبون لا ينطبق على منتجات السلة الحالية';
      if (!silent) {
        Get.snackbar('تنبيه', couponMessage!);
      }
    } else if (!silent) {
      Get.snackbar('نجاح', message ?? 'تم تطبيق كود الخصم');
    }

    prefs.saveDiscountCode(code);
  }

  void _resetDiscount() {
    discountCode = null;
    couponDetails = const CouponDetails(type: '', value: 0);
    couponRestrictions = const CouponRestrictions();
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
    couponDetails = const CouponDetails(type: '', value: 0);
    couponRestrictions = const CouponRestrictions();
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

  Future<void> revalidateSavedCode() async {
    final code = discountCode ?? prefs.getDiscountCode();
    if (code == null || code.isEmpty) return;
    discountCodeController.text = code;
    await apply(silent: true);
  }
}
