import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class ResolvedAddress {
  const ResolvedAddress({
    required this.city,
    required this.fullAddress,
  });

  final String city;
  final String fullAddress;
}

/// عكس الإحداثيات إلى مدينة وعنوان — جهاز أولاً ثم OSM Nominatim كاحتياط.
class ReverseGeocodingData {
  static const _nominatimUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const _userAgent = 'ShbeekLbeek/1.0';

  Future<ResolvedAddress> resolve(double lat, double lng) async {
    final fromDevice = await _fromDeviceGeocoder(lat, lng);
    if (fromDevice.city.isNotEmpty) {
      return fromDevice;
    }

    final fromOsm = await _fromNominatim(lat, lng);
    if (fromOsm != null) {
      return ResolvedAddress(
        city: fromOsm.city.isNotEmpty ? fromOsm.city : fromDevice.city,
        fullAddress: fromOsm.fullAddress.isNotEmpty
            ? fromOsm.fullAddress
            : fromDevice.fullAddress,
      );
    }

    return fromDevice;
  }

  Future<ResolvedAddress> _fromDeviceGeocoder(double lat, double lng) async {
    try {
      await setLocaleIdentifier('ar');
      final placemarks = await placemarkFromCoordinates(lat, lng);

      for (final place in placemarks) {
        final city = _extractCityFromPlacemark(place);
        if (city.isNotEmpty) {
          return ResolvedAddress(
            city: city,
            fullAddress: _buildFullAddressFromPlacemark(place, city),
          );
        }
      }

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = _extractCityFromPlacemark(place);
        return ResolvedAddress(
          city: city,
          fullAddress: _buildFullAddressFromPlacemark(place, city),
        );
      }
    } catch (_) {}

    return const ResolvedAddress(city: '', fullAddress: 'عنوان غير محدد');
  }

  Future<ResolvedAddress?> _fromNominatim(double lat, double lng) async {
    try {
      final uri = Uri.parse(_nominatimUrl).replace(
        queryParameters: {
          'lat': lat.toString(),
          'lon': lng.toString(),
          'format': 'json',
          'addressdetails': '1',
          'accept-language': 'ar',
        },
      );

      final response = await http
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return null;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final address = body['address'] as Map<String, dynamic>?;
      final city = _extractCityFromOsmAddress(address);
      final displayName = body['display_name']?.toString().trim() ?? '';

      if (city.isEmpty && displayName.isEmpty) return null;

      return ResolvedAddress(
        city: city,
        fullAddress: displayName.isNotEmpty
            ? displayName
            : (city.isNotEmpty ? city : 'عنوان غير محدد'),
      );
    } catch (_) {
      return null;
    }
  }

  String _extractCityFromPlacemark(Placemark place) {
    final candidates = [
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.subLocality,
      place.name,
      place.thoroughfare,
    ];
    for (final c in candidates) {
      if (c != null && c.trim().isNotEmpty) return c.trim();
    }
    return '';
  }

  String _extractCityFromOsmAddress(Map<String, dynamic>? address) {
    if (address == null) return '';
    const keys = [
      'city',
      'town',
      'municipality',
      'village',
      'county',
      'state',
      'suburb',
      'neighbourhood',
      'district',
    ];
    for (final key in keys) {
      final value = address[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return '';
  }

  String _buildFullAddressFromPlacemark(Placemark place, String city) {
    final parts = <String>[];
    void add(String? value) {
      if (value == null) return;
      final t = value.trim();
      if (t.isEmpty || parts.contains(t)) return;
      parts.add(t);
    }

    add(place.street);
    add(place.subThoroughfare);
    add(place.thoroughfare);
    add(place.subLocality);
    if (city.isNotEmpty) add(city);
    add(place.administrativeArea);
    add(place.country);

    return parts.isNotEmpty ? parts.join(', ') : 'عنوان غير محدد';
  }
}
