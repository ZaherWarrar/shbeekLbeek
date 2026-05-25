import 'package:app/controller/favorites/favorites_local_repository.dart';
import 'package:app/controller/favorites/favorites_utils.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/favorites_data.dart';
import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';

class FavoritesRemoteSync {
  FavoritesRemoteSync({
    required this.favoritesData,
    required this.session,
    required this.local,
  });

  final FavoritesData favoritesData;
  final SessionService session;
  final FavoritesLocalRepository local;

  bool get canSync {
    final token = session.token;
    final userId = session.userId;
    return token != null &&
        token.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;
  }

  Future<List<RestaurantModel>?> fetchServerFavorites() async {
    final response = await favoritesData.listFavoritesData();
    final status = handlingData(response);
    if (status != StatusRequest.success) return null;

    return extractFavoritesResponse(response)
        .map((item) => RestaurantModel.fromFavoriteJson(item))
        .toList();
  }

  Future<void> processPending(String userId) async {
    final pending = local.getPending(userId);
    if (pending.isEmpty) return;

    final remaining = <Map<String, dynamic>>[];
    for (final item in pending) {
      final action = item['action']?.toString();
      final type = item['type']?.toString();
      final idValue = item['id'];
      final id = idValue is int ? idValue : int.tryParse('$idValue');
      if (action == null || type == null || id == null) continue;

      bool success = false;
      if (action == favoritesActionAdd) {
        success = await addOnServer(type, id);
      } else if (action == favoritesActionRemove) {
        success = await removeOnServer(type, id);
      }

      if (!success) {
        remaining.add({'action': action, 'type': type, 'id': id});
      }
    }

    await local.savePendingList(userId, remaining);
  }

  Future<bool> addOnServer(String type, int id) async {
    final response = await favoritesData.addFavoriteData(type, id);
    return handlingData(response) == StatusRequest.success;
  }

  Future<bool> removeOnServer(String type, int id) async {
    final response = await favoritesData.removeFavoriteData(type, id);
    return handlingData(response) == StatusRequest.success;
  }
}
