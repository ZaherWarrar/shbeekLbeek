import 'package:app/controller/cart/cart_coupon_handler.dart';
import 'package:app/controller/cart/cart_delivery_utils.dart';
import 'package:app/core/services/cart_preferences.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  List<Map<String, dynamic>> cartItems = [];
  final TextEditingController discountCodeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final CartPreferences _prefs = CartPreferences();

  late final CartCouponHandler coupon = CartCouponHandler(
    discountCodeController: discountCodeController,
    prefs: _prefs,
    onStateChanged: update,
    getSubtotal: () => subtotal,
  );

  String? get discountCode => coupon.discountCode;
  set discountCode(String? value) => coupon.discountCode = value;

  double get discountAmount => coupon.discountAmount;
  double get discountPercentage => coupon.discountPercentage;
  String? get couponMessage => coupon.couponMessage;
  bool get isCheckingCoupon => coupon.isCheckingCoupon;

  String? notes;
  double deliveryFee = 10.0;

  @override
  void onInit() {
    super.onInit();
    _prefs.init().then((_) => _loadCart());
  }

  void _loadCart() {
    cartItems = _prefs.getCart();
    deliveryFee = deriveDeliveryFeeFromCart(cartItems) ?? deliveryFee;
    coupon.restoreFromPrefs(_prefs.getDiscountCode());
    notes = _prefs.getNotes();
    if (notes != null) notesController.text = notes!;
    update();
  }

  Future<void> _saveCart() async {
    await _prefs.saveCart(cartItems);
    if (coupon.discountCode != null) {
      await _prefs.saveDiscountCode(coupon.discountCode!);
    }
    if (notesController.text.isNotEmpty) {
      notes = notesController.text;
      await _prefs.saveNotes(notesController.text);
    } else {
      notes = null;
      await _prefs.removeNotes();
    }
  }

  Future<void> saveCart() => _saveCart();

  bool hasActiveOrder() => _prefs.hasActiveOrder();

  int getQuantity(int productId) {
    final item = cartItems.firstWhere(
      (e) => e['productId'] == productId && e['variationName'] == null,
      orElse: () => <String, dynamic>{},
    );
    if (item.isEmpty) return 0;
    return parseItemQuantity(item);
  }

  int getQuantityByVariation(int productId, String? variationName) {
    final item = cartItems.firstWhere(
      (e) =>
          e['productId'] == productId &&
          (e['variationName']?.toString() ?? '') == (variationName ?? ''),
      orElse: () => <String, dynamic>{},
    );
    if (item.isEmpty) return 0;
    return parseItemQuantity(item);
  }

  void addItem(
    Products product,
    StoreModel shop, {
    int quantity = 1,
    String? variationName,
    String? itemNotes,
  }) {
    if (hasActiveOrder()) {
      Get.snackbar(
        'تنبيه',
        'يوجد طلب قيد المعالجة. لا يمكن إضافة منتجات جديدة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (product.id == null) {
      Get.snackbar('خطأ', 'معرّف المنتج غير صحيح');
      return;
    }
    if (shop.id == null) {
      Get.snackbar('خطأ', 'معرّف المتجر غير صحيح');
      return;
    }

    final index = cartItems.indexWhere(
      (item) =>
          item['productId'] == product.id &&
          (item['variationName']?.toString() ?? '') == (variationName ?? ''),
    );

    if (index != -1) {
      _bumpQuantity(index, quantity);
    } else {
      final price = product.salePrice ?? product.regularPrice ?? 0;
      cartItems.add({
        'productId': product.id!,
        'shopId': shop.id!,
        'shopName': shop.name ?? '',
        'deliveryFee': shop.deliveryFee,
        'variationName': variationName,
        'itemNotes': itemNotes,
        'productName': product.name ?? '',
        'productDescription': '',
        'productImage': product.imageUrl ?? '',
        'price': price,
        'quantity': quantity,
        'subtotal': price * quantity,
      });
    }

    _afterCartMutation(
      snackTitle: 'تم الإضافة',
      snackBody: 'تم إضافة ${product.name ?? 'المنتج'} للسلة',
    );
  }

  void removeItem(int productId) {
    cartItems.removeWhere((item) => item['productId'] == productId);
    _afterCartMutation(
      snackTitle: 'تم الحذف',
      snackBody: 'تم حذف المنتج من السلة',
    );
  }

  void removeItemByVariation(int productId, String? variationName) {
    cartItems.removeWhere(
      (item) =>
          item['productId'] == productId &&
          (item['variationName']?.toString() ?? '') == (variationName ?? ''),
    );
    _afterCartMutation();
  }

  void increaseQuantity(int productId) {
    final index = cartItems.indexWhere(
      (item) => item['productId'] == productId && item['variationName'] == null,
    );
    if (index == -1) return;
    _bumpQuantity(index, 1);
    _afterCartMutation();
  }

  void increaseQuantityByVariation(int productId, String? variationName) {
    final index = _indexForVariation(productId, variationName);
    if (index == -1) return;
    _bumpQuantity(index, 1);
    _afterCartMutation();
  }

  void decreaseQuantity(int productId) {
    final index = cartItems.indexWhere(
      (item) => item['productId'] == productId && item['variationName'] == null,
    );
    if (index == -1) return;
    _decreaseAtIndex(index, productId, variationName: null);
  }

  void decreaseQuantityByVariation(int productId, String? variationName) {
    final index = _indexForVariation(productId, variationName);
    if (index == -1) return;
    _decreaseAtIndex(index, productId, variationName: variationName);
  }

  int _indexForVariation(int productId, String? variationName) {
    return cartItems.indexWhere(
      (item) =>
          item['productId'] == productId &&
          (item['variationName']?.toString() ?? '') == (variationName ?? ''),
    );
  }

  void _decreaseAtIndex(
    int index,
    int productId, {
    required String? variationName,
  }) {
    final current = cartItems[index]['quantity'] as int;
    if (current > 1) {
      cartItems[index]['quantity'] = current - 1;
      _syncSubtotal(index);
      _afterCartMutation();
    } else if (variationName != null) {
      removeItemByVariation(productId, variationName);
    } else {
      removeItem(productId);
    }
  }

  void _bumpQuantity(int index, int delta) {
    cartItems[index]['quantity'] =
        (cartItems[index]['quantity'] as int) + delta;
    _syncSubtotal(index);
  }

  void _syncSubtotal(int index) {
    cartItems[index]['subtotal'] =
        (cartItems[index]['price'] as int) *
        (cartItems[index]['quantity'] as int);
  }

  void _afterCartMutation({String? snackTitle, String? snackBody}) {
    deliveryFee = deriveDeliveryFeeFromCart(cartItems) ?? deliveryFee;
    _saveCart();
    update();
    if (snackTitle != null && snackBody != null) {
      Get.snackbar(
        snackTitle,
        snackBody,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  double get subtotal => calculateSubtotal(cartItems);
  double get calculatedDeliveryFee => deliveryFee;
  double get calculatedDiscount => coupon.calculatedDiscount;
  double get total => subtotal + calculatedDeliveryFee - calculatedDiscount;

  void applyDiscount() => coupon.apply();
  void removeDiscount() => coupon.remove();

  void clearCart() async {
    cartItems.clear();
    await coupon.remove();
    notes = null;
    notesController.clear();
    await _prefs.clearCart();
    deliveryFee = 10.0;
    update();
    Get.snackbar('تم المسح', 'تم مسح السلة بالكامل');
  }

  int get itemCount => totalItemCount(cartItems);
  bool get isEmpty => cartItems.isEmpty;

  @override
  void onClose() {
    discountCodeController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
