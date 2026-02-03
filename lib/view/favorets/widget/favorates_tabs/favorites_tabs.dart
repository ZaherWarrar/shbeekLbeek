import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'favorate_tabs_controller.dart';

class FavoritesTabs extends StatelessWidget {
  FavoritesTabs({super.key});

  final controller = Get.isRegistered<FavoritesController>()
      ? Get.find<FavoritesController>()
      : Get.put(FavoritesController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(0),
                child: Column(
                  children: [
                    Text(
                      "المنتجات",
                      style: TextStyle(
                        color: controller.currentIndex.value == 0
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: controller.currentIndex.value == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (controller.currentIndex.value == 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 3,
                        color: Colors.orange,
                      ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(1),
                child: Column(
                  children: [
                    Text(
                      "المتاجر",
                      style: TextStyle(
                        color: controller.currentIndex.value == 1
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: controller.currentIndex.value == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (controller.currentIndex.value == 1)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 3,
                        color: Colors.orange,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
