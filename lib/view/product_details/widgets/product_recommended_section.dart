import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/data/datasource/model/store_model.dart';
import 'package:app/view/product_details/product_details_actions.dart';
import 'package:app/view/product_details/widgets/product_recommended_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRecommendedSection extends StatelessWidget {
  const ProductRecommendedSection({
    super.key,
    required this.controller,
    required this.effectiveStoreId,
    required this.effectiveStoreName,
    required this.effectiveStoreImage,
    required this.effectiveStoreDeliveryFee,
  });

  final ProductDetailsController controller;
  final int? effectiveStoreId;
  final String? effectiveStoreName;
  final String? effectiveStoreImage;
  final String? effectiveStoreDeliveryFee;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'منتجات مقترحة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColor().titleColor,
          ),
        ),
        const SizedBox(height: 12),
        if (controller.statusRequest == StatusRequest.success &&
            controller.recommended.isEmpty)
          Text(
            'لا يوجد اقتراحات حالياً',
            style: TextStyle(color: AppColor().descriptionColor),
          )
        else
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recommended.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final rec = controller.recommended[index];
                return ProductRecommendedCard(
                  name: rec.name ?? 'منتج',
                  price: formatProductPrice(rec.priceInt),
                  imageUrl: rec.imageUrl ?? '',
                  onAdd: () => _addRecommendedToCart(rec),
                  onTap: () => openRecommendedProduct(
                    recId: rec.id,
                    storeId: rec.storeId ?? effectiveStoreId,
                    storeName: rec.storeName ?? effectiveStoreName,
                    storeImageUrl: rec.storeImageUrl ?? effectiveStoreImage,
                    storeDeliveryFee:
                        rec.storeDeliveryFee ?? effectiveStoreDeliveryFee,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _addRecommendedToCart(RecommendedProductModel rec) {
    final cart = Get.find<CartController>();
    final storeId = rec.storeId ?? effectiveStoreId;
    if (storeId == null || storeId <= 0) {
      Get.snackbar('تنبيه', 'لا يمكن إضافة المنتج بدون معرّف المتجر');
      return;
    }
    final shop = StoreModel(
      id: storeId,
      name: rec.storeName ?? effectiveStoreName ?? 'متجر',
      imageUrl: rec.storeImageUrl ?? effectiveStoreImage,
      deliveryFee: rec.storeDeliveryFee ?? effectiveStoreDeliveryFee,
    );
    final p = Products(
      id: rec.id,
      name: rec.name,
      imageUrl: rec.imageUrl,
      regularPrice: rec.priceInt,
    );
    cart.addItem(p, shop, quantity: 1);
  }
}
