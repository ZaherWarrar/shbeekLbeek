import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/cart/cart_coupon_handler.dart';
import 'package:app/controller/cart/cart_delivery_utils.dart';
import 'package:app/controller/cart/cart_group_utils.dart';
import 'package:app/controller/cart/cart_wallet_utils.dart';
import 'package:app/controller/orderHistoory/order_items_group_utils.dart';
import 'package:app/controller/wallet/wallet_payment_mixin.dart';
import 'package:app/core/function/resolve_media_url.dart';
import 'package:app/core/services/cart_preferences.dart';
import 'package:app/data/datasource/model/address_model.dart';
import 'package:app/data/datasource/model/coupon_check_model.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:app/data/datasource/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

class CartController extends GetxController with WalletPaymentMixin {
  List<Map<String, dynamic>> cartItems = [];
  final TextEditingController discountCodeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final CartPreferences _prefs = CartPreferences();

  late final CartCouponHandler coupon = CartCouponHandler(
    discountCodeController: discountCodeController,
    prefs: _prefs,
    onStateChanged: update,
    getCartItems: () => cartItems,
  );

  String? get discountCode => coupon.discountCode;
  set discountCode(String? value) => coupon.discountCode = value;

  double get discountAmount => coupon.discountAmount;
  double get discountPercentage => coupon.discountPercentage;
  String? get couponMessage => coupon.couponMessage;
  bool get isCheckingCoupon => coupon.isCheckingCoupon;
  CouponApplyRange get couponApplyRange => coupon.couponDetails.applyRange;

  String? notes;
  double deliveryFee = 0.0;
  String? selectedAddressId;

  AddressModel? get checkoutAddress {
    if (!Get.isRegistered<AddressController>()) return null;
    final list = Get.find<AddressController>().addresses;
    if (list.isEmpty) return null;

    if (selectedAddressId != null) {
      for (final address in list) {
        if (address.id == selectedAddressId) return address;
      }
    }

    for (final address in list) {
      if (address.isDefault) return address;
    }
    return list.first;
  }

  void selectCheckoutAddress(String id) {
    selectedAddressId = id;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _prefs.init().then((_) => _loadCart());
    fetchWalletBalance();
  }

  void _loadCart() {
    cartItems = _prefs.getCart();
    deliveryFee = deriveDeliveryFeeFromCart(cartItems);
    coupon.restoreFromPrefs(_prefs.getDiscountCode());
    notes = _prefs.getNotes();
    if (notes != null) notesController.text = notes!;
    update();
    coupon.revalidateSavedCode();
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
      AppSnackbar.show(
        'تنبيه',
        'يوجد طلب قيد المعالجة. لا يمكن إضافة منتجات جديدة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (product.id == null) {
      AppSnackbar.show('خطأ', 'معرّف المنتج غير صحيح');
      return;
    }
    if (shop.id == null) {
      AppSnackbar.show('خطأ', 'معرّف المتجر غير صحيح');
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
        'categoryId': shop.categoryId,
        'shopName': shop.name ?? '',
        'deliveryFee': shop.deliveryFee,
        'variationName': variationName,
        'itemNotes': itemNotes,
        'productName': product.name ?? '',
        'productDescription': '',
        'productImage': resolveMediaUrl(product.imageUrl) ?? '',
        'price': price,
        'quantity': quantity,
        'subtotal': price * quantity,
      });
    }

    _afterCartMutation();
  }

  void removeItem(int productId) {
    cartItems.removeWhere((item) => item['productId'] == productId);
    _afterCartMutation();
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

  void _afterCartMutation() {
    deliveryFee = deriveDeliveryFeeFromCart(cartItems);
    _saveCart();
    update();
  }

  double get subtotal => calculateSubtotal(cartItems);
  List<CartShopGroup> get groupedCartItems => groupCartItemsByShop(cartItems);
  double get calculatedDeliveryFee => deliveryFee;
  double get calculatedDiscount => coupon.calculatedDiscount;

  double get amountBeforeWallet =>
      subtotal + calculatedDeliveryFee - calculatedDiscount;

  double get walletDeduction => calculateWalletDeduction(
    useWallet: useWallet,
    walletBalance: walletBalance,
    amountBeforeWallet: amountBeforeWallet,
  );

  double get total => amountBeforeWallet - walletDeduction;

  void applyDiscount() => coupon.apply();
  void removeDiscount() => coupon.remove();

  Future<bool> fillFromPreviousOrder(OrderHisModel order) async {
    if (hasActiveOrder()) return false;

    final built = <Map<String, dynamic>>[];
    for (final item in order.items ?? const <OrderItemModel>[]) {
      final mapped = _mapOrderItemToCart(item);
      if (mapped == null) continue;

      final index = built.indexWhere(
        (existing) =>
            existing['productId'] == mapped['productId'] &&
            (existing['variationName']?.toString() ?? '') ==
                (mapped['variationName']?.toString() ?? ''),
      );
      if (index == -1) {
        built.add(mapped);
      } else {
        final quantity = (built[index]['quantity'] as int) +
            (mapped['quantity'] as int);
        built[index]['quantity'] = quantity;
        built[index]['subtotal'] = (built[index]['price'] as int) * quantity;
      }
    }

    if (built.isEmpty) return false;

    cartItems = built;
    await coupon.remove();
    resetWalletPayment();
    notes = null;
    notesController.clear();
    selectedAddressId = null;
    _afterCartMutation();
    return true;
  }

  Map<String, dynamic>? _mapOrderItemToCart(OrderItemModel item) {
    final productId = item.productId ?? item.product?.id;
    if (productId == null) return null;

    final quantity = item.quantity ?? 0;
    if (quantity <= 0) return null;

    final shop = resolveOrderShop(item);
    final price = _orderItemPrice(item);
    final variation = item.variationName?.trim();
    final notes = item.notes?.trim();

    return {
      'productId': productId,
      'shopId': shop.shopId,
      'categoryId': item.product?.categoryId,
      'shopName': shop.shopName,
      'deliveryFee': shop.deliveryFee,
      'variationName': (variation != null && variation.isNotEmpty)
          ? variation
          : null,
      'itemNotes': (notes != null && notes.isNotEmpty) ? notes : null,
      'productName': item.product?.name ?? 'منتج',
      'productDescription': item.product?.description ?? '',
      'productImage': resolveMediaUrl(item.product?.imageUrl) ?? '',
      'price': price,
      'quantity': quantity,
      'subtotal': price * quantity,
    };
  }

  int _orderItemPrice(OrderItemModel item) {
    final raw = item.singlePrice;
    if (raw != null) {
      final parsed = double.tryParse(raw);
      if (parsed != null) return parsed.toInt();
    }
    return item.product?.salePrice ?? item.product?.regularPrice ?? 0;
  }

  void clearCart() async {
    cartItems.clear();
    await coupon.remove();
    resetWalletPayment();
    notes = null;
    notesController.clear();
    await _prefs.clearCart();
    deliveryFee = 0.0;
    update();
    AppSnackbar.show('تم المسح', 'تم مسح السلة بالكامل');
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
