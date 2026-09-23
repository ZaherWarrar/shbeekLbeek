import 'dart:convert';

import 'package:app/core/constant/google_maps_config.dart';
import 'package:app/core/services/places_sdk_service.dart';
import 'package:app/data/datasource/model/place_prediction.dart';
import 'package:flutter_google_places_sdk_platform_interface/flutter_google_places_sdk_platform_interface.dart'
    as places_sdk;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PlacesSearchResult {
  const PlacesSearchResult({
    required this.predictions,
    this.errorMessage,
  });

  final List<PlacePrediction> predictions;
  final String? errorMessage;
}

class PlacesData {
  static const int _maxResults = 8;
  static const String _userAgent = 'ShbeekLbeek/1.0';

  final PlacesSdkService _sdk = PlacesSdkService.instance;

  Future<PlacesSearchResult> autocomplete(
    String input, {
    double? originLat,
    double? originLng,
  }) async {
    final query = input.trim();
    if (query.length < 2) {
      return const PlacesSearchResult(predictions: []);
    }

    final origin = _origin(originLat, originLng);

    try {
      final sdkPredictions = await _searchWithSdk(query, origin);
      if (sdkPredictions.isNotEmpty) {
        return PlacesSearchResult(predictions: sdkPredictions);
      }
    } catch (_) {
      // نكمل للاحتياطي OSM
    }

    final osmResults = await _searchOsm(query, originLat, originLng);
    if (osmResults.isNotEmpty) {
      return PlacesSearchResult(
        predictions: _sortByDistance(osmResults, originLat, originLng),
      );
    }

    return const PlacesSearchResult(
      predictions: [],
      errorMessage: 'لم يتم العثور على نتائج، جرّب اسماً أوضح',
    );
  }

