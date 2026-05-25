import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/store_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

int shopCartQuantity(int productId) {
  if (!Get.isRegistered<CartController>()) return 0;
  final cart = Get.find<CartController>();
  final item = cart.cartItems.firstWhere(
    (e) => e['productId'] == productId,
    orElse: () => <String, dynamic>{},
  );
  if (item.isEmpty) return 0;
  return item['quantity'] as int? ?? 0;
}

void shopCartIncrease({
  required int productId,
  required List<Products> catalog,
  required StoreModel? store,
  required ItemModel? shopSummary,
  required VoidCallback onUpdated,
}) {
  if (!Get.isRegistered<CartController>()) {
    Get.snackbar('خطأ', 'السلة غير متاحة');
    return;
  }

  final product = catalog.firstWhere(
    (p) => p.id == productId,
    orElse: () => Products(),
  );
  if (product.id == null) {
    Get.snackbar('خطأ', 'المنتج غير موجود');
    return;
  }

  final cart = Get.find<CartController>();
  if (cart.hasActiveOrder()) {
    Get.snackbar(
      'تنبيه',
      'يوجد طلب قيد المعالجة. لا يمكن إضافة منتجات جديدة',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  final exists = cart.cartItems.any((item) => item['productId'] == productId);
  if (exists) {
    cart.increaseQuantity(productId);
  } else {
    cart.addItem(product, _storeForCart(store, shopSummary), quantity: 1);
  }
  onUpdated();
}

void shopCartDecrease({
  required int productId,
  required VoidCallback onUpdated,
}) {
  if (!Get.isRegistered<CartController>()) return;
  final cart = Get.find<CartController>();
  final exists = cart.cartItems.any((item) => item['productId'] == productId);
  if (exists) {
    cart.decreaseQuantity(productId);
    onUpdated();
  }
}

StoreModel _storeForCart(StoreModel? store, ItemModel? summary) {
  return store ??
      StoreModel(
        id: summary?.id,
        name: summary?.name,
        imageUrl: summary?.imageUrl,
        deliveryFee: summary?.deliveryFee,
        minOrder: summary?.minOrder,
        categoryName: summary?.categoryName,
        rating: summary?.rating,
        productsCount: summary?.productsCount,
      );
}
