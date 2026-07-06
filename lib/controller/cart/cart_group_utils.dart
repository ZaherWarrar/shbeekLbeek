class CartShopGroup {
  const CartShopGroup({
    required this.shopKey,
    required this.shopId,
    required this.shopName,
    required this.items,
    this.deliveryFee,
  });

  final String shopKey;
  final int? shopId;
  final String shopName;
  final List<Map<String, dynamic>> items;
  final String? deliveryFee;
}

/// يفرّز عناصر السلة حسب المتجر مع الحفاظ على ترتيب الإضافة.
List<CartShopGroup> groupCartItemsByShop(List<Map<String, dynamic>> cartItems) {
  final groups = <String, CartShopGroup>{};
  final order = <String>[];

  for (final item in cartItems) {
    if (item['productId'] == null) continue;

    final shopId = item['shopId'];
    final shopName = item['shopName']?.toString().trim();
    final shopKey = shopId?.toString() ?? shopName ?? 'unknown';

    if (!groups.containsKey(shopKey)) {
      order.add(shopKey);
      groups[shopKey] = CartShopGroup(
        shopKey: shopKey,
        shopId: shopId is int ? shopId : int.tryParse('$shopId'),
        shopName: shopName?.isNotEmpty == true ? shopName! : 'متجر',
        deliveryFee: item['deliveryFee']?.toString(),
        items: [item],
      );
    } else {
      final existing = groups[shopKey]!;
      groups[shopKey] = CartShopGroup(
        shopKey: existing.shopKey,
        shopId: existing.shopId,
        shopName: existing.shopName,
        deliveryFee: existing.deliveryFee,
        items: [...existing.items, item],
      );
    }
  }

  return order.map((key) => groups[key]!).toList();
}
