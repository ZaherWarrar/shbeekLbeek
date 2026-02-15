import 'package:app/core/constant/app_color.dart';
import 'package:app/main.dart';
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPickerWidget extends StatefulWidget {
  const MapPickerWidget({super.key});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  final MapController mapController = MapController();
  final AddressController addressController = Get.find<AddressController>();
  Worker? _latWorker;
  Worker? _lngWorker;

  @override
  void initState() {
    super.initState();
    // الاستماع لتغييرات الموقع لتحريك الخريطة
    _latWorker = ever(addressController.selectedLat, (lat) {
      if (mounted && lat != 0.0 && addressController.selectedLng.value != 0.0) {
        _moveToLocation(lat, addressController.selectedLng.value);
      }
    });
    _lngWorker = ever(addressController.selectedLng, (lng) {
      if (mounted && lng != 0.0 && addressController.selectedLat.value != 0.0) {
        _moveToLocation(addressController.selectedLat.value, lng);
      }
    });
  }

  // تحريك الخريطة إلى موقع معين
  void _moveToLocation(double lat, double lng) {
    if (!mounted) return;
    
    try {
      mapController.move(
        LatLng(lat, lng),
        15.0, // مستوى التكبير
      );
    } catch (e) {
      // تجاهل الأخطاء إذا كان الـ controller تم dispose
      // أو إذا كان هناك خطأ في تحريك الخريطة
    }
  }

  @override
  void dispose() {
    // إلغاء الاشتراكات
    _latWorker?.dispose();
    _lngWorker?.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedLat = addressController.selectedLat.value;
      final selectedLng = addressController.selectedLng.value;

      // البحث عن العنوان الافتراضي
      AddressModel? defaultAddress;
      try {
        defaultAddress = addressController.addresses.firstWhere(
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
            // ignore: deprecated_member_use
            color: AppColor().primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: 13.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  onTap: (tapPosition, point) async {
                    // عند النقر على الخريطة، تحديث الموقع والحصول على العنوان
                    await addressController.setLocation(
                      point.latitude,
                      point.longitude,
                    );
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
                    await addressController.getCurrentLocation();
                    // الخريطة ستتحرك تلقائياً عبر ever listener
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
