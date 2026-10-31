class ProductDetailsPageArgs {
  const ProductDetailsPageArgs({
    required this.productId,
    this.storeId,
    this.storeName,
    this.storeImageUrl,
    this.storeDeliveryFee,
    this.productName,
    this.productImageUrl,
    this.productPrice,
  });

  final int productId;
  final int? storeId;
  final String? storeName;
  final String? storeImageUrl;
  final String? storeDeliveryFee;
  final String? productName;
  final String? productImageUrl;
  final int? productPrice;

  static ProductDetailsPageArgs? tryParse(dynamic arg) {
    int? productId;
    int? storeId;
    String? storeName;
    String? storeImageUrl;
    String? storeDeliveryFee;
    String? productName;
    String? productImageUrl;
    int? productPrice;

    if (arg is int) {
      productId = arg;
    } else if (arg is Map) {
      final map = Map<String, dynamic>.from(arg);
      final pid = map['productId'] ?? map['id'];
      productId = pid is int ? pid : int.tryParse(pid?.toString() ?? '');

      final sid = map['storeId'] ?? map['store_id'];
      storeId = sid is int ? sid : int.tryParse(sid?.toString() ?? '');
      storeName = map['storeName']?.toString();
      storeImageUrl = map['storeImageUrl']?.toString();
      storeDeliveryFee = map['storeDeliveryFee']?.toString();
      productName = map['productName']?.toString();
      productImageUrl = map['productImageUrl']?.toString();
      final price = map['productPrice'];
      productPrice = price is int
          ? price
          : int.tryParse(price?.toString() ?? '');
    } else {
      productId = int.tryParse(arg?.toString() ?? '');
    }

    if (productId == null || productId <= 0) return null;
    return ProductDetailsPageArgs(
      productId: productId,
      storeId: storeId,
      storeName: storeName,
      storeImageUrl: storeImageUrl,
      storeDeliveryFee: storeDeliveryFee,
      productName: productName,
      productImageUrl: productImageUrl,
      productPrice: productPrice,
    );
  }
}
