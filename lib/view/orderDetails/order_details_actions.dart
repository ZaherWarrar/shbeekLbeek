import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

Future<void> reorderPreviousOrder(OrderHisModel order) async {
  final cart = Get.find<CartController>();
  final hasActive = cart.hasActiveOrder() ||
      (Get.isRegistered<OrderController>() &&
          Get.find<OrderController>().hasActiveOrder());

  if (hasActive) {
    AppSnackbar.show(
      'تنبيه',
      'يوجد طلب قيد المعالجة. لا يمكن إعادة الطلب الآن',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  if ((order.items ?? const []).isEmpty) {
    AppSnackbar.show('تنبيه', 'لا توجد منتجات لإعادة طلبها');
    return;
  }

  if (cart.cartItems.isNotEmpty) {
    final replace = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppColor().backgroundColorCard,
        title: Text(
          'استبدال السلة',
          style: TextStyle(
            color: AppColor().titleColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'السلة تحتوي على منتجات. هل تريد استبدالها بمنتجات هذا الطلب؟',
          style: TextStyle(color: AppColor().descriptionColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColor().primaryColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor().primaryColor,
              foregroundColor: AppColor().textButomColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('استبدال'),
          ),
        ],
      ),
    );
    if (replace != true) return;
  }

  final filled = await cart.fillFromPreviousOrder(order);
  if (!filled) {
    AppSnackbar.show('فشل', 'تعذر تعبئة السلة بهذا الطلب');
    return;
  }

  AppSnackbar.show('تم', 'تمت تعبئة السلة بمنتجات الطلب');
  Get.toNamed(AppRoutes.cartView);
}
