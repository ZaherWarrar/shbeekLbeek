import 'package:app/data/datasource/remot/routing_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

enum PickMode { from, to }

class ExternalDeliveryController extends GetxController {
  final RoutingData _routingData = RoutingData();

  final pickMode = PickMode.from.obs;

  final fromLat = 0.0.obs;
  final fromLng = 0.0.obs;
  final toLat = 0.0.obs;
  final toLng = 0.0.obs;

  final isLoadingLocation = false.obs;

  final mapCenterLat = defaultLat.obs;
  final mapCenterLng = defaultLng.obs;
  bool _mapCenterInitialized = false;

  final routePoints = <LatLng>[].obs;
  final routeDistanceKm = 0.0.obs;
  final routeDurationMin = 0.0.obs;
  final isLoadingRoute = false.obs;

  final fromDetailsController = TextEditingController();
  final toDetailsController = TextEditingController();
  final orderDetailsController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  static const double defaultLat = 33.5138;
  static const double defaultLng = 36.2765;

  bool get hasFromPoint => fromLat.value != 0.0 && fromLng.value != 0.0;
  bool get hasToPoint => toLat.value != 0.0 && toLng.value != 0.0;
  bool get hasRoute => routePoints.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    centerMapOnUserLocation();
  }

  /// يمرّر الخريطة على موقع المستخدم عند فتح الصفحة (بدون تعيين من/إلى).
  Future<void> centerMapOnUserLocation() async {
    if (_mapCenterInitialized) return;
    isLoadingLocation.value = true;
    try {
      final position = await _resolveCurrentPosition();
      if (position != null) {
        mapCenterLat.value = position.latitude;
        mapCenterLng.value = position.longitude;
        _mapCenterInitialized = true;
      }
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<Position?> _resolveCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  void setPickMode(PickMode mode) {
    pickMode.value = mode;
  }

  void setPoint(double lat, double lng) {
    if (pickMode.value == PickMode.from) {
      fromLat.value = lat;
      fromLng.value = lng;
    } else {
      toLat.value = lat;
      toLng.value = lng;
    }
    _refreshRoute();
  }

  Future<void> _refreshRoute() async {
    if (!hasFromPoint || !hasToPoint) {
      routePoints.clear();
      routeDistanceKm.value = 0.0;
      routeDurationMin.value = 0.0;
      return;
    }

    isLoadingRoute.value = true;
    try {
      final result = await _routingData.getRoute(
        fromLat: fromLat.value,
        fromLng: fromLng.value,
        toLat: toLat.value,
        toLng: toLng.value,
      );

      if (result != null && result.points.isNotEmpty) {
        routePoints.assignAll(result.points);
        routeDistanceKm.value = result.distanceKm;
        routeDurationMin.value = result.durationMinutes;
      } else {
        // تعذّر جلب المسار → خط مستقيم كحل بديل
        routePoints.assignAll([
          LatLng(fromLat.value, fromLng.value),
          LatLng(toLat.value, toLng.value),
        ]);
        routeDistanceKm.value = 0.0;
        routeDurationMin.value = 0.0;
      }
    } finally {
      isLoadingRoute.value = false;
    }
  }

  Future<void> getCurrentLocationForActivePoint() async {
    isLoadingLocation.value = true;
    try {
      final position = await _resolveCurrentPosition();
      if (position == null) {
        Get.snackbar('تنبيه', 'تعذر الحصول على الموقع الحالي');
        return;
      }
      mapCenterLat.value = position.latitude;
      mapCenterLng.value = position.longitude;
      setPoint(position.latitude, position.longitude);
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void validateAndSubmit() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (!hasFromPoint) {
      Get.snackbar('تنبيه', 'الرجاء تحديد موقع الانطلاق على الخريطة');
      return;
    }
    if (!hasToPoint) {
      Get.snackbar('تنبيه', 'الرجاء تحديد موقع الوصول على الخريطة');
      return;
    }
    if (fromDetailsController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال تفاصيل موقع الانطلاق');
      return;
    }
    if (toDetailsController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال تفاصيل موقع الوصول');
      return;
    }
    if (orderDetailsController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال تفاصيل الطلب');
      return;
    }

    Get.snackbar(
      'نجاح',
      'تم تجهيز طلب التوصيل',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    fromDetailsController.dispose();
    toDetailsController.dispose();
    orderDetailsController.dispose();
    super.onClose();
  }
}
