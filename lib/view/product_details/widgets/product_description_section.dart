import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/view/product_details/widgets/product_variation_selector.dart';
import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatelessWidget {
  const ProductDescriptionSection({
    super.key,
    required this.product,
    required this.controller,
    required this.isVariable,
  });

  final ProductDetailsModel? product;
  final ProductDetailsController controller;
  final bool isVariable;

  @override
  Widget build(BuildContext context) {
    final description = product?.description?.trim() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty) ...[
          Text(
            'الوصف',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColor().titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColor().descriptionColor,
            ),
          ),
        ],
        if (description.isNotEmpty && isVariable) const SizedBox(height: 18),
        if (isVariable) ...[
          Text(
            'اختر خيار المنتج',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColor().titleColor,
            ),
          ),
          const SizedBox(height: 10),
          ProductVariationSelector(
            variations: product!.variations,
            selectedVariations: controller.selectedVariations,
            onToggle: controller.toggleVariation,
          ),
        ],
        if (description.isNotEmpty || isVariable) const SizedBox(height: 18),
        Text(
          'ملاحظة على المنتج (اختياري)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColor().titleColor,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.itemNotesController,
          maxLines: 2,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintText: 'مثال: بدون سكر / زيادة صوص...',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
