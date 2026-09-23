import 'package:app/controller/cart/cart_delivery_utils.dart';
import 'package:app/data/datasource/model/coupon_check_model.dart';

int? _parseItemInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double _parseItemSubtotal(Map<String, dynamic> item) {
  final subtotalValue = item['subtotal'];
  if (subtotalValue is int) return subtotalValue.toDouble();
  if (subtotalValue is double) return subtotalValue;
  return double.tryParse(subtotalValue?.toString() ?? '') ?? 0.0;
}

bool isCartItemEligibleForCoupon(
  Map<String, dynamic> item,
  CouponRestrictions restrictions,
) {
  if (restrictions.appliesToWholeCart) return true;

  final categoryIds = restrictions.categories;
  final storeIds = restrictions.stores;
  final productIds = restrictions.products;

  if (categoryIds != null && categoryIds.isNotEmpty) {
    final categoryId = _parseItemInt(item['categoryId']);
    if (categoryId != null && categoryIds.contains(categoryId)) {
      return true;
    }
  }

  if (storeIds != null && storeIds.isNotEmpty) {
    final shopId = _parseItemInt(item['shopId']);
    if (shopId != null && storeIds.contains(shopId)) {
      return true;
    }
  }

  if (productIds != null && productIds.isNotEmpty) {
    final productId = _parseItemInt(item['productId']);
    if (productId != null && productIds.contains(productId)) {
      return true;
    }
  }

  return false;
}

double calculateEligibleSubtotal(
  List<Map<String, dynamic>> cartItems,
  CouponRestrictions restrictions,
) {
  return cartItems
      .where((item) => isCartItemEligibleForCoupon(item, restrictions))
      .fold(0.0, (sum, item) => sum + _parseItemSubtotal(item));
}

double calculateEligibleDeliveryFee(
  List<Map<String, dynamic>> cartItems,
  CouponRestrictions restrictions,
) {
  final feeByShop = <dynamic, double>{};

  for (final item in cartItems) {
    if (!isCartItemEligibleForCoupon(item, restrictions)) continue;
    final shopId = item['shopId'];
    if (shopId == null) continue;
    if (feeByShop.containsKey(shopId)) continue;

    feeByShop[shopId] =
        parseDeliveryFee(item['deliveryFee'] ?? item['shopDeliveryFee']) ?? 0.0;
  }

  return feeByShop.values.fold(0.0, (sum, fee) => sum + fee);
}

double _applyCouponToBase(CouponDetails details, double base) {
  if (base <= 0 || details.value <= 0) return 0.0;

  if (details.isPercent) {
    final percent = details.value.clamp(0.0, 100.0);
    return base * (percent / 100);
  }

  if (details.isFixed) {
    return details.value > base ? base : details.value;
  }

  return 0.0;
}

double calculateCouponDiscount({
  required List<Map<String, dynamic>> cartItems,
  required String? discountCode,
  required CouponDetails details,
  required CouponRestrictions restrictions,
}) {
  if (discountCode == null || discountCode.isEmpty) return 0.0;

  final base = details.appliesToDelivery
      ? calculateEligibleDeliveryFee(cartItems, restrictions)
      : calculateEligibleSubtotal(cartItems, restrictions);

  return _applyCouponToBase(details, base);
}
