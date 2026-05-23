import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewFormSheet extends StatefulWidget {
  const ProductReviewFormSheet({
    super.key,
    required this.controller,
    required this.title,
    required this.submitText,
    required this.onSubmit,
    this.onClose,
  });

  final ProductDetailsController controller;
  final String title;
  final String submitText;
  final Future<void> Function() onSubmit;
  final VoidCallback? onClose;

  @override
  State<ProductReviewFormSheet> createState() => _ProductReviewFormSheetState();
}

class _ProductReviewFormSheetState extends State<ProductReviewFormSheet> {
  ProductDetailsController get c => widget.controller;

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColor().titleColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onClose ?? () => Get.back(),
                  icon: Icon(Icons.close, color: AppColor().titleColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                final filled = star <= c.reviewRating;
                return IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: c.isSubmittingReview
                      ? null
                      : () {
                          c.setReviewRating(star);
                          _refresh();
                        },
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: AppColor().primaryColor,
                  ),
                );
              }),
            ),
            TextField(
              controller: c.reviewTextController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'ملاحظات (اختياري)',
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: c.isSubmittingReview
                    ? null
                    : () async {
                        _refresh();
                        await widget.onSubmit();
                        _refresh();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: c.isSubmittingReview
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(widget.submitText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
