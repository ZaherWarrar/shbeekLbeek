import 'package:app/core/class/crud.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/favorites/favorites_controller.dart';
import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/controller/settings/app_settings_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(CartController(), permanent: true);
    // الطلب النشط والعنوان المحفوظ ظاهرين أو لازمين من أول شاشة.
    Get.put(OrderController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    // المفضلة تُحمَّل عند فتح المتجر أو تاب المفضلة، مو مع الرئيسية.
    Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
    Get.put(NotificationsController(), permanent: true);
    Get.put(AppSettingsController(), permanent: true);
  }
}
