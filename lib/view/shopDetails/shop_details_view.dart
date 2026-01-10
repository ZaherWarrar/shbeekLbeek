import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/view/shopDetails/widgets/add_review_card.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:app/view/shopDetails/widgets/category_with_items.dart';
import 'package:app/view/shopDetails/widgets/information_shop_card.dart';
import 'package:app/view/shopDetails/widgets/review_header.dart';
import 'package:app/view/shopDetails/widgets/rivew_Item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsView extends StatelessWidget {
  const ShopDetailsView({super.key});

  final Map<String, dynamic> shopData = const {
    "reviews": [
      {
        "name": "سارة عبدالله",
        "time": "منذ يومين",
        "rating": 5,
        "comment": "البرجر كان رائع والتوصيل سريع جداً، أنصح به بشدة!",
      },
      {
        "name": "محمد علي",
        "time": "منذ أسبوع",
        "rating": 4,
        "comment": "الطعم جيد ولكن البطاطس كانت باردة قليلاً عند وصولها.",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: const CartFloatingButton(),
            backgroundColor: AppColor().backgroundColor,
            appBar: CustomAppBar(title: controller.shopItem.name ?? "المطعم"),
            body: SingleChildScrollView(
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
                            controller.shopItem.imageUrl ?? "",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// العنوان
                      ReviewHeader(),

                      SizedBox(height: h * 0.02),

                      /// إضافة تقييم
                      const AddReviewCardWidget(),

                      SizedBox(height: h * 0.02),

                      /// Loop على التعليقات
                      ...shopData["reviews"].map<Widget>((review) {
                        return Column(
                          children: [
                            ReviewItemWidget(
                              name: review["name"],
                              time: review["time"],
                              rating: review["rating"],
                              comment: review["comment"],
                            ),
                            SizedBox(height: h * 0.015),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
