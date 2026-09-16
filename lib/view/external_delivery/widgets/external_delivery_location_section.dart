import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/place_prediction.dart';
import 'package:app/view/address/full_screen_map_picker_page.dart';
import 'package:app/view/address/widget/place_search_field.dart';
import 'package:app/view/external_delivery/widgets/pick_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternalDeliveryLocationSection extends StatelessWidget {
  const ExternalDeliveryLocationSection({super.key});

  Future<void> _openMapPicker(ExternalDeliveryController controller) async {
    await Get.to(
      () => FullScreenMapPickerPage(
        initialLat: controller.activeInitialLat,
        initialLng: controller.activeInitialLng,
        onConfirm: (lat, lng) async {
          controller.setPoint(lat, lng);
        },
        confirmButtonLabel: controller.pickMode.value == PickMode.from
            ? 'تأكيد موقع الانطلاق'
            : 'تأكيد موقع الوصول',
      ),
    );
  }

  Future<void> _onPlaceSelected(
    ExternalDeliveryController controller,
    double lat,
    double lng,
    PlacePrediction prediction,
  ) async {
    final label = prediction.mainText.isNotEmpty
        ? prediction.mainText
        : prediction.description;
    controller.setPoint(lat, lng, placeLabel: label);

    final detailsController = controller.pickMode.value == PickMode.from
        ? controller.fromDetailsController
        : controller.toDetailsController;
    if (detailsController.text.trim().isEmpty) {
      detailsController.text = label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExternalDeliveryController>();

    return Obx(() {
      final mode = controller.pickMode.value;
      final isFrom = mode == PickMode.from;
      final searchHint = isFrom
          ? 'ابحث عن موقع الانطلاق...'
          : 'ابحث عن موقع الوصول...';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PickModeSelector(),
          const SizedBox(height: 12),
          PlaceSearchField(
            key: ValueKey(mode),
            searchKey: mode,
            hintText: searchHint,
            originLat: controller.searchOriginLat,
            originLng: controller.searchOriginLng,
            onPlaceSelected: (lat, lng, prediction) =>
                _onPlaceSelected(controller, lat, lng, prediction),
          ),
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
              isFrom ? 'تحديد الانطلاق من الخريطة' : 'تحديد الوصول من الخريطة',
              style: TextStyle(
                color: AppColor().primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _LocationStatusCard(
            title: 'موقع الانطلاق',
            isActive: isFrom,
            isSet: controller.hasFromPoint,
            placeLabel: controller.fromPlaceLabel.value,
            lat: controller.fromLat.value,
            lng: controller.fromLng.value,
            icon: Icons.trip_origin,
            activeColor: Colors.green,
          ),
          const SizedBox(height: 8),
          _LocationStatusCard(
            title: 'موقع الوصول',
            isActive: !isFrom,
            isSet: controller.hasToPoint,
            placeLabel: controller.toPlaceLabel.value,
            lat: controller.toLat.value,
            lng: controller.toLng.value,
            icon: Icons.location_on,
            activeColor: AppColor().primaryColor,
          ),
        ],
      );
    });
  }
}

class _LocationStatusCard extends StatelessWidget {
  const _LocationStatusCard({
    required this.title,
    required this.isActive,
    required this.isSet,
    required this.placeLabel,
    required this.lat,
    required this.lng,
    required this.icon,
    required this.activeColor,
  });

  final String title;
  final bool isActive;
  final bool isSet;
  final String placeLabel;
  final double lat;
  final double lng;
  final IconData icon;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? activeColor
        : AppColor().primaryColor.withValues(alpha: 0.2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSet ? Icons.check_circle : icon,
            color: isSet ? activeColor : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  !isSet
                      ? 'لم يُحدد بعد'
                      : placeLabel.isNotEmpty
                          ? placeLabel
                          : '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
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
  }
}
