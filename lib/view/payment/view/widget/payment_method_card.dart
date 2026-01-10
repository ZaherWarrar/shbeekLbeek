import 'package:app/core/constant/app_color.dart';
import 'package:app/view/payment/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/payment_method_model.dart';

class PaymentMethodCard extends GetView<PaymentController> {
  final PaymentMethodModel method;

  const PaymentMethodCard({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedMethodId.value == method.id;

      return GestureDetector(
        onTap: () => controller.selectMethod(method.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor().backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColor().primaryColor : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(method.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  method.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColor().primaryColor : Colors.transparent,
                  border: Border.all(color: AppColor().descriptionColor),
                ),
                child: isSelected
                    ?  Icon(Icons.check, size: 14, color: AppColor().backgroundColor)
                    : null,
              )
            ],
          ),
        ),
      );
    });
  }
}
