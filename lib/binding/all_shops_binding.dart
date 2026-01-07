import 'package:app/controller/all_shops/all_shops_controller.dart';
import 'package:get/get.dart';

class AllShopsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllShopsController>(() => AllShopsController());
  }
}
