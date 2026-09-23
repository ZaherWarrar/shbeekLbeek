import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:flutter/material.dart';

class OrderDetailsProductCard extends StatelessWidget {
  const OrderDetailsProductCard({super.key, required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColor();
    final product = item.product;
    final imageUrl = product?.imageUrl?.trim() ?? '';
    final price = item.singlePrice ?? product?.salePrice?.toString() ?? '0';

    return Card(
      color: colors.backgroundColorCard,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 90,
                height: 90,
                child: imageUrl.isEmpty
                    ? Image.asset(Assets.imagesLogo, fit: BoxFit.cover)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Image.asset(
                          Assets.imagesLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.name?.trim().isNotEmpty == true
                        ? product!.name!.trim()
                        : 'منتج',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.titleColor,
                    ),
                  ),
                  if (product?.description?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Text(
                      product!.description!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.descriptionColor,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'السعر: $price ل.س',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                  if (item.variationName?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.variationName!.trim(),
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.descriptionColor,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'العدد: ${item.quantity ?? 0}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
