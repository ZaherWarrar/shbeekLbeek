import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasorce/model/home_section_model.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:app/data/datasorce/model/main_categores.dart';
import 'package:app/data/datasorce/model/section_model.dart';
import 'package:app/data/datasorce/model/slider_model.dart';
import 'package:app/data/datasorce/remot/all_item_data.dart';
import 'package:app/data/datasorce/remot/home_section_data.dart';
import 'package:app/data/datasorce/remot/main_categores_data.dart';
import 'package:app/data/datasorce/remot/slider_data.dart';
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
  late final int cityId = session.cityId??1;
  // ============= Slider =================================================
  SliderData sliderData = SliderData(Get.find());
  StatusRequest sliderStat = StatusRequest.none;
  List<SliderModel> slides = [];
  List<SliderModel> extendedSlides = [];
  var currentIndex = 0.obs;
  PageController? pageController;
  Duration autoPlayDelay = const Duration(seconds: 2);
  final Duration transitionSpeed = const Duration(milliseconds: 500);
  final int initialPage = 1;
  bool _isDisposed = false;
  // ============ Main Categores ===============================================
  MainCategoresData mainCategoresData = MainCategoresData(Get.find());
  StatusRequest mainCatStat = StatusRequest.none;
  List<MainCategoriesModel> mainCat = [];
  // ============ home section =============================================
  List<HomeSectionModel> homeSection = [];
  List<SectionModel> sectionModel = [];
  Map<String, List<SectionModel>> finalSection = {};
  StatusRequest sectionState = StatusRequest.none;
  StatusRequest homeSectionState = StatusRequest.none;
  StatusRequest finalSectionState = StatusRequest.none;
  HomeSectionData homeSectionData = HomeSectionData(Get.find());

  int selectedType = 0;
  String sectionName = "";
  // ============== All Item Var ===============================================
  StatusRequest allItemState = StatusRequest.none;
  AllItemData allItemData = AllItemData(Get.find());
  List<ItemModel> items = [];

  // ==============  Slider ====================================================
  @override
  Future<void> fetchSliders() async {
    sliderStat = StatusRequest.loading;
    update();
    var response = await sliderData.sliderData(cityId);
    sliderStat = handelingData(response);
    if (sliderStat == StatusRequest.success) {
      List<dynamic> sliderList = [];

      if (response is List) {
        sliderList = response;
        slides = sliderList
            .map<SliderModel>((item) => SliderModel.fromJson(item))
            .toList();
      }
      update();
    } else {
      sliderStat = StatusRequest.failure;
      update();
    }
  }

  // ==============  Slider =================================================

  void _startAutoPlay() async {
    while (!_isDisposed) {
      await Future.delayed(autoPlayDelay);
      if (_isDisposed || pageController == null || !pageController!.hasClients)
        continue;

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
  // ==============  Slider =================================================

  void onPageChanged(int index) {
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
  // ==============  Main Categores =================================================

  @override
  Future<void> fetchMainCategores() async {
    mainCatStat = StatusRequest.loading;
    update();
    var response = await mainCategoresData.mainCategoresData(cityId);
    mainCatStat = handelingData(response);
    if (mainCatStat == StatusRequest.success) {
      if (response is List) {
        mainCat = [];
        for (var item in response) {
          mainCat.add(MainCategoriesModel.fromJson(item));
        }
      }
      update();
    } else {
      mainCatStat = StatusRequest.failure;
      update();
    }
  }

  // ======================= Home Sectiom Function =============================
  @override
  Future<void> fetchHomeSection() async {
    homeSectionState = StatusRequest.loading;
    update();
    var response =
        await homeSectionData.homeSectionData() as Map<String, dynamic>;
    homeSectionState = handelingData(response);
    if (homeSectionState == StatusRequest.success) {
      List<dynamic> sctionList = response["sections"];
      for (var item in sctionList) {
        homeSection.add(HomeSectionModel.fromJson(item));
      }
      for (var section in homeSection) {
        final sections = await fetchSection(section.type!);
        finalSection[section.type!] = sections;
      }
      if (homeSection.isNotEmpty) {
        selectedType = 0;
        sectionName = homeSection.first.type ?? homeSection.first.name ?? "";
        finalSectionState = finalSection[sectionName]?.isNotEmpty == true
            ? StatusRequest.success
            : StatusRequest.failure;
      }
      update();
    } else {
      homeSectionState = StatusRequest.failure;
      update();
    }
  }

  // =================== Section Function ======================================
  @override
  Future<List<SectionModel>> fetchSection(String sectionName) async {
    sectionState = StatusRequest.loading;
    update();

    var response = await homeSectionData.sectionData(cityId, sectionName);
    sectionState = handelingData(response);

    if (sectionState == StatusRequest.success && response is List) {
      return response
          .map<SectionModel>((e) => SectionModel.fromJson(e))
          .toList();
    }

    return [];
  }

  // ================== All Item Function ======================================
  @override
  Future<void> fetchAllItem() async {
    allItemState = StatusRequest.loading;
    update();
    var response = await allItemData.allItemData(cityId);
    allItemState = handelingData(response);
    if (allItemState == StatusRequest.success) {
      List<dynamic> itemList = [];

      if (response is List) {
        itemList = response;
      } else if (response is Map && response.containsKey("data")) {
        itemList = response["data"] as List<dynamic>;
      }

      items = [];
      for (var item in itemList) {
        items.add(ItemModel.fromJson(item));
      }
      update();
    } else {
      allItemState = StatusRequest.failure;
      update();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([
      fetchSliders(),
      fetchMainCategores(),
      fetchAllItem(),
      fetchHomeSection(),
    ]);
    if (slides.isEmpty) {
      pageController = PageController(initialPage: 0);
      extendedSlides = [];
      return;
    }
    extendedSlides = [slides.last, ...slides, slides.first];

    pageController = PageController(initialPage: initialPage);
    _startAutoPlay();
    update();
  }

  @override
  void onClose() {
    _isDisposed = true;
    pageController?.dispose();
    super.onClose();
  }

  @override
  void updateSection(int id, String name) {
    selectedType = id;
    final sectionKey =
        id >= 0 && id < homeSection.length && homeSection[id].type != null
        ? homeSection[id].type!
        : name;
    sectionName = sectionKey;
    finalSectionState = StatusRequest.loading;
    update();

    if (finalSection.containsKey(sectionKey)) {
      finalSectionState = StatusRequest.success;
      update();
      return;
    }

    fetchSection(sectionKey).then((sections) {
      finalSection[sectionKey] = sections;
      finalSectionState = sections.isNotEmpty
          ? StatusRequest.success
          : StatusRequest.failure;
      update();
    });
  }
}
