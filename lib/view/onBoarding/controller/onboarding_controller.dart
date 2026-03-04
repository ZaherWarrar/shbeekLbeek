import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/view/onBoarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  int index = 0;

  final pages = <OnboardingModel>[
    OnboardingModel(
      title: "تصفح أفضل المطاعم والمتاجر",
      desc: "اكتشف مجموعة واسعة من المطاعم والمحلات في مدينتك بكل سهولة.",
      image: "assets/images/first_onBo.png",
    ),
    OnboardingModel(
      title: "توصيل سريع وآمن",
      desc: "نحن نضمن وصول طلباتك في أسرع وقت ممكن وبأفضل حالة.",
      image: "assets/images/delev_moto.png",
    ),
    OnboardingModel(
      title: "استمتع بطلبك!",
      desc: "كل ما تحتاجه هو ضغطة زر واحدة لتصلك طلباتك أينما كنت.",
      image: "assets/images/delev_boy.png",
    ),
  ];

  void onPageChanged(int i) {
    index = i;
    update();
  }

  Future<void> next() async {
    if (index == pages.length - 1) {
      await finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skip() async {
    await finish();
  }

Future<void> finish() async {
  final session = Get.find<SessionService>();

  await session.setOnboardingDone(true);

  Get.offAllNamed(AppRoutes.login); 

}

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}