import 'package:app/view/adress/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import 'widget/map_picker_placeholder.dart';

class AddAddressPage extends GetView<AddressController> {
  AddAddressPage({super.key});

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة عنوان"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const MapPickerPlaceholder(),
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
              onPressed: () {
                controller.addAddress(
                  AddressModel(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    description: descController.text,
                    lat: controller.selectedLat.value,
                    lng: controller.selectedLng.value,
                  ),
                );
                Get.back();
              },

              child: const Text("حفظ العنوان"),
            ),
          ],
        ),
      ),
    );
  }
}
