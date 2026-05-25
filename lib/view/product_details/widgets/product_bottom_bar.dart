import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/favorites/favorites_controller.dart';
import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';
import 'package:app/view/product_details/widgets/product_add_to_cart.dart';
import 'package:app/view/product_details/widgets/product_favorite_bar_button.dart';
import 'package:app/view/product_details/widgets/product_quantity_bar_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({
    super.key,
    required this.product,
    required this.productId,
    required this.controller,
    required this.isVariable,
    required this.selectedVariationName,
    required this.effectiveStoreId,
    required this.effectiveStoreName,
    required this.effectiveStoreImage,
    required this.effectiveStoreDeliveryFee,
  });

  final ProductDetailsModel? product;
  final int productId;
  final ProductDetailsController controller;
  final bool isVariable;
  final String? selectedVariationName;
  final int? effectiveStoreId;
  final String? effectiveStoreName;
  final String? effectiveStoreImage;
  final String? effectiveStoreDeliveryFee;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cart) {
        final safeId = product?.id ?? productId;
        final qty = isVariable
            ? cart.getQuantityByVariation(safeId, selectedVariationName)
            : cart.getQuantity(safeId);

        return GetBuilder<FavoritesController>(
          builder: (fav) {
            final isFav = fav.isFavorite('product', safeId);
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: Row(
                  children: [
                    ProductFavoriteBarButton(
                      isFavorite: isFav,
                      onPressed: () {
                        fav.toggleFavoriteById(
                          type: 'product',
                          id: safeId,
                          item: RestaurantModel(
                            id: safeId,
                            name: product?.name ?? '',
                            image: product?.imageUrl ?? '',
                            rating: product?.ratingValue ?? 0,
                            category: (product?.priceInt ?? 0).toString(),
                            favoriteType: 'product',
                            isFavorite: isFav,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: qty <= 0
                            ? ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor().primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                onPressed: () => addProductToCart(
                                  cart: cart,
                                  controller: controller,
                                  product: product,
                                  safeId: safeId,
                                  isVariable: isVariable,
                                  selectedVariationName: selectedVariationName,
                                  effectiveStoreId: effectiveStoreId,
                                  effectiveStoreName: effectiveStoreName,
                                  effectiveStoreImage: effectiveStoreImage,
                                  effectiveStoreDeliveryFee:
                                      effectiveStoreDeliveryFee,
                                ),
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'أضف إلى السلة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : ProductQuantityBarControls(
                                quantity: qty,
                                onDecrease: () {
                                  if (isVariable) {
                                    cart.decreaseQuantityByVariation(
                                      safeId,
                                      selectedVariationName,
                                    );
                                  } else {
                                    cart.decreaseQuantity(safeId);
                                  }
                                },
                                onIncrease: () {
                                  if (isVariable) {
                                    cart.increaseQuantityByVariation(
                                      safeId,
                                      selectedVariationName,
                                    );
                                  } else {
                                    cart.increaseQuantity(safeId);
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
