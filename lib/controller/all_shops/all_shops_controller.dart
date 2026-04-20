import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllShopsController extends GetxController {
  // ========================= home controller =========================
  late HomeControllerImp homeController;

  // ========================= all shops var ===========================
  StatusRequest allShopsState = StatusRequest.none;
  List<ItemModel> allShops = [];
  List<ItemModel> filteredShops = [];

  // ========================= search and filter var ===================
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  int selectedFilterIndex = 0;

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<HomeControllerImp>()) {
      homeController = Get.find<HomeControllerImp>();
    } else {
      homeController = Get.put(HomeControllerImp());
    }
    _loadShops();

    searchController.addListener(_onSearchChanged);
  }

  void _loadShops() {
    allShopsState = homeController.allItemState;
    allShops = List.from(homeController.items);
    _applyFilters();
  }

  void _onSearchChanged() {
    searchQuery = searchController.text;
    _applyFilters();
  }

  void changeFilter(int index) {
    selectedFilterIndex = index;
    _applyFilters();
  }

  void _applyFilters() {
    filteredShops = List.from(allShops);

    switch (selectedFilterIndex) {
      case 0: 
        break;
      case 1: 
        // فلتر حسب اسم التصنيف (بديل عن type بعد تغيير الـ API)
        filteredShops = filteredShops
            .where((shop) => (shop.categoryName ?? '').isNotEmpty)
            .toList();
        break;
      case 2: 
        break;
      case 3: 
        // عروض/خصومات: لم يعد لدينا products ضمن قائمة المتاجر
        // يمكن لاحقاً استخدام endpoint خاص أو products_count/flags إن توفرت.
        break;
      case 4: // الأعلى (حسب التقييم)
        filteredShops.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
    }

    // تطبيق البحث
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredShops = filteredShops.where((shop) {
        // البحث في اسم المتجر
        final nameMatch = (shop.name ?? '').toLowerCase().contains(query);
        // البحث في اسم التصنيف
        final categoryMatch =
            (shop.categoryName ?? '').toLowerCase().contains(query);
        return nameMatch || categoryMatch;
      }).toList();
    }

    update();
  }

  Future<void> refreshData() async {
    allShopsState = StatusRequest.loading;
    update();

    // إعادة جلب البيانات من HomeController
    await homeController.fetchAllItem();

    // تحديث البيانات
    _loadShops();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
