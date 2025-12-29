import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/view/allShops/filter/controller/shop_filter_controller.dart';
import 'package:app/view/allShops/filter/view/shop_filters.dart';
import 'package:app/view/allShops/view/widget/store_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  // ✅ بيانات وهمية جاهزة للـ API
  final List<Map<String, dynamic>> stores = const [
    {
      "name": "مطعم برجر فاكتوري",
      "category": "برجر · توصيل مجاني",
      "rating": 4.5,
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      "deliveryTime": "20 دقيقة",
    },
    {
      "name": "بيتزا إكسبريس",
      "category": "بيتزا · إيطالي",
      "rating": 4.8,
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      "deliveryTime": "30 دقيقة",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilterController());

    return Scaffold(
      appBar: CustomAppBar(title: "كل المتاجر"),
      body: Column(
        children: [
          Obx(
            () => FiltersRowWidget(
              selectedIndex: controller.selectedIndex.value,
              onSelect: controller.changeFilter,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];

                return StoreCardWidget(
                  name: store['name'],
                  category: store['category'],
                  rating: store['rating'],
                  image: store['image'],
                  deliveryTime: store['deliveryTime'],
                  onTap: () {
                    Get.toNamed(AppRoutes.resturantDetails);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
