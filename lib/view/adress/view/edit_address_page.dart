import 'package:app/core/constant/app_color.dart';
import 'package:app/view/adress/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import 'widget/map_picker_widget.dart';

class EditAddressPage extends StatefulWidget {
  final AddressModel address;

  const EditAddressPage({super.key, required this.address});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late AddressController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddressController>();
    titleController = TextEditingController(text: widget.address.title);
    descController = TextEditingController(text: widget.address.description);

    // تعيين الموقع الحالي في الخريطة
    controller.setLocation(widget.address.lat, widget.address.lng);
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        title: const Text("تعديل عنوان"),
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor().titleColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const MapPickerWidget(),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "اسم العنوان"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "وصف العنوان"),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  Get.snackbar(
                    'تنبيه',
                    'الرجاء إدخال اسم العنوان',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                if (controller.selectedLat.value == 0.0 ||
                    controller.selectedLng.value == 0.0) {
                  Get.snackbar(
                    'تنبيه',
                    'الرجاء تحديد الموقع على الخريطة',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                final updatedAddress = AddressModel(
                  id: widget.address.id,
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  lat: controller.selectedLat.value,
                  lng: controller.selectedLng.value,
                  isDefault: widget.address.isDefault,
                );

                await controller.updateAddress(updatedAddress);
                Get.back();
                Get.snackbar(
                  'نجاح',
                  'تم تحديث العنوان بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text("حفظ التعديلات"),
            ),
          ],
        ),
      ),
    );
  }
}
