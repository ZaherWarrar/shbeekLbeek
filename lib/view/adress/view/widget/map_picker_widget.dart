import 'package:app/core/constant/app_color.dart';
import 'package:app/main.dart';
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPickerWidget extends StatelessWidget {
  const MapPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Obx(() {
      final selectedLat = controller.selectedLat.value;
      final selectedLng = controller.selectedLng.value;

      // البحث عن العنوان الافتراضي
      AddressModel? defaultAddress;
      try {
        defaultAddress = controller.addresses.firstWhere(
          (address) => address.isDefault,
        );
      } catch (e) {
        defaultAddress = null;
      }

      // تحديد الموقع الافتراضي
      LatLng initialCenter;
      if (selectedLat != 0.0 && selectedLng != 0.0) {
        // استخدام الموقع المحدد حالياً
        initialCenter = LatLng(selectedLat, selectedLng);
      } else if (defaultAddress != null) {
        // استخدام العنوان الافتراضي
        initialCenter = LatLng(defaultAddress.lat, defaultAddress.lng);
      } else {
        // استخدام دمشق كبديل افتراضي
        initialCenter = const LatLng(33.5138, 36.2765);
      }

      return Container(
        height: 0.5 * h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor().primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: 13.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  onTap: (tapPosition, point) {
                    // عند النقر على الخريطة، تحديث الموقع
                    controller.setLocation(point.latitude, point.longitude);
                  },
                ),
                children: [
                  // طبقة الخريطة من CartoDB (بديل مجاني لـ OpenStreetMap)
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                    userAgentPackageName: 'app',
                    maxZoom: 19,
                    subdomains: const ['a', 'b', 'c', 'd'],
                    additionalOptions: const {'User-Agent': 'ShbeekLbeek/1.0'},
                  ),
                  // طبقة العلامة (Marker)
                  if (selectedLat != 0.0 && selectedLng != 0.0)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(selectedLat, selectedLng),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: AppColor().primaryColor,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // زر للحصول على الموقع الحالي
              Positioned(
                bottom: 8,
                left: 8,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColor().primaryColor,
                  onPressed: () async {
                    await controller.getCurrentLocation();
                  },
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
