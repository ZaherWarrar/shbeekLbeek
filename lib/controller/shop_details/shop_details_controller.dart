import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsController extends GetxController {
  late ItemModel shopItem;
  late TextEditingController searchController;

  List<Products> filteredProducts = [];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ItemModel) {
      shopItem = Get.arguments as ItemModel;
    } else {
      Get.back();
      Get.snackbar("خطأ", "لم يتم العثور على بيانات المتجر");
      return;
    }

    searchController = TextEditingController();
    filteredProducts = shopItem.products ?? [];
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredProducts = shopItem.products ?? [];
    } else {
      filteredProducts = (shopItem.products ?? []).where((product) {
        return (product.name ?? '').toLowerCase().contains(query) ||
            (product.description ?? '').toLowerCase().contains(query);
      }).toList();
    }
    update();
  }

  Map<int?, List<Products>> getProductsByCategory() {
    Map<int?, List<Products>> categories = {};
    for (var product in filteredProducts) {
      int? categoryId = product.categoryId;
      if (categoryId != null) {
        if (!categories.containsKey(categoryId)) {
          categories[categoryId] = [];
        }
        categories[categoryId]!.add(product);
      }
    }
    return categories;
  }

  int getProductQuantity(int productId) {
    if (!Get.isRegistered<CartController>()) {
      return 0;
    }
    final cartController = Get.find<CartController>();
    final cartItem = cartController.cartItems.firstWhere(
      (item) => item['productId'] == productId,
      orElse: () => <String, dynamic>{},
    );
    if (cartItem.isEmpty) return 0;
    return cartItem['quantity'] as int? ?? 0;
  }

  void increaseQuantity(int productId) {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar("خطأ", "السلة غير متاحة");
      return;
    }

    final product = (shopItem.products ?? []).firstWhere(
      (p) => p.id == productId,
      orElse: () => Products(),
    );

    if (product.id == null) {
      Get.snackbar("خطأ", "المنتج غير موجود");
      return;
    }

    final cartController = Get.find<CartController>();

    final existingIndex = cartController.cartItems.indexWhere(
      (item) => item['productId'] == productId,
    );

    if (existingIndex != -1) {
      cartController.increaseQuantity(productId);
    } else {
      cartController.addItem(product, shopItem, quantity: 1);
    }

    update();
  }

  void decreaseQuantity(int productId) {
    if (!Get.isRegistered<CartController>()) {
      return;
    }

    final cartController = Get.find<CartController>();
    final existingIndex = cartController.cartItems.indexWhere(
      (item) => item['productId'] == productId,
    );

    if (existingIndex != -1) {
      cartController.decreaseQuantity(productId);
      update();
    }
  }

  int getProductPrice(Products product) {
    return product.salePrice ?? product.regularPrice ?? 0;
  }

  bool isShopOpen() {
    if (shopItem.workSchedule == null) return true;

    // يمكن إضافة منطق للتحقق من الوقت الحالي
    // حالياً نرجع true كقيمة افتراضية
    return true;
  }

  String getCurrentWorkHours() {
    if (shopItem.workSchedule == null) return "مفتوح";

    // يمكن إضافة منطق للحصول على ساعات اليوم الحالي
    // حالياً نرجع قيمة افتراضية
    return "مفتوح الآن - 11:00 ص - 02:00 ص";
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
