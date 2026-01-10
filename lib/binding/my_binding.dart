import 'package:app/core/class/crud.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(CartController(), permanent: true);
    // تسجيل OrderController لضمان تحميل الطلب النشط عند بدء التطبيق
    Get.put(OrderController(), permanent: true);
    // تسجيل AddressController لضمان توافره في الشريط العلوي
    Get.put(AddressController(), permanent: true);
  }
}
