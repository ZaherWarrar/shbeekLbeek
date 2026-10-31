import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/view/product_details/product_details_actions.dart';
import 'package:flutter/material.dart';

double productHeroImageHeight(double width) =>
    (width * 0.82).clamp(210.0, 360.0);

class ProductHeaderSection extends StatelessWidget {
  const ProductHeaderSection({super.key, required this.product});

  final ProductDetailsModel? product;

  @override
  Widget build(BuildContext context) {
    final deliveryTime = product?.deliveryTime?.trim().isNotEmpty == true
        ? product!.deliveryTime!.trim()
        : '15-25 دقيقة';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: productHeroImageHeight(constraints.maxWidth),
                width: double.infinity,
                color: Colors.black12,
                child: Image.network(
                  product?.imageUrl ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Assets.imagesLogo, fit: BoxFit.cover);
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                product?.name ?? 'منتج',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                  color: AppColor().titleColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatProductPrice(product?.priceInt ?? 0),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColor().primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _MetaChip(
              icon: Icons.star_rounded,
              label: (product?.ratingValue ?? 0).toStringAsFixed(1),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: _MetaChip(
                icon: Icons.motorcycle_rounded,
                label: 'توصيل $deliveryTime',
                expand: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.expand = false,
  });

  final IconData icon;
  final String label;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColor().titleColor,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    );

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColor().primaryColor),
          const SizedBox(width: 6),
          if (expand) Expanded(child: text) else text,
        ],
      ),
    );
  }
}
