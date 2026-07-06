import 'package:app/controller/cart/cart_delivery_utils.dart';
import 'package:app/controller/cart/cart_group_utils.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class CartShopSection extends StatelessWidget {
  const CartShopSection({
    super.key,
    required this.group,
    required this.itemBuilder,
  });

  final CartShopGroup group;
  final Widget Function(Map<String, dynamic> item) itemBuilder;

  String _deliveryFeeLabel() {
    final fee = parseDeliveryFee(group.deliveryFee) ?? 0;
    if (fee <= 0) return 'توصيل مجاني';
    return '${fee.toStringAsFixed(0)} ليرة';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor().primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor().primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.storefront_outlined, color: AppColor().primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.shopName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor().titleColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${group.items.length} منتج',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor().titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _deliveryFeeLabel(),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor().primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),        const SizedBox(height: 10),
        ...group.items.map(itemBuilder),
        const SizedBox(height: 8),
      ],
    );
  }
}
