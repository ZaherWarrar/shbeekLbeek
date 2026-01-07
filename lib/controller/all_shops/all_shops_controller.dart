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
        filteredShops = filteredShops.where((shop) {
          return shop.type?.toLowerCase().contains('restaurant') == true ||
              shop.type?.toLowerCase().contains('مطعم') == true;
        }).toList();
        break;
      case 2: 
        break;
      case 3: 
        filteredShops = filteredShops.where((shop) {
          // التحقق من وجود منتجات مع salePrice
          if (shop.products == null || shop.products!.isEmpty) {
            return false;
          }
          return shop.products!.any((product) => product.salePrice != null);
        }).toList();
        break;
      case 4: // الأعلى (حسب التقييم)
        // ترتيب حسب التقييم (يمكن إضافة rating field لاحقاً)
        // حالياً نرتب حسب الاسم
        filteredShops.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
    }

    // تطبيق البحث
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredShops = filteredShops.where((shop) {
        // البحث في اسم المتجر
        final nameMatch = (shop.name ?? '').toLowerCase().contains(query);

        // البحث في الوصف
        final descMatch = (shop.description ?? '').toLowerCase().contains(
          query,
        );

        // البحث في نوع المتجر
        final typeMatch = (shop.type ?? '').toLowerCase().contains(query);

        // البحث في أسماء المنتجات
        bool productMatch = false;
        if (shop.products != null) {
          productMatch = shop.products!.any(
            (product) => (product.name ?? '').toLowerCase().contains(query),
          );
        }

        return nameMatch || descMatch || typeMatch || productMatch;
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
