import 'package:app/controller/orderHistoory/order_items_group_utils.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/orderDetails/order_details_product_card.dart';
import 'package:flutter/material.dart';

class OrderDetailsShopSection extends StatelessWidget {
  const OrderDetailsShopSection({super.key, required this.group});

  final OrderShopGroup group;

  @override
  Widget build(BuildContext context) {
    final colors = AppColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.storefront_outlined, color: colors.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.shopName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.titleColor,
                  ),
                ),
              ),
              Text(
                '${group.items.length} منتج',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.titleColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...group.items.map((item) => OrderDetailsProductCard(item: item)),
        const SizedBox(height: 8),
      ],
    );
  }
}
