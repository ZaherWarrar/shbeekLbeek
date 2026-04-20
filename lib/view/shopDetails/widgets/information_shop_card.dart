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
        final store = controller.store;
        final summary = controller.shopItemSummary;
        final shopId = store?.id ?? summary?.id ?? 0;
        final shopName = store?.name ?? summary?.name ?? "المطعم";
        final category = store?.categoryName ?? summary?.categoryName;
        final imageUrl = store?.imageUrl ?? summary?.imageUrl ?? '';
        final rating = store?.rating ?? summary?.rating ?? 0;
        final deliveryFee = store?.deliveryFee ?? summary?.deliveryFee;

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
                        shopName,
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
                        final isFavorite = shopId != 0 &&
                            favoritesController.isFavorite('category', shopId);
                        final favoriteItem = RestaurantModel(
                          id: shopId,
                          name: shopName,
                          image: imageUrl,
                          rating: rating,
                          category: category ?? '',
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
                      rating == 0 ? "—" : rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    if ((category ?? '').isNotEmpty) ...[
                      Text(
                        " · $category",
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
                      deliveryFee != null
                          ? "رسوم التوصيل: $deliveryFee ليرة"
                          : "التوصيل خلال 25-35 دقيقة",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
