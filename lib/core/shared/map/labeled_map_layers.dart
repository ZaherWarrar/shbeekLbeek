import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// طبقات خريطة غنية بالتسميات (شوارع، أحياء، دوارات، محلات مسجّلة في OSM).
class LabeledMapLayers {
  LabeledMapLayers._();

  static const String _userAgent = 'ShbeekLbeek/1.0';

  /// OpenStreetMap — أغنى تسميات محلية (حسب بيانات OSM في المنطقة).
  static TileLayer osmBase() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'app.shbeeklbeek',
      maxZoom: 19,
      additionalOptions: const {'User-Agent': _userAgent},
    );
  }

  static List<Widget> all() {
    return [
      osmBase(),
      RichAttributionWidget(
        alignment: AttributionAlignment.bottomLeft,
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap',
            onTap: () {},
          ),
        ],
      ),
    ];
  }
}
