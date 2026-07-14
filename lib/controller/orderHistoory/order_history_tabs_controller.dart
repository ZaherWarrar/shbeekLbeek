import 'package:get/get.dart';

class OrderHistoryTabsController extends GetxController {
  final selectedTab = 0.obs;

  void changeTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
  }
}
