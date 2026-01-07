import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/Cart/widget/cart_item_widget.dart';
import 'package:app/view/Cart/widget/discount_code_widget.dart';
import 'package:app/view/Cart/widget/empty_cart_widget.dart';
import 'package:app/view/Cart/widget/summary_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  String _formatPrice(double price) {
    return "${price.toStringAsFixed(0)} ليرة";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final padding = isSmallScreen ? 12.0 : 16.0;
    final fontSize = isSmallScreen ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomAppBar(title: "السلة"),
      body: GetBuilder<CartController>(
        builder: (controller) {
          if (controller.isEmpty) {
            return const EmptyCartWidget();
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(padding),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
                      child: Text(
                        "المنتجات",
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),

                    // عرض المنتجات من Controller
                    ...controller.cartItems
                        .where((item) => item['productId'] != null)
                        .map((item) {
                          final productId = item['productId'] as int?;
                          final price = item['price'] is int
                              ? item['price'] as int
                              : (item['price'] as double?)?.toInt() ?? 0;
                          final quantity = item['quantity'] is int
                              ? item['quantity'] as int
                              : (item['quantity'] as double?)?.toInt() ?? 1;

                          if (productId == null) return const SizedBox.shrink();

                          return CartItemWidget(
                            title: item['productName']?.toString() ?? "منتج",
                            subtitle:
                                item['productDescription']?.toString() ?? "",
                            price: price,
                            quantity: quantity,
                            image: item['productImage']?.toString() ?? "",
                            productId: productId,
                            onIncrease: () {
                              controller.increaseQuantity(productId);
                            },
                            onDecrease: () {
                              controller.decreaseQuantity(productId);
                            },
                            onDelete: () {
                              controller.removeItem(productId);
                            },
                          );
                        }),

                    const SizedBox(height: 10),

                    const DiscountCodeWidget(),

                    const SizedBox(height: 20),

                    SummaryRowWidget(
                      "المجموع الفرعي",
                      _formatPrice(controller.subtotal),
                    ),
                    SummaryRowWidget(
                      "رسوم التوصيل",
                      _formatPrice(controller.calculatedDeliveryFee),
                    ),
                    SummaryRowWidget(
                      "الخصم",
                      _formatPrice(controller.calculatedDiscount),
                    ),
                    const Divider(),
                    SummaryRowWidget(
                      "المجموع الإجمالي",
                      _formatPrice(controller.total),
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              // زر إتمام الطلب
              Container(
                padding: EdgeInsets.all(padding),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      "قريباً",
                      "سيتم إضافة صفحة إتمام الطلب قريباً",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text(
                    "إتمام الطلب | ${_formatPrice(controller.total)}",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
