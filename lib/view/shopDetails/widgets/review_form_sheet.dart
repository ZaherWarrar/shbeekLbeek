import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewFormSheet extends StatelessWidget {
  final ShopDetailsController controller;
  final String title;
  final String submitText;
  final VoidCallback onSubmit;
  final VoidCallback? onClose;

  const ReviewFormSheet({
    super.key,
    required this.controller,
    required this.title,
    required this.submitText,
    required this.onSubmit,
    this.onClose,
  });

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
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColor().titleColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onClose ?? () => Get.back(),
                  icon: Icon(Icons.close, color: AppColor().titleColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                final filled = star <= controller.reviewRating;
                return IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.isSubmittingReview
                      ? null
                      : () => controller.setReviewRating(star),
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: AppColor().primaryColor,
                  ),
                );
              }),
            ),
            TextField(
              controller: controller.reviewTextController,
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
                onPressed: controller.isSubmittingReview ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: controller.isSubmittingReview
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(submitText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
