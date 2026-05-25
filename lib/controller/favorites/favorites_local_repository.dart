import 'package:app/controller/favorites/favorites_utils.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';

class FavoritesLocalRepository {
  FavoritesLocalRepository(this._session);

  final SessionService _session;

  String resolveUserId() {
    final id = _session.userId;
    return (id == null || id.isEmpty) ? 'guest' : id;
  }

  List<RestaurantModel> load(String userId) {
    final local = _session.getFavorites(userId: userId);
    return local
        .map(RestaurantModel.fromLocalJson)
        .where((item) => item.id > 0)
        .toList();
  }

  Future<void> save(String userId, List<RestaurantModel> items) async {
    final list = items.map((item) => item.toLocalJson()).toList();
    await _session.saveFavorites(list, userId: userId);
  }

  Future<void> enqueuePending(
    String userId,
    String action,
    String type,
    int id,
  ) async {
    final pending = _session.getFavoritePending(userId: userId);
    final pendingMap = buildPendingActionMap(pending);
    pendingMap[favoriteKey(type, id)] = action;
    await _session.saveFavoritePending(
      pendingMapToList(pendingMap),
      userId: userId,
    );
  }

  Future<void> removePending(String userId, String type, int id) async {
    final pending = _session.getFavoritePending(userId: userId);
    final pendingMap = buildPendingActionMap(pending);
    pendingMap.remove(favoriteKey(type, id));
    await _session.saveFavoritePending(
      pendingMapToList(pendingMap),
      userId: userId,
    );
  }

  Future<void> savePendingList(
    String userId,
    List<Map<String, dynamic>> pending,
  ) async {
    await _session.saveFavoritePending(pending, userId: userId);
  }

  List<Map<String, dynamic>> getPending(String userId) =>
      _session.getFavoritePending(userId: userId);

  Future<void> migrateGuestToUser(String userId) async {
    final guestFavorites = load('guest');
    final guestPending = getPending('guest');
    if (guestFavorites.isEmpty && guestPending.isEmpty) return;

    final userFavorites = load(userId);
    final mergedFavorites = mergeFavoriteLists(userFavorites, guestFavorites);
    await save(userId, mergedFavorites);

    final userPending = getPending(userId);
    final pendingMap = buildPendingActionMap([...userPending, ...guestPending]);
    await _session.saveFavoritePending(
      pendingMapToList(pendingMap),
      userId: userId,
    );

    await _session.clearFavorites(userId: 'guest');
    await _session.clearFavoritePending(userId: 'guest');
  }

  Future<({List<RestaurantModel> items, List<Map<String, dynamic>> pending})>
  mergeWithServer({
    required String userId,
    required List<RestaurantModel> serverItems,
  }) async {
    for (final item in serverItems) {
      item.isFavorite.value = true;
    }

    final localMap = favoritesListToMap(load(userId));
    final serverMap = favoritesListToMap(serverItems);

    final pendingMap = buildPendingActionMap(getPending(userId));
    final pendingRemoveKeys = pendingMap.entries
        .where((entry) => entry.value == favoritesActionRemove)
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
        if (pendingMap[key] != favoritesActionRemove) {
          pendingMap[key] = favoritesActionAdd;
        }
      }
    }

    final cleanedPending = <String, String>{};
    for (final entry in pendingMap.entries) {
      if (entry.value == favoritesActionRemove &&
          !serverKeys.contains(entry.key)) {
        continue;
      }
      cleanedPending[entry.key] = entry.value;
    }

    final mergedList = localMap.values.toList();
    await save(userId, mergedList);
    await _session.saveFavoritePending(
      pendingMapToList(cleanedPending),
      userId: userId,
    );

    return (items: mergedList, pending: pendingMapToList(cleanedPending));
  }
}
