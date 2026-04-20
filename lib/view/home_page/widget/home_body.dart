import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/core/shared/custom_slider.dart';
import 'package:app/view/home_page/widget/all_shops_widget.dart';
import 'package:app/view/home_page/widget/category_slider.dart';
import 'package:app/view/home_page/widget/category_type/category_type.dart';
import 'package:app/view/home_page/widget/custom_home_app_bar.dart';
import 'package:app/view/home_page/widget/home_skeleton_placeholder.dart';
import 'package:app/view/profile/profile_view.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<HomeControllerImp>();
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomDeliveryAppBar(),
      floatingActionButton: const CartFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(ProfileView());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor().primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<HomeControllerImp>(
        builder: (controller) {
          final body = controller.isInitialLoading
              ? Skeletonizer(
                  enabled: true,
                  child: const HomeSkeletonPlaceholder(),
                )
              : ListView(
                  children: [
                    const SizedBox(height: 10),
                    SliderWidget(
                      controller: controller,
                      imageWidth: 310,
                      height: 175,
                      borderRadius: 20,
                      interval: const Duration(seconds: 5),
                    ),
                    const SizedBox(height: 10),
                    CategorySlider(controller: controller),
                    const SizedBox(height: 25),
                    CategoryType(),
                    const SizedBox(height: 25),
                    AllShops(),
                  ],
                );
          return CustomRefresh(
            statusRequest: controller.sliderStat,
            fun: () async {
              await controller.fetchSliders();
              await controller.fetchMainCategores();
              await controller.fetchAllItem();
              await controller.fetchHomeSection();
            },
            body: body,
            preferBodyWhenLoading: true,
          );
        },
      ),
    );
  }
}
