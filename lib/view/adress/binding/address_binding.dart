
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:get/get.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddressController());
  }
}
