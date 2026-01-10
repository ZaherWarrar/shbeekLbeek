import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/Cart/widget/active_order_widget.dart';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor().backgroundColor,
        appBar: CustomAppBar(title: "السلة"),
        body: GetBuilder<OrderController>(
          builder: (orderController) {
            // التحقق من وجود طلب نشط
            // loadActiveOrder يتم استدعاؤه في onInit() فقط
            if (orderController.hasActiveOrder() &&
                orderController.currentOrderId != null) {
              // عرض حالة الطلب النشط
              return const ActiveOrderWidget();
            }

            // عرض السلة العادية
            return GetBuilder<CartController>(
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
                            padding: EdgeInsets.only(
                              bottom: isSmallScreen ? 8 : 10,
                            ),
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
                                    : (item['quantity'] as double?)?.toInt() ??
                                          1;

                                if (productId == null)
                                  return const SizedBox.shrink();

                                return CartItemWidget(
                                  title:
                                      item['productName']?.toString() ?? "منتج",
                                  subtitle:
                                      item['productDescription']?.toString() ??
                                      "",
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

                          // حقل الملاحظات
                          TextField(
                            controller: controller.notesController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "ملاحظات إضافية للطلب (اختياري)",
                              hintStyle: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[600],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor().primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                            ),
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                            onChanged: (value) async {
                              await controller.saveCart();
                            },
                          ),

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
                          // التحقق من وجود منتجات في السلة
                          if (controller.isEmpty) {
                            Get.snackbar(
                              "تنبيه",
                              "السلة فارغة",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          // الحصول على الملاحظات
                          final notes = controller.notesController.text.trim();

                          // إنشاء الطلب (استخدام orderController من GetBuilder الخارجي)
                          orderController.createOrder(
                            notes.isEmpty ? null : notes,
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
            );
          },
        ),
      ),
    );
  }
}