  Future<PlaceDetails?> resolvePlace(PlacePrediction prediction) async {
    if (prediction.hasCoordinates) {
      return PlaceDetails(
        latitude: prediction.latitude!,
        longitude: prediction.longitude!,
        formattedAddress: prediction.description,
      );
    }

    if (!prediction.isGooglePlace) return null;

    try {
      final place = await _sdk.fetchPlace(prediction.placeId);
      final latLng = place?.latLng;
      if (latLng == null) return null;

      return PlaceDetails(
        latitude: latLng.lat,
        longitude: latLng.lng,
        formattedAddress:
            place?.address ?? place?.name ?? prediction.description,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<PlacePrediction>> _searchWithSdk(
    String query,
    places_sdk.LatLng? origin,
  ) async {
    final autocomplete = await _sdk.autocomplete(query, origin: origin);
    final predictions = autocomplete.predictions
        .map(_mapSdkAutocomplete)
        .whereType<PlacePrediction>()
        .toList();

    if (predictions.isNotEmpty) {
      return _sortSdkPredictions(predictions);
    }

    final bias = origin == null
        ? null
        : _sdk.boundsAround(origin.lat, origin.lng);
    final textSearch = await _sdk.searchByText(
      query,
      locationBias: bias,
      rankPreference: places_sdk.TextSearchRankPreference.Distance,
    );

    return textSearch.places
        .map(_mapSdkPlace)
        .whereType<PlacePrediction>()
        .take(_maxResults)
        .toList();
  }

  PlacePrediction? _mapSdkAutocomplete(
    places_sdk.AutocompletePrediction item,
  ) {
    return PlacePrediction(
      placeId: item.placeId,
      description: item.fullText,
      mainText: item.primaryText,
      secondaryText: item.secondaryText,
      category: _categoryFromSdkTypes(item.placeTypes),
      isGooglePlace: true,
      distanceMeters: item.distanceMeters?.toDouble(),
    );
  }

  PlacePrediction? _mapSdkPlace(places_sdk.Place place) {
    final placeId = place.id;
    if (placeId == null || placeId.isEmpty) return null;

    final latLng = place.latLng;
    return PlacePrediction(
      placeId: placeId,
      description: place.address ?? place.name ?? placeId,
      mainText: place.name ?? place.address ?? '',
      secondaryText: place.address ?? '',
      latitude: latLng?.lat,
      longitude: latLng?.lng,
      category: _categoryFromSdkTypes(place.types),
      isGooglePlace: true,
    );
  }

  places_sdk.LatLng? _origin(double? lat, double? lng) {
    if (lat == null || lng == null || lat == 0 || lng == 0) return null;
    return places_sdk.LatLng(lat: lat, lng: lng);
  }

  List<PlacePrediction> _sortSdkPredictions(List<PlacePrediction> items) {
    final sorted = List<PlacePrediction>.from(items);
    sorted.sort((a, b) {
      final aDistance = a.distanceMeters;
      final bDistance = b.distanceMeters;
      if (aDistance != null && bDistance != null) {
        return aDistance.compareTo(bDistance);
      }
      if (aDistance != null) return -1;
      if (bDistance != null) return 1;
      return 0;
    });
    return sorted.take(_maxResults).toList();
  }

  PlaceCategory _categoryFromSdkTypes(List<places_sdk.PlaceType>? types) {
    if (types == null || types.isEmpty) return PlaceCategory.other;

    final names = types.map((t) => t.name).join(' ').toUpperCase();
    if (names.contains('RESTAURANT') ||
        names.contains('CAFE') ||
        names.contains('FOOD') ||
        names.contains('BAKERY')) {
      return PlaceCategory.restaurant;
    }
    if (names.contains('PHARMACY') || names.contains('DRUGSTORE')) {
      return PlaceCategory.pharmacy;
    }
    if (names.contains('MOSQUE') ||
        names.contains('PLACE_OF_WORSHIP') ||
        names.contains('HINDU_TEMPLE') ||
        names.contains('CHURCH')) {
      return PlaceCategory.mosque;
    }
    if (names.contains('HOSPITAL') ||
        names.contains('DOCTOR') ||
        names.contains('DENTIST')) {
      return PlaceCategory.hospital;
    }
    if (names.contains('STORE') ||
        names.contains('SUPERMARKET') ||
        names.contains('SHOPPING')) {
      return PlaceCategory.store;
    }
    if (names.contains('LOCALITY') ||
        names.contains('NEIGHBORHOOD') ||
        names.contains('ROUTE') ||
        names.contains('STREET')) {
      return PlaceCategory.area;
    }
    return PlaceCategory.other;
  }

  Future<List<PlacePrediction>> _searchOsm(
    String query,
    double? originLat,
    double? originLng,
  ) async {
    final params = <String, String>{
      'q': '$query, Syria',
      'format': 'json',
      'addressdetails': '1',
      'extratags': '1',
      'namedetails': '1',
      'limit': '$_maxResults',
      'countrycodes': GoogleMapsConfig.countryCode,
      'accept-language': GoogleMapsConfig.language,
    };
    if (originLat != null && originLng != null) {
      params['lat'] = originLat.toString();
      params['lon'] = originLng.toString();
    }

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', params);

    try {
      final response = await http.get(
        uri,
        headers: const {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) return [];

      final results = jsonDecode(response.body) as List<dynamic>;
      return results
          .map((item) => _mapOsmResult(item as Map<String, dynamic>))
          .whereType<PlacePrediction>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  PlacePrediction? _mapOsmResult(Map<String, dynamic> item) {
    final lat = double.tryParse(item['lat']?.toString() ?? '');
    final lng = double.tryParse(item['lon']?.toString() ?? '');
    if (lat == null || lng == null) return null;

    final displayName = item['display_name']?.toString() ?? '';
    final name = item['name']?.toString();
    final type = item['type']?.toString() ?? '';
    final category = item['category']?.toString() ?? '';
    final extratags = item['extratags'] as Map<String, dynamic>? ?? {};
    final amenity = extratags['amenity']?.toString() ?? type;

    final mainText = name?.isNotEmpty == true
        ? name!
        : displayName.split(',').first.trim();

    return PlacePrediction(
      placeId: 'osm-$lat-$lng',
      description: displayName,
      mainText: mainText,
      secondaryText: _osmSecondaryLine(item['address'] as Map<String, dynamic>?),
      latitude: lat,
      longitude: lng,
      category: _categoryFromOsm(amenity, category, type, displayName),
    );
  }

  PlaceCategory _categoryFromOsm(
    String amenity,
    String category,
    String type,
    String displayName,
  ) {
    final value = '$amenity $category $type $displayName'.toLowerCase();
    if (value.contains('restaurant') ||
        value.contains('cafe') ||
        value.contains('مطعم')) {
      return PlaceCategory.restaurant;
    }
    if (value.contains('pharmacy') ||
        value.contains('chemist') ||
        value.contains('صيدل')) {
      return PlaceCategory.pharmacy;
    }
    if (value.contains('mosque') ||
        value.contains('place_of_worship') ||
        value.contains('مسجد')) {
      return PlaceCategory.mosque;
    }
    if (value.contains('hospital') ||
        value.contains('clinic') ||
        value.contains('مستشف')) {
      return PlaceCategory.hospital;
    }
    if (value.contains('supermarket') ||
        value.contains('shop') ||
        value.contains('store')) {
      return PlaceCategory.store;
    }
    if (category == 'place' || type == 'administrative') {
      return PlaceCategory.area;
    }
    return PlaceCategory.other;
  }

  String _osmSecondaryLine(Map<String, dynamic>? address) {
    if (address == null) return '';
    final parts = <String>[
      if (address['suburb']?.toString().trim().isNotEmpty == true)
        address['suburb'].toString().trim(),
      if (address['city']?.toString().trim().isNotEmpty == true)
        address['city'].toString().trim(),
      if (address['state']?.toString().trim().isNotEmpty == true)
        address['state'].toString().trim(),
    ];
    return parts.join('، ');
  }

  List<PlacePrediction> _sortByDistance(
    List<PlacePrediction> predictions,
    double? originLat,
    double? originLng,
  ) {
    if (originLat == null || originLng == null) return predictions;

    final withDistance = predictions.map((item) {
      if (!item.hasCoordinates) return item;
      final distance = Geolocator.distanceBetween(
        originLat,
        originLng,
        item.latitude!,
        item.longitude!,
      );
      return item.copyWith(distanceMeters: distance);
    }).toList();

    withDistance.sort((a, b) {
      final aDistance = a.distanceMeters;
      final bDistance = b.distanceMeters;
      if (aDistance == null && bDistance == null) return 0;
      if (aDistance == null) return 1;
      if (bDistance == null) return -1;
      return aDistance.compareTo(bDistance);
    });

    return withDistance;
  }
}
