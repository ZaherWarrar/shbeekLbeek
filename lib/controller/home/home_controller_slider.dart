import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/slider_model.dart';
import 'package:flutter/material.dart';

extension HomeSliderLogic on HomeControllerImp {
  List<SliderModel> get _defaultSlides => [
        SliderModel(id: -1, title: 'default_ad', imageUrl: Assets.imagesAd1),
        SliderModel(id: -2, title: 'default_ad', imageUrl: Assets.imagesAd2),
      ];

  void _prepareSliderPages() {
    if (slides.isEmpty) {
      slides = _defaultSlides;
    }
    extendedSlides = [slides.last, ...slides, slides.first];
    pageController?.dispose();
    pageController = null;
  }

  Future<void> runFetchSliders() async {
    sliderStat = StatusRequest.loading;
    update();
    final response =
        await sliderData.sliderData(cityId, categoryId: selectedCategoryId);
    sliderStat = handlingData(response);
    if (sliderStat == StatusRequest.success) {
      slides = [];
      if (response is List) {
        slides = response
            .map<SliderModel>((item) => SliderModel.fromJson(item))
            .toList();
      }
      _prepareSliderPages();
      update();
    } else {
      sliderStat = StatusRequest.failure;
      slides = [];
      _prepareSliderPages();
      update();
    }
  }

  void runStartAutoPlay() async {
    while (!isDisposedFlag) {
      await Future.delayed(autoPlayDelay);
      if (isDisposedFlag ||
          pageController == null ||
          !pageController!.hasClients) {
        continue;
      }

      final currentPage = pageController!.page;
      if (currentPage == null) continue;

      int nextPage = currentPage.toInt() + 1;
      if (nextPage > extendedSlides.length - 1) {
        nextPage = 0;
      }
      pageController!.animateToPage(
        nextPage,
        duration: transitionSpeed,
        curve: Curves.easeInOut,
      );
    }
  }

  void runOnPageChanged(int index) {
    currentIndex.value = index;

    if (pageController == null || !pageController!.hasClients) return;

    if (index == 0) {
      Future.delayed(transitionSpeed, () {
        if (pageController != null && pageController!.hasClients) {
          pageController!.jumpToPage(slides.length);
        }
      });
    } else if (index == slides.length + 1) {
      Future.delayed(transitionSpeed, () {
        if (pageController != null && pageController!.hasClients) {
          pageController!.jumpToPage(1);
        }
      });
    }
  }

  void setupSliderAfterLoad() {
    _prepareSliderPages();
    pageController = PageController(initialPage: initialPage);
    runStartAutoPlay();
  }
}
