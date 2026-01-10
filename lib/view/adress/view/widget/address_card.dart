import 'package:app/core/constant/app_color.dart';
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/model/address_model.dart';
import 'package:app/view/adress/view/edit_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor().titleColor.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColor().primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.description,
                      style: TextStyle(
                        color: AppColor().descriptionColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor().primaryColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "افتراضي",
                    style: TextStyle(
                      color: AppColor().primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // زر تعيين كافتراضي
              if (!address.isDefault)
                TextButton.icon(
                  onPressed: () async {
                    await controller.setDefaultAddress(address.id);
                    Get.snackbar(
                      'نجاح',
                      'تم تعيين العنوان كافتراضي',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: Icon(
                    Icons.star_outline,
                    size: 18,
                    color: AppColor().primaryColor,
                  ),
                  label: Text(
                    'افتراضي',
                    style: TextStyle(
                      color: AppColor().primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // زر التعديل
              IconButton(
                onPressed: () {
                  Get.to(() => EditAddressPage(address: address));
                },
                icon: Icon(
                  Icons.edit,
                  color: AppColor().primaryColor,
                  size: 20,
                ),
              ),
              // زر الحذف
              IconButton(
                onPressed: () async {
                  // عرض dialog تأكيد
                  final confirmed = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('حذف العنوان'),
                      content: const Text('هل أنت متأكد من حذف هذا العنوان؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await controller.deleteAddress(address.id);
                    Get.snackbar(
                      'نجاح',
                      'تم حذف العنوان بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
