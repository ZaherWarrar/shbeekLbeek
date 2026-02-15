import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorate_tabs_controller.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorites_tabs.dart';
import 'package:app/view/favorets/widget/favorites_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // التأكد من وجود الكونترولر (مثلاً لو فُتحت الصفحة بدون MainView)
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put(FavoritesController(), permanent: true);
    }
    final controller = Get.find<FavoritesController>();

    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width >= 900
        ? 4
        : width >= 600
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "المفضلة",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
        ],
      ),
      body: Column(
        children: [
          FavoritesTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: GetBuilder<FavoritesController>(
              builder: (ctrl) {
                return CustomRefresh(
                  statusRequest: ctrl.favoriteState,
                  fun: () => ctrl.fetchFavorites(),
                  body: Obx(() {
                    final isProductsTab = controller.currentIndex.value == 0;
                    final filteredItems = controller.restaurants
                        .where(
                          (item) => item.favoriteType ==
                              (isProductsTab ? 'product' : 'category'),
                        )
                        .toList();
                    if (filteredItems.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Text(
                              isProductsTab
                                  ? "لا يوجد منتجات مفضلة"
                                  : "لا يوجد متاجر مفضلة",
                            ),
                          ),
                        ),
                      );
                    }
                    return FavoritesGrid(
                      items: filteredItems,
                      crossAxisCount: crossAxisCount,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
