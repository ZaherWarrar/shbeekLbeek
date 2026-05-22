import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:app/view/shopDetails/widgets/category_with_items.dart';
import 'package:app/data/datasorce/model/store_review_model.dart';
import 'package:app/view/shopDetails/widgets/information_shop_card.dart';
import 'package:app/view/shopDetails/widgets/review_form_sheet.dart';
import 'package:app/view/shopDetails/widgets/shop_review_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsView extends StatelessWidget {
  const ShopDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: const CartFloatingButton(),
            backgroundColor: AppColor().backgroundColor,
            appBar: CustomAppBar(
              title:
                  controller.store?.name ?? controller.shopItemSummary?.name ?? "المطعم",
            ),
            body: CustomRefresh(
              statusRequest: controller.statusRequest,
              fun: () => controller.refreshPage(),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // صورة المطعم + معلوماته
                    SizedBox(
                      height: 320,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: Image.network(
                              controller.store?.imageUrl ??
                                  controller.shopItemSummary?.imageUrl ??
                                  "",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.imagesLogo,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 140,
                            left: 8,
                            right: 8,
                            child: InformationShopCard(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    //======================== search text field ==============
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: "بحث",
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 126, 126, 126),
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 126, 126, 126),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColor().descriptionColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColor().primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //=================== Loop on categories ===================
                    CategoryWithItems(),
                    const SizedBox(height: 30),

                    //================التقييمات للمطعم=============
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'التقييمات',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor().titleColor,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor().primaryColor,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: () => _openAddReviewSheet(controller),
                                child: const Text('إضافة تقييم'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (context) {
                              final rr = controller.reviewsResponse;
                              final avg = rr?.averageRating ?? 0;
                              final total = rr?.totalReviews ?? 0;
                              return Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          avg.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: AppColor().titleColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: AppColor().primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '($total تقييم)',
                                    style: TextStyle(
                                      color: AppColor().descriptionColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          if (controller.reviewsStatus == StatusRequest.loading)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          else if (controller.reviewsResponse == null ||
                              controller.reviewsResponse!.reviews.isEmpty)
                            Text(
                              'لا يوجد تقييمات حالياً',
                              style: TextStyle(
                                color: AppColor().descriptionColor,
                              ),
                            )
                          else
                            Column(
                              children: controller.reviewsResponse!.reviews
                                  .take(3)
                                  .map(
                                    (r) => ShopReviewCard(
                                      review: r,
                                      isMine: _isMyReview(controller, r),
                                      onEdit: () => _openEditReviewSheet(
                                        controller,
                                        r,
                                      ),
                                      onDelete: () => _confirmDeleteReview(
                                        controller,
                                        r,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

bool _isMyReview(ShopDetailsController controller, StoreReviewModel review) {
  final myIdStr = (controller.session.userId ?? '').trim();
  if (myIdStr.isEmpty) return false;
  return myIdStr == (review.userId?.toString() ?? '') ||
      myIdStr == (review.user?.id?.toString() ?? '');
}

void _openAddReviewSheet(ShopDetailsController controller) {
  Get.bottomSheet(
    GetBuilder<ShopDetailsController>(
      builder: (c) => ReviewFormSheet(
        controller: c,
        title: 'أضف تقييمك',
        submitText: 'إرسال التقييم',
        onSubmit: c.submitReview,
      ),
    ),
    isScrollControlled: true,
  );
}

void _openEditReviewSheet(
  ShopDetailsController controller,
  StoreReviewModel review,
) {
  controller.beginEditReview(review);
  Get.bottomSheet(
    GetBuilder<ShopDetailsController>(
      builder: (c) => ReviewFormSheet(
        controller: c,
        title: 'تعديل التقييم',
        submitText: 'حفظ التعديل',
        onSubmit: c.updateReview,
        onClose: () {
          c.resetReviewForm();
          Get.back();
        },
      ),
    ),
    isScrollControlled: true,
  );
}

Future<void> _confirmDeleteReview(
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
