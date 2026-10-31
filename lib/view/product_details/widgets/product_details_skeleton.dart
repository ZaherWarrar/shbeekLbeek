import 'package:app/core/constant/app_color.dart';
import 'package:app/view/product_details/product_details_actions.dart';
import 'package:app/view/product_details/widgets/product_header_section.dart';
import 'package:flutter/material.dart';

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({
    super.key,
    this.imageUrl,
    this.name,
    this.price,
  });

  final String? imageUrl;
  final String? name;
  final int? price;

  @override
  Widget build(BuildContext context) {
    final previewName = name?.trim() ?? '';
    final previewImage = imageUrl?.trim() ?? '';
    final hasImage = previewImage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = productHeroImageHeight(constraints.maxWidth);
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: hasImage
                    ? Image.network(
                        previewImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _Bone(height: imageHeight, radius: 0),
                      )
                    : _Bone(height: imageHeight, radius: 0),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            if (previewName.isNotEmpty)
              Expanded(
                child: Text(
                  previewName,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                    color: AppColor().titleColor,
                  ),
                ),
              )
            else
              const Expanded(child: _Bone(width: 150, height: 18)),
            const SizedBox(width: 12),
            if (price != null)
              Text(
                formatProductPrice(price!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColor().primaryColor,
                ),
              )
            else
              const _Bone(width: 88, height: 18),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            _Bone(width: 72, height: 36, radius: 18),
            SizedBox(width: 8),
            _Bone(width: 132, height: 36, radius: 18),
          ],
        ),
        const SizedBox(height: 22),
        const _Bone(width: 72, height: 16),
        const SizedBox(height: 10),
        const _Bone(height: 12),
        const SizedBox(height: 8),
        const _Bone(height: 12),
        const SizedBox(height: 8),
        const _Bone(width: 220, height: 12),
        const SizedBox(height: 22),
        const _Bone(width: 140, height: 16),
        const SizedBox(height: 12),
        const _Bone(height: 72, radius: 14),
        const SizedBox(height: 22),
        const _Bone(width: 120, height: 16),
        const SizedBox(height: 12),
        const SizedBox(
          height: 120,
          child: Row(
            children: [
              _Bone(width: 140, height: 120, radius: 16),
              SizedBox(width: 12),
              _Bone(width: 140, height: 120, radius: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductDetailsBottomSkeleton extends StatelessWidget {
  const ProductDetailsBottomSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(
          children: [
            _Bone(width: 48, height: 48, radius: 14),
            SizedBox(width: 12),
            Expanded(child: _Bone(height: 52, radius: 16)),
          ],
        ),
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    this.width,
    required this.height,
    this.radius = 8,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
