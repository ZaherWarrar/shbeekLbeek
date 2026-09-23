import 'package:app/controller/home/home_controller.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:get/get.dart';

class OrderShopGroup {
  const OrderShopGroup({
    required this.shopKey,
    required this.shopId,
    required this.shopName,
    required this.items,
    this.deliveryFee,
  });

  final String shopKey;
  final int? shopId;
  final String shopName;
  final List<OrderItemModel> items;
  final String? deliveryFee;
}

class OrderShopInfo {
  const OrderShopInfo({
    this.shopId,
    required this.shopName,
    this.deliveryFee,
  });

  final int? shopId;
  final String shopName;
  final String? deliveryFee;
}

OrderShopInfo resolveOrderShop(OrderItemModel item) {
  final product = item.product;
  final shopId = product?.storeId;
  final cached = _shopFromHome(shopId);

  final nestedName = product?.storeName?.trim();
  final cachedName = cached?.name?.trim();
  final shopName = (nestedName != null && nestedName.isNotEmpty)
      ? nestedName
      : (cachedName != null && cachedName.isNotEmpty)
          ? cachedName
          : 'مطعم';

  return OrderShopInfo(
    shopId: shopId,
    shopName: shopName,
    deliveryFee: product?.storeDeliveryFee ?? cached?.deliveryFee,
  );
}

List<OrderShopGroup> groupOrderItemsByShop(List<OrderItemModel> items) {
  final groups = <String, OrderShopGroup>{};
  final order = <String>[];

  for (final item in items) {
    final shop = resolveOrderShop(item);
    final shopKey = shop.shopId?.toString() ?? shop.shopName;

    if (!groups.containsKey(shopKey)) {
      order.add(shopKey);
      groups[shopKey] = OrderShopGroup(
        shopKey: shopKey,
        shopId: shop.shopId,
        shopName: shop.shopName,
        deliveryFee: shop.deliveryFee,
        items: [item],
      );
    } else {
      final existing = groups[shopKey]!;
      groups[shopKey] = OrderShopGroup(
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

ItemModel? _shopFromHome(int? shopId) {
  if (shopId == null || !Get.isRegistered<HomeControllerImp>()) return null;
  for (final shop in Get.find<HomeControllerImp>().items) {
    if (shop.id == shopId) return shop;
  }
  return null;
}
