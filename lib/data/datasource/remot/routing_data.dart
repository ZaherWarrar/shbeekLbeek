import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// نتيجة حساب المسار الأقصر/الأسرع على الطرق.
class RouteResult {
  const RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  double get distanceKm => distanceMeters / 1000;
  double get durationMinutes => durationSeconds / 60;
}

/// خدمة توجيه تعتمد OSRM العام (مفتوح المصدر، بدون مفتاح API).
/// ترجع نقاط المسار الفعلي على الشوارع لرسمها على flutter_map.
class RoutingData {
  static const String _baseUrl =
      'https://router.project-osrm.org/route/v1/driving';

  Future<RouteResult?> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    final coords = '$fromLng,$fromLat;$toLng,$toLat';
    final uri = Uri.parse(
      '$_baseUrl/$coords?overview=full&geometries=geojson',
    );

    try {
      final response = await http
          .get(uri, headers: const {'User-Agent': 'ShbeekLbeek/1.0'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) return null;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] != 'Ok') return null;

      final routes = body['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List<dynamic>;

      final points = coordinates
          .map<LatLng>(
            (c) => LatLng(
              (c[1] as num).toDouble(),
              (c[0] as num).toDouble(),
            ),
          )
          .toList();

      return RouteResult(
        points: points,
        distanceMeters: (route['distance'] as num).toDouble(),
        durationSeconds: (route['duration'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
