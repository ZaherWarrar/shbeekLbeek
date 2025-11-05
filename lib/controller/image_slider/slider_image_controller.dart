// lib/app/controller/image_slider/slider_image_controller.dart
import 'package:app/data/datasorce/model/slider_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SliderController extends GetxController {
  final List<SliderModel> slides = [
    SliderModel(imageUrl: 'https://picsum.photos/id/1011/800/400'),
    SliderModel(imageUrl: 'https://picsum.photos/id/1012/800/400'),
    SliderModel(imageUrl: 'https://picsum.photos/id/1013/800/400'),
    SliderModel(imageUrl: 'https://picsum.photos/id/1015/800/400'),
  ];

  late List<SliderModel> extendedSlides;
  var currentIndex = 0.obs;
  late PageController pageController;

  Duration autoPlayDelay = const Duration(seconds: 2);
  final Duration transitionSpeed = const Duration(milliseconds: 500);
  final int initialPage = 1;

  @override
  void onInit() {
    super.onInit();

    // 🔁 نكرر الصور: نضيف آخر صورة في البداية وأول صورة في النهاية
    extendedSlides = [slides.last, ...slides, slides.first];

    pageController = PageController(initialPage: initialPage);
    _startAutoPlay();
  }

  void _startAutoPlay() async {
    while (true) {
      await Future.delayed(autoPlayDelay);
      if (!pageController.hasClients) continue;

      int nextPage = pageController.page!.toInt() + 1;
      pageController.animateToPage(
        nextPage,
        duration: transitionSpeed,
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;

    // 🔁 إذا وصلنا لأول أو آخر صفحة وهمية، نرجع للصفحة الحقيقية
    if (index == 0) {
      Future.delayed(transitionSpeed, () {
        pageController.jumpToPage(slides.length);
      });
    } else if (index == slides.length + 1) {
      Future.delayed(transitionSpeed, () {
        pageController.jumpToPage(1);
      });
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
