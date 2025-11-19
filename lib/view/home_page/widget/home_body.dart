import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/core/shared/custom_loding_page.dart';
import 'package:app/core/shared/custom_slider.dart';
import 'package:app/view/home_page/widget/all_shops_widget.dart';
import 'package:app/view/home_page/widget/category_slider.dart';
import 'package:app/view/home_page/widget/category_type/category_type.dart';
import 'package:app/view/home_page/widget/custom_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Register once; GetBuilder will rebuild when update() is called in the controller.
    Get.put(HomeControllerImp());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: CustomDeliveryAppBar(),
      body: GetBuilder<HomeControllerImp>(
        builder: (controller) {
          return ListView(
            
            children: [
              const SizedBox(height: 10),
              //==================== السلايدر الرئيسي ========
              CustomLodingPage(
                statusRequest: controller.sliderStat,
                body: SliderWidget(
                  controller: controller,
                  imageWidth: 310,
                  height: 175, // ارتفاع السلايدر
                  borderRadius: 20, // انحناء الحواف
                  interval: const Duration(seconds: 5), // مدة الانتقال التلقائي
                  onTapActions: [
                    // ignore: avoid_print
                    () => print("تم الضغط على السلايدر 1"),
                    // ignore: avoid_print
                    () => print("تم الضغط على السلايدر 2"),
                    // ignore: avoid_print
                    () => print("تم الضغط على السلايدر 3"),
                    // ignore: avoid_print
                    () => print("تم الضغط على السلايدر 4"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomLodingPage(
                statusRequest: controller.mainCatStat,
                body: CategorySlider(controller: controller),
              ),
              const SizedBox(height: 25),
              CategoryType(),
              const SizedBox(height: 25),
             

              AllShops(),
            ],
          );
        },
      ),
    );
  }
}
