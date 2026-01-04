import 'package:app/view/favorets/widget/favorates_tabs/favorate_tabs_controller.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorites_tabs.dart';
import 'package:app/view/favorets/widget/favorites_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // الأفضل: حقن الكونترولر هنا وليس كـ متغير داخل الكلاس
    final controller = Get.put(FavoritesController());

    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width >= 900
        ? 4
        : width >= 600
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "المفضلة",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        leading: const Icon(Icons.search, color: Colors.black),
        actions: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 12),
          //   child: IconButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     icon: Icon(
          //       Icons.arrow_forward_ios,
          //       color: Colors.black,
          //       size: 18,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          FavoritesTabs(),
          const SizedBox(height: 16),

          /// هنا نراقب قائمة المطاعم
          Expanded(
            child: Obx(() {
              if (controller.restaurants.isEmpty) {
                return const Center(child: Text("لا يوجد عناصر"));
              }

              return FavoritesGrid(
                items: controller.restaurants,
                crossAxisCount: crossAxisCount,
              );
            }),
          ),
        ],
      ),
    );
  }
}
