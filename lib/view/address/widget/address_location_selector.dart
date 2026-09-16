import 'package:app/controller/address/address_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/address/full_screen_map_picker_page.dart';
import 'package:app/view/address/widget/place_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressLocationSelector extends StatelessWidget {
  const AddressLocationSelector({super.key});

  Future<void> _openMapPicker(AddressController controller) async {
    await Get.to(
      () => FullScreenMapPickerPage(
        initialLat: controller.selectedLat.value,
        initialLng: controller.selectedLng.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PlaceSearchField(),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: BorderSide(color: AppColor().primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _openMapPicker(controller),
          icon: Icon(Icons.map_outlined, color: AppColor().primaryColor),
          label: Text(
            'تحديد الموقع من الخريطة',
            style: TextStyle(
              color: AppColor().primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final hasLocation = controller.selectedLat.value != 0.0 &&
              controller.selectedLng.value != 0.0;
          if (!hasLocation && controller.fullAddress.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor().primaryColor.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColor().primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الموقع المحدد',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.isLoadingAddress.value
                            ? 'جارٍ تحديد العنوان...'
                            : controller.fullAddress.value.isNotEmpty
                                ? controller.fullAddress.value
                                : 'تم تحديد الإحداثيات على الخريطة',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
