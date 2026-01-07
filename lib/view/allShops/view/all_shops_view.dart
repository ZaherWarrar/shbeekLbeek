import 'package:app/controller/all_shops/all_shops_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_loding_page.dart';
import 'package:app/view/allShops/filter/controller/shop_filter_controller.dart';
import 'package:app/view/allShops/filter/view/shop_filters.dart';
import 'package:app/view/allShops/view/widget/empty_state_widget.dart';
import 'package:app/view/allShops/view/widget/search_bar_widget.dart';
import 'package:app/view/allShops/view/widget/store_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(FilterController());

    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomAppBar(title: "كل المتاجر"),
      body: GetBuilder<AllShopsController>(
        builder: (controller) {
          return Column(
            children: [
              // شريط البحث
              const SearchBarWidget(),

              // الفلاتر
              Obx(
                () => FiltersRowWidget(
                  selectedIndex: filterController.selectedIndex.value,
                  onSelect: filterController.changeFilter,
                ),
              ),

              // قائمة المتاجر
              Expanded(
                child: CustomLodingPage(
                  statusRequest: controller.allShopsState,
                  body: controller.filteredShops.isEmpty
                      ? EmptyStateWidget(
                          message: controller.searchQuery.isNotEmpty
                              ? "لا توجد نتائج للبحث"
                              : "لا توجد متاجر متاحة",
                          onRetry: () {
                            controller.refreshData();
                          },
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await controller.refreshData();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.filteredShops.length,
                            itemBuilder: (context, index) {
                              final shop = controller.filteredShops[index];

                              // بناء category string من type أو products
                              String category = shop.type ?? "متجر";
                              if (shop.products != null &&
                                  shop.products!.isNotEmpty) {
                                final categories = shop.products!
                                    .map((p) => p.categoryId)
                                    .whereType<int>()
                                    .toSet();
                                if (categories.isNotEmpty) {
                                  category =
                                      "${shop.type ?? "متجر"} · ${categories.length} فئة";
                                }
                              }

                              // deliveryTime - يمكن استخدام deliveryFee أو قيمة افتراضية
                              String deliveryTime = shop.deliveryFee != null
                                  ? "رسوم: ${shop.deliveryFee}"
                                  : "20-30 دقيقة";

                              // rating - حالياً قيمة افتراضية (يمكن إضافتها لاحقاً)
                              double rating = 4.5;

                              return StoreCardWidget(
                                name: shop.name ?? "متجر",
                                category: category,
                                rating: rating,
                                image: shop.imageUrl ?? "",
                                deliveryTime: deliveryTime,
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.resturantDetails,
                                    arguments: shop,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
