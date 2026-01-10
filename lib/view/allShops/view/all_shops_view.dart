import 'package:app/controller/all_shops/all_shops_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_loding_page.dart';
import 'package:app/view/allShops/filter/controller/shop_filter_controller.dart';
import 'package:app/view/allShops/filter/view/shop_filters.dart';
import 'package:app/view/allShops/view/widget/empty_state_widget.dart';
import 'package:app/view/allShops/view/widget/store_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(FilterController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor().backgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor().primaryColor,
          child: Icon(Icons.shopping_cart, color: AppColor().iconColors),
          onPressed: () {
            Get.toNamed(AppRoutes.cartView);
          },
        ),
        appBar: CustomAppBar(title: "كل المتاجر"),
        body: GetBuilder<AllShopsController>(
          builder: (controller) {
            return CustomLodingPage(
              statusRequest: controller.allShopsState,
              body: Column(
                children: [
                  Obx(
                    () => FiltersRowWidget(
                      selectedIndex: filterController.selectedIndex.value,
                      onSelect: filterController.changeFilter,
                    ),
                  ),
                  Expanded(
                    child: controller.filteredShops.isEmpty
                        ? const EmptyStateWidget()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount;
                              double aspectRatio;

                              if (constraints.maxWidth < 360) {
                                crossAxisCount = 2;
                                aspectRatio = 0.62; // موبايلات صغيرة جدًا
                              } else if (constraints.maxWidth < 600) {
                                crossAxisCount = 2;
                                aspectRatio = 0.68;
                              } else if (constraints.maxWidth < 900) {
                                crossAxisCount = 3;
                                aspectRatio = 0.75;
                              } else {
                                crossAxisCount = 4;
                                aspectRatio = 0.8;
                              }

                              return GridView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: controller.filteredShops.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: aspectRatio,
                                    ),
                                itemBuilder: (context, index) {
                                  final store = controller.filteredShops[index];
                                  return StoreCardWidget(
                                    name: store.name ?? "متجر",
                                    category: store.type ?? "عام",
                                    rating: 4.5, // يمكن إضافة rating لاحقاً
                                    image: store.imageUrl ?? "",
                                    deliveryTime: store.deliveryFee ?? "مجاني",
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.resturantDetails,
                                        arguments: store,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
