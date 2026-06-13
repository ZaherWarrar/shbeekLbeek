import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/map/labeled_map_layers.dart';
import 'package:app/view/external_delivery/widgets/pick_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ExternalDeliveryMap extends StatefulWidget {
  const ExternalDeliveryMap({super.key});

  @override
  State<ExternalDeliveryMap> createState() => _ExternalDeliveryMapState();
}

class _ExternalDeliveryMapState extends State<ExternalDeliveryMap> {
  final MapController _mapController = MapController();
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
      ever(_controller.pickMode, (_) => _updateMapView()),
      ever(_controller.routePoints, (_) => _updateMapView()),
      ever(_controller.mapCenterLat, (_) => _updateMapView()),
      ever(_controller.mapCenterLng, (_) => _updateMapView()),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.centerMapOnUserLocation();
    });
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
    if (!mounted) return;
    final target = _viewCenter();
    if (target == null) return;
    try {
      _mapController.move(target, 16);
    } catch (_) {}
  }

  LatLng? _viewCenter() {
    final point = _activePoint();
    if (point != null) return point;
    return LatLng(
      _controller.mapCenterLat.value,
      _controller.mapCenterLng.value,
    );
  }

  void _fitRouteBounds() {
    final points = _controller.routePoints.toList();
    if (points.length < 2) return;
    try {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(48),
        ),
      );
    } catch (_) {
      _maybeMoveMap();
    }
  }

  LatLng? _activePoint() {
    if (_controller.pickMode.value == PickMode.from && _controller.hasFromPoint) {
      return LatLng(_controller.fromLat.value, _controller.fromLng.value);
    }
    if (_controller.pickMode.value == PickMode.to && _controller.hasToPoint) {
      return LatLng(_controller.toLat.value, _controller.toLng.value);
    }
    if (_controller.hasFromPoint) {
      return LatLng(_controller.fromLat.value, _controller.fromLng.value);
    }
    if (_controller.hasToPoint) {
      return LatLng(_controller.toLat.value, _controller.toLng.value);
    }
    return null;
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
    _mapController.dispose();
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
      final isLoading = _controller.isLoadingLocation.value;

      final markers = <Marker>[];
      if (hasFrom) {
        markers.add(
          Marker(
            point: LatLng(fromLat, fromLng),
            width: 40,
            height: 40,
            child: Icon(
              Icons.trip_origin,
              color: Colors.green.shade700,
              size: 36,
            ),
          ),
        );
      }
      if (hasTo) {
        markers.add(
          Marker(
            point: LatLng(toLat, toLng),
            width: 40,
            height: 40,
            child: Icon(
              Icons.location_on,
              color: AppColor().primaryColor,
              size: 40,
            ),
          ),
        );
      }

      final routePoints = _controller.routePoints.toList();
      final polylines = <Polyline>[];
      if (routePoints.length >= 2) {
        polylines.add(
          Polyline(
            points: routePoints,
            color: AppColor().primaryColor,
            strokeWidth: 4,
          ),
        );
      } else if (hasFrom && hasTo) {
        polylines.add(
          Polyline(
            points: [LatLng(fromLat, fromLng), LatLng(toLat, toLng)],
            color: AppColor().primaryColor,
            strokeWidth: 3,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PickModeSelector(),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
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
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _initialCenter(),
                        initialZoom: 15,
                        minZoom: 5,
                        maxZoom: 19,
                        onTap: (_, point) {
                          _controller.setPoint(
                            point.latitude,
                            point.longitude,
                          );
                        },
                      ),
                      children: [
                        ...LabeledMapLayers.all(),
                        if (polylines.isNotEmpty)
                          PolylineLayer(polylines: polylines),
                        if (markers.isNotEmpty) MarkerLayer(markers: markers),
                      ],
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: AppColor().primaryColor,
                        onPressed: isLoading
                            ? null
                            : _controller.getCurrentLocationForActivePoint,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
