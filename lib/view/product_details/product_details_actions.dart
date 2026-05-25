import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/data/datasource/model/product_review_model.dart';
import 'package:app/view/product_details/widgets/product_review_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String formatProductPrice(int price) => '$price ل.س';

void openRecommendedProduct({
  required int? recId,
  required int? storeId,
  required String? storeName,
  required String? storeImageUrl,
  required String? storeDeliveryFee,
}) {
  if (recId == null || recId <= 0) {
    Get.snackbar('تنبيه', 'معرّف المنتج غير متوفر');
    return;
  }

  Get.toNamed(
    AppRoutes.productDetails,
    arguments: {
      'productId': recId,
      'storeId': storeId,
      'storeName': storeName,
      'storeImageUrl': storeImageUrl,
      'storeDeliveryFee': storeDeliveryFee,
    },
    preventDuplicates: false,
  );
}

bool isMyProductReview(
  ProductDetailsController controller,
  ProductReviewModel review,
) {
  final myIdStr = (controller.session.userId ?? '').trim();
  if (myIdStr.isEmpty) return false;
  return myIdStr == (review.userId?.toString() ?? '') ||
      myIdStr == (review.user?.id?.toString() ?? '');
}

void openAddProductReviewSheet(ProductDetailsController controller) {
  Get.bottomSheet(
    ProductReviewFormSheet(
      controller: controller,
      title: 'أضف تقييمك',
      submitText: 'إرسال التقييم',
      onSubmit: controller.submitReview,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void openEditProductReviewSheet(
  ProductDetailsController controller,
  ProductReviewModel review,
) {
  controller.beginEditReview(review);
  Get.bottomSheet(
    ProductReviewFormSheet(
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

Future<void> confirmDeleteProductReview(
  ProductDetailsController controller,
  ProductReviewModel review,
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
