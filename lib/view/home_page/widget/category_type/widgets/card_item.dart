import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/app_snackbar.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.controller, required this.index});
  final HomeControllerImp controller;
  final int index;

  static const double cardWidth = 176;
  static const double imageHeight = 114;
  static const double listHeight = 218;

  @override
  Widget build(BuildContext context) {
    final items = controller.finalSection[controller.sectionName] ?? [];
    final sectionItem = items[index];

    ItemModel? storeItem;
    if (sectionItem.storeId != null) {
      try {
        storeItem = controller.items.firstWhere(
          (item) => item.id == sectionItem.storeId,
        );
      } catch (_) {
        storeItem = null;
      }
    }

    final name = sectionItem.name ?? '';
    final description = sectionItem.description?.trim() ?? '';

    return GestureDetector(
      onTap: () {
        final productId = sectionItem.id;
        if (productId == null || productId <= 0) {
          AppSnackbar.show(
            'تنبيه',
            'معرّف المنتج غير صحيح',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        Get.toNamed(
          AppRoutes.productDetails,
          arguments: {
            'productId': productId,
            'storeId': sectionItem.storeId ?? storeItem?.id,
            'storeName': storeItem?.name,
            'storeImageUrl': storeItem?.imageUrl,
            'storeDeliveryFee': storeItem?.deliveryFee,
          },
        );
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: cardWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColor().backgroundColorCard,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    sectionItem.imageUrl ?? '',
                    height: imageHeight,
                    width: cardWidth,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: imageHeight,
                      width: cardWidth,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.35,
                            color: AppColor().descriptionColor,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.star_border,
                            color: AppColor().primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '4',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '200',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor().descriptionColor,
                            ),
                          ),
                        ],
                      ),
                    ],
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
