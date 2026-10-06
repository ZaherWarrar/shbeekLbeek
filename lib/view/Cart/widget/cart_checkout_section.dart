import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/controller/address/address_controller.dart';
import 'package:app/view/address/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

class CartCheckoutSection extends StatelessWidget {
  final CartController controller;

  const CartCheckoutSection({super.key, required this.controller});

  String _formatPrice(double price) => "${price.toStringAsFixed(0)} ليرة";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return GetBuilder<OrderController>(
      builder: (orderController) {
        final isCreating = orderController.isCreatingOrder;

        return Container(
          padding: EdgeInsets.all(padding),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              disabledBackgroundColor: Colors.orange,
              disabledForegroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: isCreating ? null : () => _onCheckoutPressed(),
            child: isCreating
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "إتمام الطلب | ${_formatPrice(controller.total)}",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _onCheckoutPressed() async {
    if (controller.isEmpty) {
      AppSnackbar.show("تنبيه", "السلة فارغة", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final notes = controller.notesController.text.trim();
    final addressController = Get.find<AddressController>();
    final orderController = Get.find<OrderController>();
    if (orderController.isCreatingOrder) return;

    if (controller.checkoutAddress == null) {
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
              style: TextStyle(color: AppColor().descriptionColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: AppColor().primaryColor),
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

      AppSnackbar.show(
        'تنبيه',
        'الرجاء اختيار موقع التوصيل',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    orderController.createOrder(notes.isEmpty ? null : notes);
  }
}
