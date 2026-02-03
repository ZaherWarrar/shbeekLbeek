import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorate_tabs_controller.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InformationShopCard extends StatelessWidget {
  const InformationShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        final shopItem = controller.shopItem;
        final workHours = controller.getCurrentWorkHours();
        final isOpen = controller.isShopOpen();

        return Container(
          height: 180,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // اسم المطعم
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shopItem.name ?? "المطعم",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GetBuilder<FavoritesController>(
                      builder: (favoritesController) {
                        final shopId = shopItem.id ?? 0;
                        final isFavorite = shopId != 0 &&
                            favoritesController.isFavorite('category', shopId);
                        final favoriteItem = RestaurantModel(
                          id: shopId,
                          name: shopItem.name ?? '',
                          image: shopItem.imageUrl ?? '',
                          rating: 0,
                          category: shopItem.type ?? '',
                          favoriteType: 'category',
                          isFavorite: isFavorite,
                        );

                        return Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(148, 248, 228, 198),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: shopId == 0
                                  ? null
                                  : () {
                                      favoritesController.toggleFavoriteById(
                                        type: 'category',
                                        id: shopId,
                                        item: favoriteItem,
                                      );
                                    },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColor().primaryColor,
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // التقييم + النوع
                Row(
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(148, 248, 228, 198),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: Icon(
                            Icons.star_border,
                            color: AppColor().primaryColor,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "4.8 (500+ تقييم) ",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    if (shopItem.type != null) ...[
                      Text(
                        " · ${shopItem.type}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),

                // رسوم التوصيل
                Row(
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.motorcycle_rounded, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      shopItem.deliveryFee != null
                          ? "رسوم التوصيل: ${shopItem.deliveryFee} ليرة"
                          : "التوصيل خلال 25-35 دقيقة",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // حالة الفتح + الساعات
                Row(
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: isOpen
                            ? const Color.fromARGB(149, 197, 225, 165)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: Icon(
                            Icons.timer_outlined,
                            color: isOpen ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        workHours,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
