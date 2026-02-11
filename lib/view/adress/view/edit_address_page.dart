import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/valid_function.dart';
import 'package:app/core/shared/custom_text_form_fild.dart';
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
  late TextEditingController cityController;
  late TextEditingController descController;
  late AddressController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddressController>();
    
    // استخراج المدينة والعنوان من الوصف
    final parts = widget.address.description.split(',');
    final city = parts.isNotEmpty ? parts.first.trim() : '';
    final address = parts.length > 1 
        ? parts.sublist(1).join(',').trim() 
        : widget.address.description;
    
    titleController = TextEditingController(text: widget.address.title);
    cityController = TextEditingController(text: city);
    descController = TextEditingController(text: address);

    // تعيين الموقع الحالي في الخريطة
    controller.setLocation(widget.address.lat, widget.address.lng);
    
    // الاستماع لتغييرات المدينة والعنوان الكامل
    ever(controller.cityName, (city) {
      if (mounted && city.isNotEmpty) {
        cityController.text = city;
      }
    });
    ever(controller.fullAddress, (address) {
      if (mounted && address.isNotEmpty) {
        descController.text = address;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    cityController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          child: ListView(
            children: [
              const MapPickerWidget(),
              const SizedBox(height: 20),
              CustomTextFormFild(
                hint: "أدخل اسم العنوان",
                controller: titleController,
                valid: (val) {
                  return validTextForm(val ?? '', "name", 100, 3);
                },
                lable: "اسم العنوان",
                iconData: Icons.location_on_outlined,
                scure: false,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomTextFormFild(
                  hint: "سيتم ملؤه تلقائياً",
                  controller: cityController,
                  valid: (val) => null,
                  lable: "المدينة",
                  iconData: controller.isLoadingAddress.value
                      ? Icons.hourglass_empty
                      : Icons.location_city,
                  scure: false,
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomTextFormFild(
                  hint: "سيتم ملؤه تلقائياً",
                  controller: descController,
                  valid: (val) => null,
                  lable: "تفاصيل الموقع",
                  iconData: controller.isLoadingAddress.value
                      ? Icons.hourglass_empty
                      : Icons.map_outlined,
                  scure: false,
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 20),
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
                    description:
                        '${cityController.text.trim()}, ${descController.text.trim()}',
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
      ),
    );
  }
}
