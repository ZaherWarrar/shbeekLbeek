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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          product?.description ?? '',
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: AppColor().descriptionColor,
          ),
        ),
        if (isVariable) ...[
          const SizedBox(height: 18),
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
        const SizedBox(height: 18),
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
          decoration: InputDecoration(
            hintText: 'مثال: بدون سكر / زيادة صوص...',
            filled: true,
            fillColor: Colors.white,
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
