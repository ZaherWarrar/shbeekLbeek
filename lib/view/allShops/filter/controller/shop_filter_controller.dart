import 'package:get/get.dart';

class FilterController extends GetxController {
  var selectedIndex = 0.obs;

  void changeFilter(int index) {
    selectedIndex.value = index;
  }
}