import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';

const String favoritesActionAdd = 'add';
const String favoritesActionRemove = 'remove';

String favoriteKey(String type, int id) => '$type:$id';

List<Map<String, dynamic>> extractFavoritesResponse(dynamic response) {
  if (response is List) {
    return response
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  if (response is Map) {
    final list = response['favorites'] ?? response['data'] ?? response['items'];
    if (list is List) {
      return list
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
  }
  return [];
}

Map<String, RestaurantModel> favoritesListToMap(List<RestaurantModel> items) {
  final map = <String, RestaurantModel>{};
  for (final item in items) {
    map[favoriteKey(item.favoriteType, item.id)] = item;
  }
  return map;
}

List<RestaurantModel> mergeFavoriteLists(
  List<RestaurantModel> primary,
  List<RestaurantModel> secondary,
) {
  final map = favoritesListToMap(primary);
  for (final item in secondary) {
    map.putIfAbsent(favoriteKey(item.favoriteType, item.id), () => item);
  }
  return map.values.toList();
}

Map<String, String> buildPendingActionMap(List<Map<String, dynamic>> pending) {
  final map = <String, String>{};
  for (final item in pending) {
    final action = item['action']?.toString();
    final type = item['type']?.toString();
    final idValue = item['id'];
    final id = idValue is int ? idValue : int.tryParse('$idValue');
    if (action == null || type == null || id == null) continue;
    map[favoriteKey(type, id)] = action;
  }
  return map;
}

List<Map<String, dynamic>> pendingMapToList(Map<String, String> map) {
  final list = <Map<String, dynamic>>[];
  map.forEach((key, action) {
    final parts = key.split(':');
    if (parts.length != 2) return;
    final type = parts[0];
    final id = int.tryParse(parts[1]) ?? 0;
    if (id <= 0) return;
    list.add({'action': action, 'type': type, 'id': id});
  });
  return list;
}
