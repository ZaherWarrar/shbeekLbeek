import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/shopDetails/shop_details_actions.dart';
import 'package:app/view/shopDetails/widgets/shop_review_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsReviewsSection extends StatelessWidget {
  const ShopDetailsReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        final rr = controller.reviewsResponse;
        final avg = rr?.averageRating ?? 0;
        final total = rr?.totalReviews ?? 0;

        return Padding(
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
                      textStyle: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () => openAddShopReviewSheet(controller),
                    child: const Text('إضافة تقييم'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
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
              ),
              const SizedBox(height: 10),
              if (controller.reviewsStatus == StatusRequest.loading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (rr == null || rr.reviews.isEmpty)
                Text(
                  'لا يوجد تقييمات حالياً',
                  style: TextStyle(color: AppColor().descriptionColor),
                )
              else
                Column(
                  children: rr.reviews
                      .take(3)
                      .map(
                        (r) => ShopReviewCard(
                          review: r,
                          isMine: isMyShopReview(controller, r),
                          onEdit: () => openEditShopReviewSheet(controller, r),
                          onDelete: () =>
                              confirmDeleteShopReview(controller, r),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
