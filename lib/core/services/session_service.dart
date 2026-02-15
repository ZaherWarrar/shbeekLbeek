import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends GetxService {
  late final SharedPreferences prefs;

  // ====== Keys ======
  static const tokenKey = "token";
  static const userIdKey = "user_id";
  static const userNameKey = "user_name";
  static const userEmailKey = "user_email";
  static const userRoleKey = "user_role";
  static const userStatusKey = "user_status";
  static const guestKey = "is_guest";
  static const cityIdKey = "city_id";
  static const cityNameKey = "city_name";
  static const activeOrderIdKey = "active_order_id";
  static const activeOrderCreatedAtKey = "active_order_created_at";
  static const languageKey = "language";

  // ====== INIT ======
  Future<SessionService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ====== AUTH ======
  Future<void> saveLogin({
    required String token,
    required String userId,
  }) async {
    await prefs.setString(tokenKey, token);
    await prefs.setString(userIdKey, userId);
    await prefs.setBool(guestKey, false);
  }

  Future<void> setGuest(bool value) async {
    await prefs.setBool(guestKey, value);
  }

  Future<void> logout() async {
    await prefs.remove(tokenKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userRoleKey);
    await prefs.remove(userStatusKey);
  }

  String? get token => prefs.getString(tokenKey);
  String? get userId => prefs.getString(userIdKey);
  bool get isGuest => prefs.getBool(guestKey) ?? false;
  bool get isLoggedIn => token != null && token!.isNotEmpty;

  // ====== USER DATA ======
  Future<void> saveUserName(String name) async =>
      await prefs.setString(userNameKey, name);

  String? get userName => prefs.getString(userNameKey);

  Future<void> saveUserEmail(String email) async =>
      await prefs.setString(userEmailKey, email);

  String? get userEmail => prefs.getString(userEmailKey);

  Future<void> saveUserRole(String role) async =>
      await prefs.setString(userRoleKey, role);

  String? get userRole => prefs.getString(userRoleKey);

  Future<void> saveUserStatus(String status) async =>
      await prefs.setString(userStatusKey, status);

  String? get userStatus => prefs.getString(userStatusKey);

  // ====== CITY ======
  Future<void> saveCity(int id, String name) async {
    await prefs.setInt(cityIdKey, id);
    await prefs.setString(cityNameKey, name);
  }

  int? get cityId => prefs.getInt(cityIdKey);
  String? get cityName => prefs.getString(cityNameKey);

  Future<void> clearCity() async {
    await prefs.remove(cityIdKey);
    await prefs.remove(cityNameKey);
  }

  // ====== ACTIVE ORDER ======
  Future<void> saveActiveOrder(int orderId, DateTime createdAt) async {
    await prefs.setString(activeOrderIdKey, orderId.toString());
    await prefs.setString(
      activeOrderCreatedAtKey,
      createdAt.toIso8601String(),
    );
  }

  Map<String, dynamic>? get activeOrder {
    final id = prefs.getString(activeOrderIdKey);
    final created = prefs.getString(activeOrderCreatedAtKey);
    if (id == null || created == null) return null;

    return {
      "orderId": int.parse(id),
      "createdAt": DateTime.parse(created),
    };
  }

  bool get hasActiveOrder => prefs.getString(activeOrderIdKey) != null;

  Future<void> clearActiveOrder() async {
    await prefs.remove(activeOrderIdKey);
    await prefs.remove(activeOrderCreatedAtKey);
  }

  // ====== LANGUAGE ======
  Future<void> saveLanguage(String code) async =>
      await prefs.setString(languageKey, code);

  String? get language => prefs.getString(languageKey);

  // ====== HEADERS ======
  Map<String, String> get headers {
    if (token == null || token!.isEmpty) return {};
    return {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  // ====== FAVORITES ======
  String _normalizeUserId(String? userId) {
    final id = userId?.trim();
    return (id == null || id.isEmpty) ? 'guest' : id;
  }

  String _favoritesKey(String? userId) =>
      'favorites_${_normalizeUserId(userId)}';

  String _favoritesPendingKey(String? userId) =>
      'favorites_pending_${_normalizeUserId(userId)}';

  Future<void> saveFavorites(
    List<Map<String, dynamic>> favorites, {
    String? userId,
  }) async {
    await prefs.setString(
      _favoritesKey(userId),
      jsonEncode(favorites),
    );
  }

  List<Map<String, dynamic>> getFavorites({String? userId}) {
    final json = prefs.getString(_favoritesKey(userId));
    if (json == null) return [];
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }
  // ====== FAVORITES PENDING ======

Future<void> saveFavoritePending(
  List<Map<String, dynamic>> pending, {
  String? userId,
}) async {
  await prefs.setString(
    _favoritesPendingKey(userId),
    jsonEncode(pending),
  );
}

List<Map<String, dynamic>> getFavoritePending({String? userId}) {
  final json = prefs.getString(_favoritesPendingKey(userId));
  if (json == null) return [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  } catch (_) {}
  return [];
}

Future<void> clearFavoritePending({String? userId}) async =>
    await prefs.remove(_favoritesPendingKey(userId));


  Future<void> clearFavorites({String? userId}) async =>
      await prefs.remove(_favoritesKey(userId));

  // ====== CLEAR ALL ======
  Future<void> clearAll() async => await prefs.clear();
}
