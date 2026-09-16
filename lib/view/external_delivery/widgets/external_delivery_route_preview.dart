import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExternalDeliveryRoutePreview extends StatefulWidget {
  const ExternalDeliveryRoutePreview({super.key});

  @override
  State<ExternalDeliveryRoutePreview> createState() =>
      _ExternalDeliveryRoutePreviewState();
}

class _ExternalDeliveryRoutePreviewState
    extends State<ExternalDeliveryRoutePreview> {
  GoogleMapController? _mapController;
  late final ExternalDeliveryController _controller;
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ExternalDeliveryController>();
    _workers.addAll([
      ever(_controller.fromLat, (_) => _updateMapView()),
      ever(_controller.fromLng, (_) => _updateMapView()),
      ever(_controller.toLat, (_) => _updateMapView()),
      ever(_controller.toLng, (_) => _updateMapView()),
      ever(_controller.routePoints, (_) => _updateMapView()),
    ]);
  }

  void _updateMapView() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_controller.routePoints.length >= 2) {
        _fitRouteBounds();
        return;
      }
      _maybeMoveMap();
    });
  }

  void _maybeMoveMap() {
    final target = _viewCenter();
    if (target == null) return;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(target, 15),
    );
  }

  LatLng? _viewCenter() {
    if (_controller.hasFromPoint) {
      return LatLng(_controller.fromLat.value, _controller.fromLng.value);
    }
    if (_controller.hasToPoint) {
      return LatLng(_controller.toLat.value, _controller.toLng.value);
    }
    return LatLng(
      _controller.mapCenterLat.value,
      _controller.mapCenterLng.value,
    );
  }

  void _fitRouteBounds() {
    final points = _controller.routePoints.toList();
    if (points.length < 2) return;

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 48),
    );
  }

  LatLng _initialCenter() {
    return _viewCenter() ??
        const LatLng(
          ExternalDeliveryController.defaultLat,
          ExternalDeliveryController.defaultLng,
        );
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fromLat = _controller.fromLat.value;
      final fromLng = _controller.fromLng.value;
      final toLat = _controller.toLat.value;
      final toLng = _controller.toLng.value;
      final hasFrom = _controller.hasFromPoint;
      final hasTo = _controller.hasToPoint;
      final hasAnyPoint = hasFrom || hasTo;

      if (!hasAnyPoint) {
        return const SizedBox.shrink();
      }

      final markers = <Marker>{};
      if (hasFrom) {
        markers.add(
          Marker(
            markerId: const MarkerId('from'),
            position: LatLng(fromLat, fromLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      }
      if (hasTo) {
        markers.add(
          Marker(
            markerId: const MarkerId('to'),
            position: LatLng(toLat, toLng),
          ),
        );
      }

      final routePoints = _controller.routePoints.toList();
      final polylines = <Polyline>{};
      if (routePoints.length >= 2) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: AppColor().primaryColor,
            width: 4,
          ),
        );
      } else if (hasFrom && hasTo) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('direct'),
            points: [
              LatLng(fromLat, fromLng),
              LatLng(toLat, toLng),
            ],
            color: AppColor().primaryColor,
            width: 3,
          ),
        );
      }

      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor().primaryColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialCenter(),
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: markers,
            polylines: polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
          ),
        ),
      );
    });
  }
}
