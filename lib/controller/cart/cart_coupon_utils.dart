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

double calculateCouponDiscount({
  required List<Map<String, dynamic>> cartItems,
  required String? discountCode,
  required CouponDetails details,
  required CouponRestrictions restrictions,
}) {
  if (discountCode == null || discountCode.isEmpty) return 0.0;

  final eligibleSubtotal = calculateEligibleSubtotal(cartItems, restrictions);
  if (eligibleSubtotal <= 0) return 0.0;

  if (details.isPercent && details.value > 0) {
    final percent = details.value.clamp(0.0, 100.0);
    return eligibleSubtotal * (percent / 100);
  }

  if (details.isFixed && details.value > 0) {
    return details.value > eligibleSubtotal
        ? eligibleSubtotal
        : details.value;
  }

  return 0.0;
}
