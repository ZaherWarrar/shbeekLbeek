import 'package:app/controller/favorites/favorites_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel item;

  const RestaurantCard({super.key, required this.item});

  static const double imageHeight = 114;
  static const double cardExtent = 210;

  bool get _isProduct => item.favoriteType == 'product';

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController(), permanent: true);

    final subtitle = _subtitle();

    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: _openDetails,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColor().backgroundColorCard,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: item.image.isNotEmpty
                          ? Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.imagesLogo,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(Assets.imagesLogo, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => controller.toggleFavoriteById(
                        type: item.favoriteType,
                        id: item.id,
                        item: item,
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Obx(
                          () => Icon(
                            item.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColor().primaryColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (!_isProduct && item.rating > 0) ...[
                            Text(
                              item.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColor().primaryColor,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor().descriptionColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle() {
    final value = item.category.trim();
    if (value.isEmpty) return '';
    if (_isProduct && !value.contains('ل')) {
      return '$value ل.س';
    }
    return value;
  }

  void _openDetails() {
    if (item.id <= 0) return;
    if (_isProduct) {
      Get.toNamed(AppRoutes.productDetails, arguments: {'productId': item.id});
      return;
    }
    Get.toNamed(
      AppRoutes.resturantDetails,
      arguments: {
        'id': item.id,
        'categoryName': item.category,
      },
    );
  }
}
