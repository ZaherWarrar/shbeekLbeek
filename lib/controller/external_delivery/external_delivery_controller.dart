import 'package:app/controller/wallet/wallet_payment_mixin.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/external_orders_data.dart';
import 'package:app/data/datasource/remot/routing_data.dart';
import 'package:app/view/external_delivery/widgets/external_delivery_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PickMode { from, to }

class ExternalDeliveryController extends GetxController
    with WalletPaymentMixin {
  final RoutingData _routingData = RoutingData();
  final ExternalOrdersData _externalOrdersData =
      ExternalOrdersData(Get.find<Crud>());
  final SessionService _session = Get.find<SessionService>();

  final pickMode = PickMode.from.obs;

  final fromLat = 0.0.obs;
  final fromLng = 0.0.obs;
  final toLat = 0.0.obs;
  final toLng = 0.0.obs;

  final isLoadingLocation = false.obs;
  final isSubmitting = false.obs;

  final mapCenterLat = defaultLat.obs;
  final mapCenterLng = defaultLng.obs;
  bool _mapCenterInitialized = false;

  final routePoints = <LatLng>[].obs;
  final routeDistanceKm = 0.0.obs;
  final routeDurationMin = 0.0.obs;
  final isLoadingRoute = false.obs;

  final fromPlaceLabel = ''.obs;
  final toPlaceLabel = ''.obs;

  final fromDetailsController = TextEditingController();
  final toDetailsController = TextEditingController();
  final orderDetailsController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  static const double defaultLat = 33.5138;
  static const double defaultLng = 36.2765;

  bool get hasFromPoint => fromLat.value != 0.0 && fromLng.value != 0.0;
  bool get hasToPoint => toLat.value != 0.0 && toLng.value != 0.0;
  bool get hasRoute => routePoints.isNotEmpty;

  double? get searchOriginLat {
    if (pickMode.value == PickMode.to && hasFromPoint) return fromLat.value;
    if (pickMode.value == PickMode.from && hasToPoint) return toLat.value;
    if (mapCenterLat.value != 0.0) return mapCenterLat.value;
    return null;
  }

  double? get searchOriginLng {
    if (pickMode.value == PickMode.to && hasFromPoint) return fromLng.value;
    if (pickMode.value == PickMode.from && hasToPoint) return toLng.value;
    if (mapCenterLng.value != 0.0) return mapCenterLng.value;
    return null;
  }

  double? get activeInitialLat {
    if (pickMode.value == PickMode.from) {
      return hasFromPoint ? fromLat.value : mapCenterLat.value;
    }
    return hasToPoint ? toLat.value : mapCenterLat.value;
  }

  double? get activeInitialLng {
    if (pickMode.value == PickMode.from) {
      return hasFromPoint ? fromLng.value : mapCenterLng.value;
    }
    return hasToPoint ? toLng.value : mapCenterLng.value;
  }

  @override
  void onInit() {
    super.onInit();
    centerMapOnUserLocation();
    fetchWalletBalance();
  }

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

  void setPoint(double lat, double lng, {String? placeLabel}) {
    if (pickMode.value == PickMode.from) {
      fromLat.value = lat;
      fromLng.value = lng;
      if (placeLabel != null) {
        fromPlaceLabel.value = placeLabel;
      }
    } else {
      toLat.value = lat;
      toLng.value = lng;
      if (placeLabel != null) {
        toPlaceLabel.value = placeLabel;
      }
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
        routePoints.assignAll(
          result.points.map(
            (point) => LatLng(point.latitude, point.longitude),
          ),
        );
        routeDistanceKm.value = result.distanceKm;
        routeDurationMin.value = result.durationMinutes;
      } else {
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

  Future<void> validateAndSubmit() async {
    if (isSubmitting.value) return;

    if (!(formKey.currentState?.validate() ?? false)) return;

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

    final token = _session.token;
    if (token == null || token.isEmpty || _session.isGuest) {
      Get.snackbar('تنبيه', 'يجب تسجيل الدخول لإنشاء طلب توصيل خارجي');
      Get.toNamed(AppRoutes.login);
      return;
    }

    isSubmitting.value = true;
    try {
      final payload = {
        'from_lat': fromLat.value,
        'from_lng': fromLng.value,
        'from_address_details': fromDetailsController.text.trim(),
        'to_lat': toLat.value,
        'to_lng': toLng.value,
        'to_address_details': toDetailsController.text.trim(),
        'order_details': orderDetailsController.text.trim(),
        'payment_method': paymentMethod,
      };

      final response = await _externalOrdersData.createExternalOrder(payload);
      final status = handlingData(response);

      if (status != StatusRequest.success || response is! Map) {
        _showSubmitError(response is StatusRequest ? response : status);
        return;
      }

      _resetForm();
      await ExternalDeliverySuccessDialog.show();
    } catch (_) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء الطلب');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showSubmitError(StatusRequest status) {
    switch (status) {
      case StatusRequest.unauthorized:
        Get.snackbar('تنبيه', 'يجب تسجيل الدخول لإنشاء طلب توصيل خارجي');
        Get.toNamed(AppRoutes.login);
        break;
      case StatusRequest.offlinefailure:
        Get.snackbar('خطأ', 'لا يوجد اتصال بالإنترنت');
        break;
      case StatusRequest.serverfailure:
      case StatusRequest.serverException:
        Get.snackbar('خطأ', 'خطأ في الخادم، حاول لاحقاً');
        break;
      default:
        Get.snackbar('خطأ', 'فشل في إنشاء الطلب');
    }
  }

  void _resetForm() {
    fromLat.value = 0.0;
    fromLng.value = 0.0;
    toLat.value = 0.0;
    toLng.value = 0.0;
    routePoints.clear();
    routeDistanceKm.value = 0.0;
    routeDurationMin.value = 0.0;
    fromPlaceLabel.value = '';
    toPlaceLabel.value = '';
    pickMode.value = PickMode.from;
    resetWalletPayment();
    fromDetailsController.clear();
    toDetailsController.clear();
    orderDetailsController.clear();
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    fromDetailsController.dispose();
    toDetailsController.dispose();
    orderDetailsController.dispose();
    super.onClose();
  }
}
