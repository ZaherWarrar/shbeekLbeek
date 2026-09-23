import 'package:app/controller/bottomNavBar/main_controller.dart';
import 'package:app/controller/home/home_controller.dart';
import 'package:app/view/bottomNavBar/widget/custom_bottom_nav.dart';
import 'package:app/view/external_delivery/external_delivery_view.dart';
import 'package:app/view/favorites/favorites_view.dart';
import 'package:app/view/home_page/home_page_view.dart';
import 'package:app/view/orderHistoory/order_his_view.dart';
import 'package:app/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  MainView({super.key});

  final controller = Get.put(MainController());

  final pages = [
    HomePageView(),
    const ExternalDeliveryView(),
    OrderHistoryPage(),
    FavoritesView(),
    ProfileView(),
  ];

  DateTime? lastBackPressed;

  // دالة معالجة الرجوع (يمكنك الاحتفاظ بها أو دمجها مباشرة)
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

      AppSnackbar.show(
        "تنبيه",
        "اضغط مرة أخرى للخروج",
        snackPosition: SnackPosition.BOTTOM,
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
    if (!Get.isRegistered<HomeControllerImp>()) {
      Get.put(HomeControllerImp(), permanent: true);
    }
    // الـ Widget المعدل
    return Obx(
      () => PopScope(
        canPop: false, // نمنع الرجوع التلقائي
        // ignore: deprecated_member_use
        onPopInvoked: (bool didPop) async {
          if (!didPop) {
            // استدعاء نفس منطق _onWillPop
            final shouldPop = await _onWillPop();

            // إذا كان shouldPop = true، SystemNavigator.pop() تم استدعاؤها بالفعل في _onWillPop
            // لذا لا نحتاج لفعل شيء إضافي
          }
        },
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
