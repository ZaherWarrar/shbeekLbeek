import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:get/get.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsController>()) {
      Get.put(NotificationsController());
    }
  }
}
