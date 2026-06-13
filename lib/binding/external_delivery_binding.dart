import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:get/get.dart';

class ExternalDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExternalDeliveryController>(
      () => ExternalDeliveryController(),
      fenix: true,
    );
  }
}
