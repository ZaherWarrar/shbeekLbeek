import 'package:app/controller/all_shops/all_shops_controller.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // مزامنة مع AllShopsController إذا كان موجوداً
    if (Get.isRegistered<AllShopsController>()) {
      final allShopsController = Get.find<AllShopsController>();
      selectedIndex.value = allShopsController.selectedFilterIndex;
    }
  }

  void changeFilter(int index) {
    selectedIndex.value = index;
    // ربط مع AllShopsController
    if (Get.isRegistered<AllShopsController>()) {
      Get.find<AllShopsController>().changeFilter(index);
    }
  }
}
