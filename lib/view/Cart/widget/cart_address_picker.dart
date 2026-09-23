import 'package:app/controller/address/address_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const cartAddressPickerAddNew = '__add_new_address__';

Future<String?> showCartAddressPicker({
  required AddressController addressController,
  String? selectedId,
}) {
  return Get.dialog<String?>(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: AppColor().backgroundColorCard,
      title: Text(
        'اختر عنوان التوصيل',
        style: TextStyle(
          color: AppColor().titleColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Obx(() {
          final list = addressController.addresses;
          if (list.isEmpty) {
            return Text(
              'لا يوجد عناوين',
              style: TextStyle(color: AppColor().descriptionColor),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final address = list[index];
              final isSelected = address.id == selectedId;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  address.title,
                  style: TextStyle(
                    color: AppColor().titleColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  address.description,
                  style: TextStyle(color: AppColor().descriptionColor),
                ),
                trailing: Icon(
                  isSelected ? Icons.check_circle : Icons.location_on_outlined,
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
          onPressed: () => Get.back(result: cartAddressPickerAddNew),
          child: const Text('إضافة عنوان جديد'),
        ),
      ],
    ),
  );
}
