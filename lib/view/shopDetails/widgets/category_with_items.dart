import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWithItems extends StatelessWidget {
  const CategoryWithItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        // استخدام GetBuilder للـ CartController أيضاً لتحديث الكمية عند تغيير السلة
        return GetBuilder<CartController>(
          builder: (cartController) {
            final categories = controller.getProductsByCategory();

            if (categories.isEmpty) {
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
              children: categories.entries.map((entry) {
                int? categoryId = entry.key;
                List<Products> products = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // عنوان التصنيف
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الفئة ${categoryId ?? ""}",
                          style: TextStyle(
                            color: AppColor().titleColor,
                            fontSize: getResponsiveFontSize(
                              context,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Loop on items inside category
                    Column(
                      children: products.map<Widget>((product) {
                        final productId = product.id ?? 0;
                        final quantity = controller.getProductQuantity(
                          productId,
                        );
                        final price = controller.getProductPrice(product);

                        final screenWidth = MediaQuery.of(context).size.width;
                        final isSmallScreen = screenWidth < 400;
                        final imageSize = isSmallScreen ? 80.0 : 120.0;
                        final containerHeight = isSmallScreen ? 120.0 : 150.0;

                        return Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
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
                                  // النصوص
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            product.description ?? "",
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 10 : 12,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: isSmallScreen ? 2 : 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: isSmallScreen ? 6 : 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "$price ليرة",
                                                style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // العداد
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    controller.decreaseQuantity(
                                                      productId,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: isSmallScreen
                                                        ? 20
                                                        : 25,
                                                  ),
                                                  color:
                                                      AppColor().primaryColor,
                                                  padding: EdgeInsets.all(
                                                    isSmallScreen ? 4 : 8,
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: isSmallScreen
                                                        ? 32
                                                        : 40,
                                                    minHeight: isSmallScreen
                                                        ? 32
                                                        : 40,
                                                  ),
                                                ),
                                                Text(
                                                  "$quantity",
                                                  style: TextStyle(
                                                    fontSize: isSmallScreen
                                                        ? 16
                                                        : 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    controller.increaseQuantity(
                                                      productId,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: isSmallScreen
                                                        ? 20
                                                        : 25,
                                                  ),
                                                  color:
                                                      AppColor().primaryColor,
                                                  padding: EdgeInsets.all(
                                                    isSmallScreen ? 4 : 8,
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: isSmallScreen
                                                        ? 32
                                                        : 40,
                                                    minHeight: isSmallScreen
                                                        ? 32
                                                        : 40,
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

                                  // الصورة
                                  SizedBox(
                                    height: imageSize,
                                    width: imageSize,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        product.imageUrl ?? "",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
