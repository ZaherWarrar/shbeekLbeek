import 'package:app/core/constant/app_color.dart';
import 'package:app/view/orderHistoory/view/widget/status_chip.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final dynamic order;
  final int index;

  const OrderCard({
    super.key,
    required this.order,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = order.status == "نشط";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColor().backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColor().titleColor.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColor().primaryColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: AppColor().primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.restaurantName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor().titleColor,
                    ),
                  ),
                ),
                StatusChip(isActive: isActive),
              ],
            ),

            const SizedBox(height: 14),
            Divider(color: AppColor().backgroundColor),
            const SizedBox(height: 12),

            /// FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 18,
                      color: AppColor().descriptionColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "رقم الطلب #${index + 1}",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor().descriptionColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${order.total} ر.س",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor().primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
