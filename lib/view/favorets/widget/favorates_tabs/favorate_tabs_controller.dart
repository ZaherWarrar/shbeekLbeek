import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/data/datasorce/remot/favorites_data.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  FavoritesData favoritesData = FavoritesData(Get.find());
  final UserPreferences _prefs = UserPreferences();

  StatusRequest favoriteState = StatusRequest.none;
  var restaurants = <RestaurantModel>[].obs;
  var currentIndex = 1.obs;

  static const String _actionAdd = 'add';
  static const String _actionRemove = 'remove';

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> fetchFavorites() async {
    await _loadLocalFavorites();
    await syncWithServer();
  }

  Future<void> syncWithServer() async {
    final token = await _prefs.getToken();
    final userId = _prefs.getUserId();
    if (token == null ||
        token.isEmpty ||
        userId == null ||
        userId.isEmpty) {
      favoriteState = StatusRequest.success;
      update();
      return;
    }

    await _migrateGuestToUser(userId);
    restaurants.value = _getLocalFavorites(userId);
    update();

    final hasLocal = restaurants.isNotEmpty;
    if (!hasLocal) {
      favoriteState = StatusRequest.loading;
      update();
    }

    final response = await favoritesData.listFavoritesData();
    final status = handelingData(response);

    if (status == StatusRequest.success) {
      final favorites = _extractFavorites(response)
          .map((item) => RestaurantModel.fromFavoriteJson(item))
          .toList();
      await _mergeWithServer(favorites, userId);
      await _processPending(userId);
    }

    favoriteState = StatusRequest.success;
    update();
  }

  List<Map<String, dynamic>> _extractFavorites(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (response is Map) {
      final list =
          response['favorites'] ?? response['data'] ?? response['items'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    }
    return [];
  }

  bool isFavorite(String type, int id) {
    return restaurants.any(
      (item) =>
          item.favoriteType == type && item.id == id && item.isFavorite.value,
    );
  }

  Future<void> toggleFavorite(int index) async {
    if (index < 0 || index >= restaurants.length) return;
    final item = restaurants[index];
    await toggleFavoriteById(type: item.favoriteType, id: item.id, item: item);
  }

  Future<void> toggleFavoriteById({
    required String type,
    required int id,
    RestaurantModel? item,
  }) async {
    if (id <= 0) {
      Get.snackbar('تنبيه', 'لا يمكن إضافة هذا العنصر للمفضلة');
      return;
    }

    final userId = _currentUserId();
    final existingIndex = restaurants.indexWhere(
      (entry) => entry.id == id && entry.favoriteType == type,
    );
    final isLoggedIn = await _canSyncWithServer();

    if (existingIndex != -1) {
      final removedItem = restaurants.removeAt(existingIndex);
      removedItem.isFavorite.value = false;
      update();
      await _saveLocalFavorites(userId, restaurants);
      await _enqueuePending(userId, _actionRemove, type, id);

      if (isLoggedIn) {
        final success = await _tryRemoveFromServer(type, id);
        if (success) {
          await _removePending(userId, type, id);
        } else {
          Get.snackbar(
            'تنبيه',
            'تمت الإزالة محلياً وسيتم المزامنة لاحقاً',
          );
        }
      }
      return;
    }

    if (item == null) {
      Get.snackbar('تنبيه', 'لا يمكن إضافة هذا العنصر للمفضلة');
      return;
    }

    item.isFavorite.value = true;
    restaurants.add(item);
    update();
    await _saveLocalFavorites(userId, restaurants);
    await _enqueuePending(userId, _actionAdd, type, id);

    if (isLoggedIn) {
      final success = await _tryAddToServer(type, id);
      if (success) {
        await _removePending(userId, type, id);
      } else {
        Get.snackbar('تنبيه', 'تمت الإضافة محلياً وسيتم المزامنة لاحقاً');
      }
    }
  }

  String _currentUserId() {
    final id = _prefs.getUserId();
    return (id == null || id.isEmpty) ? 'guest' : id;
  }

  String _favoriteKey(String type, int id) => '$type:$id';

  Future<void> _loadLocalFavorites() async {
    final userId = _currentUserId();
    restaurants.value = _getLocalFavorites(userId);
    favoriteState = StatusRequest.success;
    update();
  }

  List<RestaurantModel> _getLocalFavorites(String userId) {
    final local = _prefs.getFavorites(userId: userId);
    return local
        .map(RestaurantModel.fromLocalJson)
        .where((item) => item.id > 0)
        .toList();
  }

  Future<void> _saveLocalFavorites(
    String userId,
    List<RestaurantModel> items,
  ) async {
    final list = items.map((item) => item.toLocalJson()).toList();
    await _prefs.saveFavorites(list, userId: userId);
  }

  Map<String, RestaurantModel> _listToMap(List<RestaurantModel> items) {
    final map = <String, RestaurantModel>{};
    for (final item in items) {
      final key = _favoriteKey(item.favoriteType, item.id);
      map[key] = item;
    }
    return map;
  }

  Map<String, String> _buildPendingMap(List<Map<String, dynamic>> pending) {
    final map = <String, String>{};
    for (final item in pending) {
      final action = item['action']?.toString();
      final type = item['type']?.toString();
      final idValue = item['id'];
      final id = idValue is int ? idValue : int.tryParse('$idValue');
      if (action == null || type == null || id == null) {
        continue;
      }
      map[_favoriteKey(type, id)] = action;
    }
    return map;
  }

  List<Map<String, dynamic>> _pendingListFromMap(Map<String, String> map) {
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

  Future<void> _enqueuePending(
    String userId,
    String action,
    String type,
    int id,
  ) async {
    final pending = _prefs.getFavoritePending(userId: userId);
    final pendingMap = _buildPendingMap(pending);
    pendingMap[_favoriteKey(type, id)] = action;
    await _prefs.saveFavoritePending(
      _pendingListFromMap(pendingMap),
      userId: userId,
    );
  }

  Future<void> _removePending(String userId, String type, int id) async {
    final pending = _prefs.getFavoritePending(userId: userId);
    final pendingMap = _buildPendingMap(pending);
    pendingMap.remove(_favoriteKey(type, id));
    await _prefs.saveFavoritePending(
      _pendingListFromMap(pendingMap),
      userId: userId,
    );
  }

  List<RestaurantModel> _mergeLocalLists(
    List<RestaurantModel> primary,
    List<RestaurantModel> secondary,
  ) {
    final map = _listToMap(primary);
    for (final item in secondary) {
      final key = _favoriteKey(item.favoriteType, item.id);
      map.putIfAbsent(key, () => item);
    }
    return map.values.toList();
  }

  Future<void> _migrateGuestToUser(String userId) async {
    final guestFavorites = _getLocalFavorites('guest');
    final guestPending = _prefs.getFavoritePending(userId: 'guest');
    if (guestFavorites.isEmpty && guestPending.isEmpty) {
      return;
    }

    final userFavorites = _getLocalFavorites(userId);
    final mergedFavorites = _mergeLocalLists(userFavorites, guestFavorites);
    await _saveLocalFavorites(userId, mergedFavorites);

    final userPending = _prefs.getFavoritePending(userId: userId);
    final pendingMap = _buildPendingMap([...userPending, ...guestPending]);
    await _prefs.saveFavoritePending(
      _pendingListFromMap(pendingMap),
      userId: userId,
    );

    await _prefs.clearFavorites(userId: 'guest');
    await _prefs.clearFavoritePending(userId: 'guest');
  }

  Future<void> _mergeWithServer(
    List<RestaurantModel> serverItems,
    String userId,
  ) async {
    for (final item in serverItems) {
      item.isFavorite.value = true;
    }

    final localItems = _getLocalFavorites(userId);
    final localMap = _listToMap(localItems);
    final serverMap = _listToMap(serverItems);

    final pending = _prefs.getFavoritePending(userId: userId);
    final pendingMap = _buildPendingMap(pending);
    final pendingRemoveKeys = pendingMap.entries
        .where((entry) => entry.value == _actionRemove)
        .map((entry) => entry.key)
        .toSet();

    for (final entry in serverMap.entries) {
      if (!pendingRemoveKeys.contains(entry.key)) {
        localMap.putIfAbsent(entry.key, () => entry.value);
      }
    }

    final serverKeys = serverMap.keys.toSet();
    for (final key in localMap.keys) {
      if (!serverKeys.contains(key)) {
        if (pendingMap[key] != _actionRemove) {
          pendingMap[key] = _actionAdd;
        }
      }
    }

    final cleanedPending = <String, String>{};
    for (final entry in pendingMap.entries) {
      if (entry.value == _actionRemove && !serverKeys.contains(entry.key)) {
        continue;
      }
      cleanedPending[entry.key] = entry.value;
    }

    final mergedList = localMap.values.toList();
    await _saveLocalFavorites(userId, mergedList);
    await _prefs.saveFavoritePending(
      _pendingListFromMap(cleanedPending),
      userId: userId,
    );

    restaurants.value = mergedList;
    update();
  }

  Future<void> _processPending(String userId) async {
    final pending = _prefs.getFavoritePending(userId: userId);
    if (pending.isEmpty) return;

    final remaining = <Map<String, dynamic>>[];
    for (final item in pending) {
      final action = item['action']?.toString();
      final type = item['type']?.toString();
      final idValue = item['id'];
      final id = idValue is int ? idValue : int.tryParse('$idValue');
      if (action == null || type == null || id == null) continue;

      bool success = false;
      if (action == _actionAdd) {
        success = await _tryAddToServer(type, id);
      } else if (action == _actionRemove) {
        success = await _tryRemoveFromServer(type, id);
      }

      if (!success) {
        remaining.add({'action': action, 'type': type, 'id': id});
      }
    }

    await _prefs.saveFavoritePending(remaining, userId: userId);
  }

  Future<bool> _canSyncWithServer() async {
    final token = await _prefs.getToken();
    final userId = _prefs.getUserId();
    return token != null &&
        token.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;
  }

  Future<bool> _tryAddToServer(String type, int id) async {
    final response = await favoritesData.addFavoriteData(type, id);
    return handelingData(response) == StatusRequest.success;
  }

  Future<bool> _tryRemoveFromServer(String type, int id) async {
    final response = await favoritesData.removeFavoriteData(type, id);
    return handelingData(response) == StatusRequest.success;
  }
}
