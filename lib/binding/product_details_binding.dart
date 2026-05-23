import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:get/get.dart';

class ProductDetailsBinding extends Bindings {
  static String tagFor(int productId) => 'product_details_$productId';

  static int parseProductId(dynamic args) {
    if (args is int) return args;
    if (args is Map) {
      final map = Map<String, dynamic>.from(args);
      final pid = map['productId'] ?? map['id'];
      if (pid is int) return pid;
      return int.tryParse(pid?.toString() ?? '') ?? -1;
    }
    return int.tryParse(args?.toString() ?? '') ?? -1;
  }

  @override
  void dependencies() {
    final productId = parseProductId(Get.arguments);
    if (productId <= 0) return;

    final tag = tagFor(productId);
    if (!Get.isRegistered<ProductDetailsController>(tag: tag)) {
      Get.put(
        ProductDetailsController(productId: productId),
        tag: tag,
      );
    }
  }
}
