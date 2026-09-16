import 'dart:async';

import 'package:app/controller/address/address_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/place_prediction.dart';
import 'package:app/data/datasource/remot/places_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef PlaceSelectedCallback = Future<void> Function(
  double lat,
  double lng,
  PlacePrediction prediction,
);

class PlaceSearchField extends StatefulWidget {
  const PlaceSearchField({
    super.key,
    this.hintText,
    this.originLat,
    this.originLng,
    this.onPlaceSelected,
    this.searchKey,
  });

  final String? hintText;
  final double? originLat;
  final double? originLng;
  final PlaceSelectedCallback? onPlaceSelected;
  final Object? searchKey;

  @override
  State<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends State<PlaceSearchField> {
  final TextEditingController _searchController = TextEditingController();
  final PlacesData _placesData = PlacesData();

  Timer? _debounce;
  List<PlacePrediction> _predictions = [];
  bool _isSearching = false;
  bool _isSelecting = false;

  AddressController? get _addressController {
    if (widget.onPlaceSelected != null) return null;
    if (!Get.isRegistered<AddressController>()) return null;
    return Get.find<AddressController>();
  }

  @override
  void didUpdateWidget(covariant PlaceSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchKey != widget.searchKey) {
      _searchController.clear();
      _predictions = [];
      _debounce?.cancel();
      _isSearching = false;
      _isSelecting = false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  double? _resolveOriginLat() {
    if (widget.originLat != null && widget.originLat != 0.0) {
      return widget.originLat;
    }
    final controller = _addressController;
    if (controller == null) return null;
    final lat = controller.selectedLat.value;
    return lat != 0.0 ? lat : null;
  }

  double? _resolveOriginLng() {
    if (widget.originLng != null && widget.originLng != 0.0) {
      return widget.originLng;
    }
    final controller = _addressController;
    if (controller == null) return null;
    final lng = controller.selectedLng.value;
    return lng != 0.0 ? lng : null;
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      if (!mounted) return;
      if (value.trim().length < 2) {
        setState(() {
          _predictions = [];
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);

      final result = await _placesData.autocomplete(
        value,
        originLat: _resolveOriginLat(),
        originLng: _resolveOriginLng(),
      );
      if (!mounted) return;

      if (result.errorMessage != null && result.predictions.isEmpty) {
        Get.snackbar('تنبيه', result.errorMessage!);
      }

      setState(() {
        _predictions = result.predictions;
        _isSearching = false;
      });
    });
  }

  Future<void> _selectPrediction(PlacePrediction prediction) async {
    if (_isSelecting) return;
    setState(() {
      _isSelecting = true;
      _predictions = [];
    });

    _searchController.text = prediction.description;
    FocusScope.of(context).unfocus();

    try {
      final details = await _placesData.resolvePlace(prediction);
      if (details == null) {
        Get.snackbar('تنبيه', 'تعذر الحصول على موقع المكان');
        return;
      }

      if (widget.onPlaceSelected != null) {
        await widget.onPlaceSelected!(
          details.latitude,
          details.longitude,
          prediction,
        );
      } else {
        final controller = _addressController;
        if (controller == null) return;
        await controller.setLocation(details.latitude, details.longitude);
      }
    } finally {
      if (mounted) {
        setState(() => _isSelecting = false);
      }
    }
  }

  IconData _iconForCategory(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.restaurant:
        return Icons.restaurant;
      case PlaceCategory.pharmacy:
        return Icons.local_pharmacy;
      case PlaceCategory.mosque:
        return Icons.mosque;
      case PlaceCategory.hospital:
        return Icons.local_hospital;
      case PlaceCategory.store:
        return Icons.storefront;
      case PlaceCategory.area:
        return Icons.location_city;
      case PlaceCategory.other:
        return Icons.place_outlined;
    }
  }

  String _formatDistance(double? meters) {
    if (meters == null) return '';
    if (meters < 1000) {
      return '${meters.round()} م';
    }
    return '${(meters / 1000).toStringAsFixed(1)} كم';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'ابحث عن مطعم، صيدلية، مسجد، منطقة...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearching || _isSelecting
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _predictions = []);
                        },
                      )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor().titleColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor().titleColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor().primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        if (_predictions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Material(
            color: Colors.white,
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _predictions.length,
              separatorBuilder: (_, index) => const Divider(
                height: 1,
                color: Color(0xFFEEEEEE),
              ),
              itemBuilder: (context, index) {
                final item = _predictions[index];
                final distanceText = _formatDistance(item.distanceMeters);
                return ListTile(
                  tileColor: Colors.white,
                  leading: Icon(
                    _iconForCategory(item.category),
                    color: AppColor().primaryColor,
                  ),
                  title: Text(
                    item.mainText.isNotEmpty
                        ? item.mainText
                        : item.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: item.secondaryText.isNotEmpty
                      ? Text(item.secondaryText)
                      : Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                  trailing: distanceText.isNotEmpty
                      ? Text(
                          distanceText,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                  onTap: () => _selectPrediction(item),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
