import 'package:app/controller/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountCodeWidget extends StatelessWidget {
  const DiscountCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        final hasDiscount =
            controller.discountCode != null &&
            controller.discountCode!.isNotEmpty;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.discountCodeController,
                    enabled: !hasDiscount,
                    decoration: InputDecoration(
                      hintText: hasDiscount
                          ? "كود الخصم: ${controller.discountCode}"
                          : "أدخل رمز الخصم",
                      filled: true,
                      fillColor: hasDiscount ? Colors.grey[100] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: hasDiscount ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (hasDiscount)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.removeDiscount();
                    },
                    child: const Text(
                      "إزالة",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.isCheckingCoupon
                        ? null
                        : () => controller.applyDiscount(),
                    child: controller.isCheckingCoupon
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.orange,
                            ),
                          )
                        : const Text(
                            "تطبيق",
                            style: TextStyle(color: Colors.orange),
                          ),
                  ),
              ],
            ),
            if (controller.couponMessage != null &&
                controller.couponMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(
                      hasDiscount ? Icons.check_circle : Icons.info_outline,
                      color: hasDiscount ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        controller.couponMessage!,
                        style: TextStyle(
                          color: hasDiscount ? Colors.green : Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (hasDiscount && controller.calculatedDiscount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.discount, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      controller.discountPercentage > 0
                          ? "خصم ${controller.discountPercentage.toStringAsFixed(0)}%"
                          : "خصم ${controller.discountAmount.toStringAsFixed(0)} ليرة",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
