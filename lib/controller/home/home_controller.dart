import 'dart:async';

import 'package:app/controller/home/home_controller_catalog.dart';
import 'package:app/controller/home/home_controller_sections.dart';
import 'package:app/controller/home/home_controller_slider.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/model/home_section_model.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/main_categores.dart';
import 'package:app/data/datasource/model/section_model.dart';
import 'package:app/data/datasource/model/slider_model.dart';
import 'package:app/data/datasource/remot/all_item_data.dart';
import 'package:app/data/datasource/remot/home_section_data.dart';
import 'package:app/data/datasource/remot/main_categores_data.dart';
import 'package:app/data/datasource/remot/slider_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeController extends GetxController {
  Future<void> fetchSliders();
  Future<void> fetchMainCategores();
  Future<void> fetchAllItem();
  Future<void> fetchHomeSection();
  Future<List<SectionModel>> fetchSection(String sectionName);
  void updateSection(int id, String name);
}

class HomeControllerImp extends HomeController {
  final session = Get.find<SessionService>();

  int get cityId => session.cityId ?? 1;

  SliderData sliderData = SliderData(Get.find());
  StatusRequest sliderStat = StatusRequest.none;
  List<SliderModel> slides = [];
  List<SliderModel> extendedSlides = [];
  var currentIndex = 0.obs;
  PageController? pageController;
  Duration autoPlayDelay = const Duration(seconds: 2);
  final Duration transitionSpeed = const Duration(milliseconds: 500);
  final int initialPage = 1;
  bool isDisposedFlag = false;

  MainCategoresData mainCategoresData = MainCategoresData(Get.find());
  StatusRequest mainCatStat = StatusRequest.none;
  List<MainCategoriesModel> mainCat = [];
  int? selectedCategoryId;

  List<HomeSectionModel> homeSection = [];
  List<SectionModel> sectionModel = [];
  Map<String, List<SectionModel>> finalSection = {};
  StatusRequest sectionState = StatusRequest.none;
  StatusRequest homeSectionState = StatusRequest.none;
  StatusRequest finalSectionState = StatusRequest.none;
  HomeSectionData homeSectionData = HomeSectionData(Get.find());

  int selectedType = 0;
  String sectionName = '';

  /// Section products follow the selected category's stores.
  /// The section endpoint currently returns the same list for every category.
  List<SectionModel> sectionItemsFor(String key) {
    final all = finalSection[key] ?? const <SectionModel>[];
    if (allItemState != StatusRequest.success) return const [];
    final storeIds = <int>{
      for (final shop in items)
        if (shop.id != null) shop.id!,
    };
    return [
      for (final item in all)
        if (item.storeId != null && storeIds.contains(item.storeId)) item,
    ];
  }

  List<SectionModel> get currentSectionItems => sectionItemsFor(sectionName);

  bool get hasSectionItemsForCategory {
    if (allItemState != StatusRequest.success) return false;
    if (homeSection.isEmpty) return currentSectionItems.isNotEmpty;
    return homeSection.any((section) {
      final key = section.type ?? section.name ?? '';
      return key.isNotEmpty && sectionItemsFor(key).isNotEmpty;
    });
  }

  StatusRequest allItemState = StatusRequest.none;
  int homeLoadGeneration = 0;
  AllItemData allItemData = AllItemData(Get.find());
  List<ItemModel> items = [];

  @override
  Future<void> fetchSliders() => runFetchSliders();

  @override
  Future<void> fetchMainCategores() => runFetchMainCategores();

  @override
  Future<void> fetchAllItem() => runFetchAllItem();

  @override
  Future<void> fetchHomeSection() => runFetchHomeSection();

  @override
  Future<List<SectionModel>> fetchSection(String sectionName) =>
      runFetchSection(sectionName);

  @override
  void updateSection(int id, String name) => runUpdateSection(id, name);

  void onPageChanged(int index) => runOnPageChanged(index);

  /// الهيكل يغطي أعلى الصفحة فقط: السلايدر والأقسام.
  /// المنتجات والمتاجر تكمل التحميل تحتها بدون ما تحبس أول رسم.
  bool get isInitialLoading {
    if (mainCat.isNotEmpty || slides.isNotEmpty) return false;
    return mainCatStat != StatusRequest.failure &&
        sliderStat != StatusRequest.failure;
  }

  Future<void> selectCategory(int? categoryId) async {
    homeLoadGeneration++;
    selectedCategoryId = categoryId;
    sliderStat = StatusRequest.loading;
    allItemState = StatusRequest.loading;
    homeSectionState = StatusRequest.loading;
    finalSectionState = StatusRequest.loading;
    slides = [];
    extendedSlides = [];
    items = [];
    homeSection = [];
    finalSection = {};
    update();

    await Future.wait([fetchSliders(), fetchAllItem(), fetchHomeSection()]);
  }

  @override
  void onInit() async {
    super.onInit();
    if (slides.isNotEmpty && mainCat.isNotEmpty) {
      if (extendedSlides.isEmpty) {
        extendedSlides = [slides.last, ...slides, slides.first];
        pageController = PageController(initialPage: initialPage);
        runStartAutoPlay();
      }
      update();
      return;
    }
    if (slides.isEmpty && mainCat.isEmpty) {
      mainCatStat = StatusRequest.loading;
      sliderStat = StatusRequest.loading;
    }
    await fetchMainCategores();
    if (selectedCategoryId == null && mainCat.isNotEmpty) {
      selectedCategoryId = mainCat.first.id;
    }
    await fetchSliders();
    setupSliderAfterLoad();
    update();
    unawaited(_loadBelowTheFold());
  }

  Future<void> _loadBelowTheFold() async {
    await fetchHomeSection();
    if (isDisposedFlag) return;
    await fetchAllItem();
  }

  @override
  void onClose() {
    isDisposedFlag = true;
    pageController?.dispose();
    super.onClose();
  }
}
