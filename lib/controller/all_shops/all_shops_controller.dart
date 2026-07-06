import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/data/datasource/model/item_model.dart';
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

  void _applyFilters() {
    filteredShops = List.from(allShops);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredShops = filteredShops.where((shop) {
        return (shop.name ?? '').toLowerCase().contains(query);
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
