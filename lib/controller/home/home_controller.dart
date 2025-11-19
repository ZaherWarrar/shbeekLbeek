import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:app/data/datasorce/model/main_categores.dart';
import 'package:app/data/datasorce/model/new_arrival_model.dart';
import 'package:app/data/datasorce/model/slider_model.dart';
import 'package:app/data/datasorce/remot/all_item_data.dart';
import 'package:app/data/datasorce/remot/main_categores_data.dart';
import 'package:app/data/datasorce/remot/new_arrival_data.dart';
import 'package:app/data/datasorce/remot/slider_data.dart';
import 'package:app/data/datasorce/remot/top_ordered_data.dart';
import 'package:app/data/datasorce/remot/top_rating_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeController extends GetxController {
  Future<void> fetchSliders();
  Future<void> fetchMainCategores();
  Future<void> fetchNewArrival();
  Future<void> fetchTopRating();
  Future<void> fetchTopOrdered();
  Future<void> fetchAllItem();
  // ignore: strict_top_level_inference
  selectType(int index);
}

class HomeControllerImp extends HomeController {
  // ============= Slider =================================================
  SliderData sliderData = SliderData(Get.find());
  StatusRequest sliderStat = StatusRequest.none;
  List<SliderModel> slides = [];
  List<SliderModel> extendedSlides = [];
  var currentIndex = 0.obs;
  late PageController pageController;
  Duration autoPlayDelay = const Duration(seconds: 2);
  final Duration transitionSpeed = const Duration(milliseconds: 500);
  final int initialPage = 1;
  bool _isDisposed = false;
  // ============ Main Categores ===============================================
  MainCategoresData mainCategoresData = MainCategoresData(Get.find());
  StatusRequest mainCatStat = StatusRequest.none;
  List<MainCategoriesModel> mainCat = [];
  // ============ category type  ===============================================
  List<String> categoryType = ["الأكثر طلبا", "وصل حديثا", "الأعلى تقييما"];
  // ============ new Arrival data =============================================
  StatusRequest newArrivalStat = StatusRequest.none;
  NewArrivalData newArrivalData = NewArrivalData(Get.find());
  List<NewArrivalModel> newArrival = [];
  // ============ top rating data ==============================================
  StatusRequest topRatingStat = StatusRequest.none;
  TopRatingData topRatingData = TopRatingData(Get.find());
  List<NewArrivalModel> topRating = [];
  // ============ top ordered data =============================================
  StatusRequest topOrderedStat = StatusRequest.none;
  TopOrderedData topOrderedData = TopOrderedData(Get.find());
  List<NewArrivalModel> topOrdered = [];
  int selectedType = 0;
  List<Map<String, dynamic>> data = [];
  List<NewArrivalModel> dataCategory = [];
  // ============== All Item Var ===============================================
  StatusRequest allItemState = StatusRequest.none;
  AllItemData allItemData = AllItemData(Get.find());
  List<ItemModel> items = [];
  // ==============  Slider ====================================================

  @override
  Future<void> fetchSliders() async {
    sliderStat = StatusRequest.loading;
    update();
    var response = await sliderData.sliderData(1);
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
      if (_isDisposed || !pageController.hasClients) continue;

      final currentPage = pageController.page;
      if (currentPage == null) continue;

      int nextPage = currentPage.toInt() + 1;
      if (nextPage > extendedSlides.length - 1) {
        nextPage = 0;
      }
      pageController.animateToPage(
        nextPage,
        duration: transitionSpeed,
        curve: Curves.easeInOut,
      );
    }
  }
  // ==============  Slider =================================================

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
  // ==============  Main Categores =================================================

  @override
  Future<void> fetchMainCategores() async {
    mainCatStat = StatusRequest.loading;
    update();
    var response = await mainCategoresData.mainCategoresData(1);
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

  // ==============  catergory =================================================

  // @override
  // selectType(int index) {
  //   selectedType = index;
  //   dataCategory = data[index]["data"];
  //   update();
  // }

  @override
  Future<void> fetchNewArrival() async {
    newArrivalStat = StatusRequest.loading;
    update();
    var response =
        await newArrivalData.newArrivalData(1) as Map<String, dynamic>;
    newArrivalStat = handelingData(response);
    if (newArrivalStat == StatusRequest.success) {
      List<dynamic> sliderList = response["data"];
      newArrival = [];
      for (var item in sliderList) {
        newArrival.add(NewArrivalModel.fromJson(item));
      }
      update();
    } else {
      newArrivalStat = StatusRequest.failure;
      update();
    }
  }

  @override
  Future<void> fetchTopOrdered() async {
    newArrivalStat = StatusRequest.loading;
    update();
    var response =
        await topOrderedData.topOrderedData(1) as Map<String, dynamic>;
    newArrivalStat = handelingData(response);
    if (newArrivalStat == StatusRequest.success) {
      List<dynamic> sliderList = response["data"];
      topOrdered = [];
      for (var item in sliderList) {
        topOrdered.add(NewArrivalModel.fromJson(item));
      }

      update();
    } else {
      newArrivalStat = StatusRequest.failure;
      update();
    }
  }

  @override
  Future<void> fetchTopRating() async {
    newArrivalStat = StatusRequest.loading;
    update();
    var response = await topRatingData.topRatingData(1) as Map<String, dynamic>;
    newArrivalStat = handelingData(response);
    if (newArrivalStat == StatusRequest.success) {
      List<dynamic> sliderList = response["data"];
      topRating = [];
      for (var item in sliderList) {
        topRating.add(NewArrivalModel.fromJson(item));
      }
      update();
    } else {
      newArrivalStat = StatusRequest.failure;
      update();
    }
  }

  // ================== All Item Function ======================================
  @override
  Future<void> fetchAllItem() async {
    allItemState = StatusRequest.loading;
    update();
    var response = await allItemData.allItemData(1) as Map<String, dynamic>;
    allItemState = handelingData(response);
    if (allItemState == StatusRequest.success) {
      List<dynamic> itemList = response["data"];
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
  selectType(int index) async {
    selectedType = index;
    if (index == 0) {
      await fetchTopOrdered();
      dataCategory = [];
      dataCategory = topOrdered;
      update();
    } else if (index == 1) {
      await fetchNewArrival();
      dataCategory = [];
      dataCategory = newArrival;
    } else {
      await fetchTopRating();
      dataCategory = [];
      dataCategory = topRating;
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchSliders();
    await fetchMainCategores();
    await fetchTopOrdered();
    await fetchAllItem();
    dataCategory = [];
    dataCategory = topOrdered;
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
    pageController.dispose();
    super.onClose();
  }
}
