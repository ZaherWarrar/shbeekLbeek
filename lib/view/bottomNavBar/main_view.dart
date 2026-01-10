import 'package:app/controller/bottomNavBar/main_controller.dart';
import 'package:app/view/bottomNavBar/widget/custom_bottom_nav.dart';
import 'package:app/view/favorets/favorites_view.dart';
import 'package:app/view/home_page/home_page_view.dart';
import 'package:app/view/orderHistoory/view/order_his_view.dart';
import 'package:app/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final controller = Get.put(MainController());

  final pages = [
    HomePageView(),
    OrderHistoryPage(),
    FavoritesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: pages[controller.currentIndex.value],
          bottomNavigationBar: CustomBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
          ),
        ),
      ),
    );
  }
}
