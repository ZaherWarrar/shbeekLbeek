import 'package:app/core/constant/google_maps_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk_platform_interface/flutter_google_places_sdk_platform_interface.dart';

/// غلاف رفيع فوق Google Places SDK الأصلي (بدون الحزمة الرئيسية المعطوبة).
class PlacesSdkService {
  PlacesSdkService._();

  static final PlacesSdkService instance = PlacesSdkService._();

  final FlutterGooglePlacesSdkPlatform _platform =
      FlutterGooglePlacesSdkPlatform.instance;

  Future<void>? _initialization;

  Future<void> ensureInitialized() async {
    if (_initialization != null) {
      await _initialization;
      return;
    }

    final init = _platform.initialize(
      GoogleMapsConfig.apiKey,
      locale: const Locale('ar'),
    );
    _initialization = init;
    try {
      await init;
    } catch (error) {
      _initialization = null;
      rethrow;
    }
  }

  Future<FindAutocompletePredictionsResponse> autocomplete(
    String query, {
    LatLng? origin,
  }) async {
    await ensureInitialized();
    return _platform.findAutocompletePredictions(
      query,
      countries: [GoogleMapsConfig.countryCode],
      origin: origin,
    );
  }

  Future<SearchByTextResponse> searchByText(
    String query, {
    LatLngBounds? locationBias,
    TextSearchRankPreference rankPreference =
        TextSearchRankPreference.Distance,
  }) async {
    await ensureInitialized();
    return _platform.searchByText(
      query,
      fields: [
        PlaceField.Location,
        PlaceField.FormattedAddress,
        PlaceField.DisplayName,
        PlaceField.Types,
      ],
      regionCode: GoogleMapsConfig.countryCode.toUpperCase(),
      maxResultCount: 8,
      locationBias: locationBias,
      rankPreference: rankPreference,
    );
  }

  Future<Place?> fetchPlace(String placeId) async {
    await ensureInitialized();
    final response = await _platform.fetchPlace(
      placeId,
      fields: [
        PlaceField.Location,
        PlaceField.FormattedAddress,
        PlaceField.DisplayName,
      ],
    );
    return response.place;
  }

  LatLngBounds? boundsAround(double lat, double lng, {double delta = 0.35}) {
    return LatLngBounds(
      southwest: LatLng(lat: lat - delta, lng: lng - delta),
      northeast: LatLng(lat: lat + delta, lng: lng + delta),
    );
  }
}
