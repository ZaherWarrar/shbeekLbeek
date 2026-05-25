import 'package:app/controller/favorites/favorites_local_repository.dart';
import 'package:app/controller/favorites/favorites_remote_sync.dart';
import 'package:app/controller/favorites/favorites_utils.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/favorites_data.dart';
import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final FavoritesData favoritesData = FavoritesData(Get.find());
  final SessionService _session = Get.find();

  late final FavoritesLocalRepository _local =
      FavoritesLocalRepository(_session);
  late final FavoritesRemoteSync _sync = FavoritesRemoteSync(
    favoritesData: favoritesData,
    session: _session,
    local: _local,
  );

  StatusRequest favoriteState = StatusRequest.none;
  var restaurants = <RestaurantModel>[].obs;
  var currentIndex = 1.obs;

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
    if (!_sync.canSync) {
      favoriteState = StatusRequest.success;
      update();
      return;
    }

    final userId = _local.resolveUserId();
    await _local.migrateGuestToUser(userId);
    restaurants.value = _local.load(userId);
    update();

    final hasLocal = restaurants.isNotEmpty;
    if (!hasLocal) {
      favoriteState = StatusRequest.loading;
      update();
    }

    final serverFavorites = await _sync.fetchServerFavorites();
    if (serverFavorites != null) {
      final merged = await _local.mergeWithServer(
        userId: userId,
        serverItems: serverFavorites,
      );
      restaurants.value = merged.items;
      await _sync.processPending(userId);
    }

    favoriteState = StatusRequest.success;
    update();
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

    final userId = _local.resolveUserId();
    final existingIndex = restaurants.indexWhere(
      (entry) => entry.id == id && entry.favoriteType == type,
    );
    final isLoggedIn = _sync.canSync;

    if (existingIndex != -1) {
      final confirmed = await Get.defaultDialog<bool>(
        title: 'تأكيد الحذف',
        middleText: 'هل أنت متأكد أنك تريد إزالة هذا العنصر من المفضلة؟',
        textConfirm: 'نعم',
        textCancel: 'إلغاء',
        confirmTextColor: Get.theme.colorScheme.onPrimary,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      );

      if (confirmed != true) return;

      final removedItem = restaurants.removeAt(existingIndex);
      removedItem.isFavorite.value = false;
      update();
      await _local.save(userId, restaurants);
      await _local.enqueuePending(
        userId,
        favoritesActionRemove,
        type,
        id,
      );

      if (isLoggedIn) {
        final success = await _sync.removeOnServer(type, id);
        if (success) {
          await _local.removePending(userId, type, id);
        } else {
          Get.snackbar('تنبيه', 'تمت الإزالة محلياً وسيتم المزامنة لاحقاً');
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
    await _local.save(userId, restaurants);
    await _local.enqueuePending(userId, favoritesActionAdd, type, id);

    if (isLoggedIn) {
      final success = await _sync.addOnServer(type, id);
      if (success) {
        await _local.removePending(userId, type, id);
      } else {
        Get.snackbar('تنبيه', 'تمت الإضافة محلياً وسيتم المزامنة لاحقاً');
      }
    }
  }

  Future<void> _loadLocalFavorites() async {
    final userId = _local.resolveUserId();
    restaurants.value = _local.load(userId);
    favoriteState = StatusRequest.success;
    update();
  }
}
