import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/app_snackbar.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/view/shopDetails/widgets/shop_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.controller, required this.index});
  final HomeControllerImp controller;
  final int index;

  /// عرض التصميم الذي طُبطت عليه المقاسات الحالية.
  static const double _designWidth = 390;

  static double scaleOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / _designWidth).clamp(0.85, 1.2);
  }

  static double unit(BuildContext context, double designPx) =>
      designPx * scaleOf(context);

  static double cardWidthOf(BuildContext context) => unit(context, 176);

  static double imageHeightOf(BuildContext context) => unit(context, 114);

  static double listHeightOf(BuildContext context) => unit(context, 175);

  @override
  Widget build(BuildContext context) {
    final items = controller.currentSectionItems;
    if (index < 0 || index >= items.length) return const SizedBox.shrink();
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
    final cardWidth = cardWidthOf(context);
    final imageHeight = imageHeightOf(context);
    double u(double designPx) => unit(context, designPx);

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
            'productName': sectionItem.name,
            'productImageUrl': sectionItem.imageUrl,
            'productPrice': sectionItem.salePrice ?? sectionItem.regularPrice,
          },
        );
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: cardWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(u(18)),
              color: AppColor().backgroundColorCard,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(u(18)),
                  ),
                  child: ShopNetworkImage(
                    url: sectionItem.imageUrl,
                    height: imageHeight,
                    width: cardWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(u(10), u(8), u(10), u(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: u(14),
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        SizedBox(height: u(4)),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: u(12),
                            height: 1.35,
                            color: AppColor().descriptionColor,
                          ),
                        ),
                      ],
                      SizedBox(height: u(4)),
                      Row(
                        children: [
                          Text(
                            '4',
                            style: TextStyle(
                              fontSize: u(12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: u(4)),
                          Icon(
                            Icons.star_border,
                            color: AppColor().primaryColor,
                            size: u(16),
                          ),
                          const Spacer(),
                          Text(
                            '200',
                            style: TextStyle(
                              fontSize: u(12),
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
