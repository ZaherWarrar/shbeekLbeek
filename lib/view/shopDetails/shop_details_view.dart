import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/main.dart';
import 'package:app/view/shopDetails/widgets/add_review_card.dart';
import 'package:app/view/shopDetails/widgets/category_with_items.dart';
import 'package:app/view/shopDetails/widgets/information_shop_card.dart';
import 'package:app/view/shopDetails/widgets/review_header.dart';
import 'package:app/view/shopDetails/widgets/rivew_Item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsView extends StatelessWidget {
  const ShopDetailsView({super.key});

  // بيانات المطعم كـ Map
  final Map<String, dynamic> shopData = const {
    "name": "برغر فاكتوري",
    "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNyxROQqSOaNVtxtelIF4lz6EPzCDBCAax0A&s",
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {
          Get.toNamed(AppRoutes.cartView);
        },
      ),
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomAppBar(title: shopData["name"]),
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
                    child: Image.network(shopData["image"], fit: BoxFit.cover),
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
    );
  }
}
