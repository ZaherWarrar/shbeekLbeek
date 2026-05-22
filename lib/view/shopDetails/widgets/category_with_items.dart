import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorate_tabs_controller.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWithItems extends StatelessWidget {
  const CategoryWithItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return GetBuilder<CartController>(
          builder: (cartController) {
            final tabs = controller.innerCategoryTabs;
            final products = controller.displayedProducts;

            if (controller.filteredProducts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "لا توجد منتجات متاحة",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CategoryTabsRow(
                  tabs: tabs,
                  selectedId: controller.selectedInnerCategoryId,
                  onSelect: controller.selectInnerCategory,
                ),
                const SizedBox(height: 8),
                if (products.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "لا توجد منتجات في هذا القسم",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ...products.map(
                    (product) => _ProductListTile(
                      product: product,
                      controller: controller,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CategoryTabsRow extends StatelessWidget {
  const _CategoryTabsRow({
    required this.tabs,
    required this.selectedId,
    required this.onSelect,
  });

  final List<({int? id, String name})> tabs;
  final int? selectedId;
  final void Function(int? categoryId) onSelect;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 360 ? 10.0 : 14.0;
    final verticalPadding = width < 360 ? 6.0 : 8.0;
    final fontSize = width < 360 ? 12.0 : 14.0;
    final spacing = width < 360 ? 6.0 : 10.0;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = tab.id == selectedId;

          return GestureDetector(
            onTap: () => onSelect(tab.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor().primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColor().primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  tab.name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({
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
                        product.name ?? "منتج",
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
                          "",
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
                                    "$price ليرة",
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
                                "$quantity",
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
                      product.imageUrl ?? "",
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
