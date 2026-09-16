import 'package:app/controller/address/address_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef MapPickerConfirmCallback = Future<void> Function(double lat, double lng);

class FullScreenMapPickerPage extends StatefulWidget {
  const FullScreenMapPickerPage({
    super.key,
    this.initialLat,
    this.initialLng,
    this.openAtCurrentLocation = false,
    this.onConfirm,
    this.confirmButtonLabel = 'تأكيد الموقع',
    this.instructionText = 'حرّك الخريطة حتى يكون الدبوس على موقعك بدقة',
  });

  final double? initialLat;
  final double? initialLng;
  final bool openAtCurrentLocation;
  final MapPickerConfirmCallback? onConfirm;
  final String confirmButtonLabel;
  final String instructionText;

  @override
  State<FullScreenMapPickerPage> createState() =>
      _FullScreenMapPickerPageState();
}

class _FullScreenMapPickerPageState extends State<FullScreenMapPickerPage> {
  static const LatLng _defaultCenter = LatLng(33.5138, 36.2765);

  GoogleMapController? _mapController;
  LatLng _mapCenter = _defaultCenter;
  bool _isLoadingLocation = false;
  bool _isConfirming = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _mapCenter = _resolveInitialCenter();
    if (widget.openAtCurrentLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveToCurrentLocation();
      });
    }
  }

  LatLng _resolveInitialCenter() {
    final lat = widget.initialLat;
    final lng = widget.initialLng;
    if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
      return LatLng(lat, lng);
    }
    return _defaultCenter;
  }

  Future<void> _moveToCurrentLocation() async {
    if (_isLoadingLocation) return;
    setState(() => _isLoadingLocation = true);

    try {
      LatLng? target;

      if (widget.onConfirm != null) {
        target = await _resolveCurrentLocationLatLng();
      } else if (Get.isRegistered<AddressController>()) {
        final controller = Get.find<AddressController>();
        final success = await controller.centerOnCurrentLocationForMap();
        if (success &&
            controller.selectedLat.value != 0.0 &&
            controller.selectedLng.value != 0.0) {
          target = LatLng(
            controller.selectedLat.value,
            controller.selectedLng.value,
          );
        }
      }

      if (!mounted || target == null) return;

      setState(() => _mapCenter = target!);
      if (_mapReady) {
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(target, 16),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<LatLng?> _resolveCurrentLocationLatLng() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('تنبيه', 'يرجى تفعيل خدمة الموقع');
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('تنبيه', 'تم رفض إذن الموقع');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('تنبيه', 'إذن الموقع مرفوض بشكل دائم');
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      Get.snackbar('تنبيه', 'تعذر الحصول على الموقع الحالي');
      return null;
    }
  }

  Future<void> _confirmLocation() async {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);

    try {
      if (widget.onConfirm != null) {
        await widget.onConfirm!(
          _mapCenter.latitude,
          _mapCenter.longitude,
        );
      } else {
        final controller = Get.find<AddressController>();
        await controller.setLocation(
          _mapCenter.latitude,
          _mapCenter.longitude,
        );
      }
      if (!mounted) return;
      Get.back(result: true);
    } finally {
      if (mounted) {
        setState(() => _isConfirming = false);
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _mapCenter,
              zoom: 16,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapReady = true;
            },
            onCameraMove: (position) {
              _mapCenter = position.target;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: Icon(
                Icons.location_on,
                size: 48,
                color: Colors.red,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed:
                          _isLoadingLocation ? null : _moveToCurrentLocation,
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.instructionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor().primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isConfirming ? null : _confirmLocation,
                      child: _isConfirming
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.confirmButtonLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
