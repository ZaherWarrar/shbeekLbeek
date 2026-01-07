import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:get/get.dart';

class ShopDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopDetailsController>(() => ShopDetailsController());
  }
}
