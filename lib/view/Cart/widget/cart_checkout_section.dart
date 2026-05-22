import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/view/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartCheckoutSection extends StatelessWidget {
  final CartController controller;

  const CartCheckoutSection({super.key, required this.controller});

  String _formatPrice(double price) => "${price.toStringAsFixed(0)} ليرة";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(padding),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => _onCheckoutPressed(),
        child: Text(
          "إتمام الطلب | ${_formatPrice(controller.total)}",
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _onCheckoutPressed() async {
    if (controller.isEmpty) {
      Get.snackbar("تنبيه", "السلة فارغة", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final notes = controller.notesController.text.trim();
    final addressController = Get.find<AddressController>();
    final orderController = Get.find<OrderController>();

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

    final defaultAddresses = addressController.addresses.where(
      (a) => a.isDefault,
    );
    if (defaultAddresses.isNotEmpty) {
      orderController.createOrder(notes.isEmpty ? null : notes);
      return;
    }

    final chosenId = await _showAddressSelectionDialog(addressController);
    if (chosenId != null) {
      await addressController.setDefaultAddress(chosenId);
      orderController.createOrder(notes.isEmpty ? null : notes);
      return;
    }

    Get.to(() => const AddAddressPage());
  }

  Future<String?> _showAddressSelectionDialog(
    AddressController addressController,
  ) {
    return Get.dialog<String?>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                    style: TextStyle(color: AppColor().descriptionColor),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final address = list[index];
                      return ListTile(
                        title: Text(
                          address.title,
                          style: TextStyle(color: AppColor().titleColor),
                        ),
                        subtitle: Text(
                          address.description,
                          style: TextStyle(color: AppColor().descriptionColor),
                        ),
                        trailing: Icon(
                          Icons.location_on_outlined,
                          color: AppColor().primaryColor,
                        ),
                        onTap: () => Get.back(result: address.id),
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
            onPressed: () => Get.back(result: null),
            child: const Text('إضافة عنوان جديد'),
          ),
        ],
      ),
    );
  }
}
