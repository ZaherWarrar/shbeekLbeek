import 'package:app/controller/bottomNavBar/main_controller.dart';
import 'package:app/view/bottomNavBar/widget/custom_bottom_nav.dart';
import 'package:app/view/favorets/favorites_view.dart';
import 'package:app/view/home_page/home_page_view.dart';
import 'package:app/view/orderHistoory/view/order_his_view.dart';
import 'package:app/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  MainView({super.key});

  final controller = Get.put(MainController());

  final pages = [
    HomePageView(),
    OrderHistoryPage(),
    FavoritesView(),
    ProfileView(),
  ];

  DateTime? lastBackPressed;

  Future<bool> _onWillPop() async {
    // إذا مو على أول تاب → رجعه للأول
    if (controller.currentIndex.value != 0) {
      controller.changeIndex(0);
      return false;
    }

    // إذا على أول تاب
    DateTime now = DateTime.now();

    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;

      Get.snackbar(
        "تنبيه",
        "اضغط مرة أخرى للخروج",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: const Color.fromARGB(37, 0, 0, 0),
        colorText: const Color.fromARGB(255, 0, 0, 0),
        duration: const Duration(seconds: 2),
      );

      return false;
    }

    // إذا ضغط مرتين خلال ثانيتين → يخرج
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      // ignore: deprecated_member_use
      () => WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            body: pages[controller.currentIndex.value],
            bottomNavigationBar: CustomBottomNav(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeIndex,
            ),
          ),
        ),
      ),
    );
  }
}
