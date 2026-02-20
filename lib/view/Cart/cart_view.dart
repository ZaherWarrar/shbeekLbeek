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
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/view/add_address_page.dart';

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
            // حالة وجود طلب نشط
            if (orderController.hasActiveOrder() &&
                orderController.currentOrderId != null) {
              return const ActiveOrderWidget();
            }

            // عرض السلة
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

                          // عناصر السلة
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

                                if (productId == null) {
                                  return const SizedBox.shrink();
                                }

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

                          // ملاحظات الطلب
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
                        onPressed: () async {
                          if (controller.isEmpty) {
                            Get.snackbar(
                              "تنبيه",
                              "السلة فارغة",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          final notes = controller.notesController.text.trim();

                          final addressController =
                              Get.find<AddressController>();

                          if (addressController.addresses.isEmpty) {
                            final add = await Get.dialog<bool>(
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: AppColor().backgroundColorCard,
                                title: Text(
                                  'لا يوجد عنوان',
                                  style: TextStyle(
                                    color: AppColor().titleColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: Text(
                                  'يجب إضافة عنوان لتسليم الطلب. هل تريد إضافة عنوان الآن؟',
                                  style: TextStyle(
                                    color: AppColor().descriptionColor,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: Text(
                                      'إلغاء',
                                      style: TextStyle(
                                        color: AppColor().primaryColor,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor().primaryColor,
                                      foregroundColor:
                                          AppColor().textButomColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => Get.back(result: true),
                                    child: const Text('أضف الآن'),
                                  ),
                                ],
                              ),
                            );

                            if (add == true) {
                              Get.to(() => const AddAddressPage());
                            }

                            return;
                          }

                          final defaultList = addressController.addresses.where(
                            (a) => a.isDefault,
                          );

                          if (defaultList.isNotEmpty) {
                            orderController.createOrder(
                              notes.isEmpty ? null : notes,
                            );
                            return;
                          }

                          final chosenId = await Get.dialog<String?>(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: AppColor().backgroundColorCard,
                              title: Text(
                                'اختر عنواناً',
                                style: TextStyle(
                                  color: AppColor().titleColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: Obx(() {
                                  final list = addressController.addresses;
                                  return list.isEmpty
                                      ? Text(
                                          'لا يوجد عناوين',
                                          style: TextStyle(
                                            color: AppColor().descriptionColor,
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: list.length,
                                          separatorBuilder: (_, __) =>
                                              const Divider(),
                                          itemBuilder: (context, index) {
                                            final a = list[index];
                                            return ListTile(
                                              title: Text(
                                                a.title,
                                                style: TextStyle(
                                                  color: AppColor().titleColor,
                                                ),
                                              ),
                                              subtitle: Text(
                                                a.description,
                                                style: TextStyle(
                                                  color: AppColor()
                                                      .descriptionColor,
                                                ),
                                              ),
                                              trailing: Icon(
                                                Icons.location_on_outlined,
                                                color: AppColor().primaryColor,
                                              ),
                                              onTap: () =>
                                                  Get.back(result: a.id),
                                            );
                                          },
                                        );
                                }),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: null),
                                  child: Text(
                                    'إلغاء',
                                    style: TextStyle(
                                      color: AppColor().primaryColor,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor().primaryColor,
                                    foregroundColor: AppColor().textButomColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Get.back(result: null),
                                  child: const Text('إضافة عنوان جديد'),
                                ),
                              ],
                            ),
                          );

                          if (chosenId != null) {
                            await addressController.setDefaultAddress(chosenId);
                            orderController.createOrder(
                              notes.isEmpty ? null : notes,
                            );
                            return;
                          }

                          Get.to(() => const AddAddressPage());
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
