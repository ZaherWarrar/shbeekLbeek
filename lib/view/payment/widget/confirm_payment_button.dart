import 'package:app/core/constant/app_color.dart';
import 'package:app/controller/payment/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmPaymentButton extends GetView<PaymentController> {
  const ConfirmPaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ElevatedButton(
        onPressed: controller.isSelected
            ? () {
                // 👉 هون بتبعت للباك
                final selectedId = controller.selectedMethodId.value;
                // ignore: avoid_print
                print('Selected payment: $selectedId');
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor().primaryColor,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child:  Text(
          'تأكيد طريقة الدفع',
          style: TextStyle(fontSize: 16, color: AppColor().backgroundColor),
        ),
      );
    });
  }
}
