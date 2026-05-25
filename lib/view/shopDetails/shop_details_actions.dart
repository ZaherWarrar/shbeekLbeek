import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/store_review_model.dart';
import 'package:app/view/shopDetails/widgets/review_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isMyShopReview(ShopDetailsController controller, StoreReviewModel review) {
  final myIdStr = (controller.session.userId ?? '').trim();
  if (myIdStr.isEmpty) return false;
  return myIdStr == (review.userId?.toString() ?? '') ||
      myIdStr == (review.user?.id?.toString() ?? '');
}

void openAddShopReviewSheet(ShopDetailsController controller) {
  Get.bottomSheet(
    ReviewFormSheet(
      controller: controller,
      title: 'أضف تقييمك',
      submitText: 'إرسال التقييم',
      onSubmit: controller.submitReview,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void openEditShopReviewSheet(
  ShopDetailsController controller,
  StoreReviewModel review,
) {
  controller.beginEditReview(review);
  Get.bottomSheet(
    ReviewFormSheet(
      controller: controller,
      title: 'تعديل التقييم',
      submitText: 'حفظ التعديل',
      onSubmit: controller.updateReview,
      onClose: () {
        controller.resetReviewForm();
        Get.back();
      },
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Future<void> confirmDeleteShopReview(
  ShopDetailsController controller,
  StoreReviewModel review,
) async {
  final reviewId = review.id;
  if (reviewId == null || reviewId <= 0) return;

  final ok = await Get.dialog<bool>(
    Dialog(
      backgroundColor: AppColor().backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'حذف التقييم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColor().titleColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'هل أنت متأكد من حذف التقييم؟',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColor().descriptionColor,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor().titleColor,
                      side: BorderSide(color: Colors.grey.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'حذف',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  if (ok == true) {
    await controller.deleteReview(reviewId);
  }
}
