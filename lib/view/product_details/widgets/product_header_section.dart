import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/view/product_details/product_details_actions.dart';
import 'package:flutter/material.dart';

class ProductHeaderSection extends StatelessWidget {
  const ProductHeaderSection({super.key, required this.product});

  final ProductDetailsModel? product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 330,
            width: double.infinity,
            color: Colors.black12,
            child: Image.network(
              product?.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(Assets.imagesLogo, fit: BoxFit.cover);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Text(
              formatProductPrice(product?.priceInt ?? 0),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor().primaryColor,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 3,
              child: Text(
                product?.name ?? 'منتج',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColor().titleColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    (product?.ratingValue ?? 0).toStringAsFixed(1),
                    style: TextStyle(
                      color: AppColor().titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 16, color: AppColor().primaryColor),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: AppColor().primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.motorcycle_rounded,
                      size: 16,
                      color: AppColor().primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'وقت توصيل مقدّر',
                    style: TextStyle(
                      color: AppColor().descriptionColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    product?.deliveryTime?.trim().isNotEmpty == true
                        ? product!.deliveryTime!
                        : '15-25 دقيقة',
                    style: TextStyle(
                      color: AppColor().titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
