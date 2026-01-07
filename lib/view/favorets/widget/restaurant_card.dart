import 'package:app/view/favorets/widget/favorates_tabs/favorate_tabs_controller.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel item;
  final int index;

  const RestaurantCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// ❤️ زر المفضلة 
                Positioned(
                  top: 10,
                  right: 10,
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () => controller.toggleFavorite(index),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          item.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.orange,
                          size: 16,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(item.rating.toString(),
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    const Icon(Icons.star,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.category,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
