import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/controller/favorites/favorites_controller.dart';
import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopProductListTile extends StatelessWidget {
  const ShopProductListTile({
    super.key,
    required this.product,
    required this.controller,
  });

  final Products product;
  final ShopDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final productId = product.id ?? 0;
    final quantity = controller.getProductQuantity(productId);
    final price = controller.getProductPrice(product);

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final imageSize = isSmallScreen ? 80.0 : 120.0;
    final containerHeight = isSmallScreen ? 120.0 : 150.0;

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
      child: InkWell(
        onTap: productId == 0
            ? null
            : () => Get.toNamed(
                AppRoutes.productDetails,
                arguments: {
                  'productId': productId,
                  'storeId': controller.storeId,
                  'storeName': controller.store?.name,
                  'storeImageUrl': controller.store?.imageUrl,
                  'storeDeliveryFee': controller.store?.deliveryFee,
                },
              ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8.0 : 12.0,
              vertical: isSmallScreen ? 10.0 : 15.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name ?? 'منتج',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 3 : 5),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: isSmallScreen ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '$price ليرة',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GetBuilder<FavoritesController>(
                                  builder: (favoritesController) {
                                    final isFavorite = favoritesController
                                        .isFavorite('product', productId);
                                    final favoriteItem = RestaurantModel(
                                      id: productId,
                                      name: product.name ?? '',
                                      image: product.imageUrl ?? '',
                                      rating: 0,
                                      category: price.toString(),
                                      favoriteType: 'product',
                                      isFavorite: isFavorite,
                                    );

                                    return IconButton(
                                      iconSize: isSmallScreen ? 18 : 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 24,
                                        minHeight: 24,
                                      ),
                                      onPressed: productId <= 0
                                          ? null
                                          : () {
                                              favoritesController
                                                  .toggleFavoriteById(
                                                type: 'product',
                                                id: productId,
                                                item: favoriteItem,
                                              );
                                            },
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: AppColor().primaryColor,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.decreaseQuantity(productId);
                                },
                                icon: Icon(
                                  Icons.remove,
                                  size: isSmallScreen ? 20 : 25,
                                ),
                                color: AppColor().primaryColor,
                                padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                                constraints: BoxConstraints(
                                  minWidth: isSmallScreen ? 32 : 40,
                                  minHeight: isSmallScreen ? 32 : 40,
                                ),
                              ),
                              Text(
                                '$quantity',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.increaseQuantity(productId);
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: isSmallScreen ? 20 : 25,
                                ),
                                color: AppColor().primaryColor,
                                padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                                constraints: BoxConstraints(
                                  minWidth: isSmallScreen ? 32 : 40,
                                  minHeight: isSmallScreen ? 32 : 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isSmallScreen ? 2 : 3),
                SizedBox(
                  height: imageSize,
                  width: imageSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      product.imageUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Assets.imagesLogo,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
