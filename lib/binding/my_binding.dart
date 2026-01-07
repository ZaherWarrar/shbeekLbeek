import 'package:app/core/class/crud.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(CartController(), permanent: true);
  }
}
