import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:app/view/shopDetails/widgets/category_with_items.dart';
import 'package:app/view/shopDetails/widgets/information_shop_card.dart';
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
                                onPressed: () {
                                  Get.bottomSheet(
                                    GetBuilder<ShopDetailsController>(
                                      builder: (c) {
                                        return Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColor().backgroundColor,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          child: SafeArea(
                                            top: false,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'أضف تقييمك',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: AppColor()
                                                            .titleColor,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: AppColor()
                                                            .titleColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children:
                                                      List.generate(5, (i) {
                                                    final star = i + 1;
                                                    final filled =
                                                        star <= c.reviewRating;
                                                    return IconButton(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      onPressed:
                                                          c.isSubmittingReview
                                                              ? null
                                                              : () => c
                                                                  .setReviewRating(
                                                                      star),
                                                      icon: Icon(
                                                        filled
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: AppColor()
                                                            .primaryColor,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                                TextField(
                                                  controller:
                                                      c.reviewTextController,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'ملاحظات (اختياري)',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 48,
                                                  child: ElevatedButton(
                                                    onPressed:
                                                        c.isSubmittingReview
                                                            ? null
                                                            : () =>
                                                                c.submitReview(),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColor()
                                                              .primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                    ),
                                                    child: c.isSubmittingReview
                                                        ? const SizedBox(
                                                            height: 18,
                                                            width: 18,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : const Text(
                                                            'إرسال التقييم',
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
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
                                  .map((r) {
                                final userName = r.user?.name ?? 'مستخدم';
                                final rating = (r.rating ?? 0).clamp(0, 5);
                                final text = (r.text ?? '').trim();
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.03,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            userName,
                                            style: TextStyle(
                                              color: AppColor().titleColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: List.generate(5, (i) {
                                              final filled =
                                                  (i + 1) <= rating;
                                              return Icon(
                                                filled
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                size: 16,
                                                color:
                                                    AppColor().primaryColor,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                      if (text.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          text,
                                          style: TextStyle(
                                            color:
                                                AppColor().descriptionColor,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }).toList(),
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
