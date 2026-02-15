import 'package:app/core/constant/app_color.dart';
import 'package:app/view/orderHistoory/model/order_his_model.dart';
import 'package:app/view/orderHistoory/view/widget/status_chip.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderHisModel order;
  final int index;

  const OrderCard({super.key, required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    final isActive = order.status == OrderHisModel.statusActive;
    final total = order.total ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColor().backgroundColor,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
                    // ignore: deprecated_member_use
                    color: AppColor().primaryColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.restaurant, color: AppColor().primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.restaurantName ?? "",
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
                  "$total ل.س",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor().primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "تاريخ الطلب: ${order.date!.year}-${order.date!.month.toString().padLeft(2, '0')}-${order.date!.day.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor().descriptionColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
