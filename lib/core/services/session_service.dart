import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends GetxService {
  late final SharedPreferences prefs;
  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );
  static const _secureIoTimeout = Duration(seconds: 3);
  bool _droppingSession = false;

  String? _token;
  String? _userId;

  // ====== Keys ======
  static const tokenKey = "token";
  static const userIdKey = "user_id";
  static const _secureTokenKey = "auth_token";
  static const _secureUserIdKey = "auth_user_id";
  static const userNameKey = "user_name";
  static const _profileSnapshotKey = 'verified_account_name';
  static const accountNotificationsKey = 'accept_account_notifications';
  static const userEmailKey = "user_email";
  static const userRoleKey = "user_role";
  static const userStatusKey = "user_status";
  static const guestKey = "is_guest";
  static const cityIdKey = "city_id";
  static const cityNameKey = "city_name";
  static const activeOrderIdKey = "active_order_id";
  static const activeOrderCreatedAtKey = "active_order_created_at";
  static const languageKey = "language";
  static const onboardingDoneKey = "onboarding_done";

  // ====== INIT ======
  Future<SessionService> init() async {
    prefs = await SharedPreferences.getInstance();
    await _loadSecureSession();
    if (isLoggedIn) await prefs.setBool(accountNotificationsKey, true);
    return this;
  }

  Future<void> _loadSecureSession() async {
    final stored = await Future.wait<String?>([
      _readSecure(_secureTokenKey),
      _readSecure(_secureUserIdKey),
    ]);
    _token = stored[0];
    _userId = stored[1];

    final legacyToken = prefs.getString(tokenKey);
    final legacyUserId = prefs.getString(userIdKey);
    final hasLegacyToken = legacyToken != null && legacyToken.isNotEmpty;
    if ((_token == null || _token!.isEmpty) && hasLegacyToken) {
      final saved = await _writeSecure(_secureTokenKey, legacyToken);
      if (saved) _token = legacyToken;
      if (legacyUserId != null && legacyUserId.isNotEmpty) {
        final savedId = await _writeSecure(_secureUserIdKey, legacyUserId);
        if (savedId) _userId = legacyUserId;
      }
      await prefs.remove(tokenKey);
      await prefs.remove(userIdKey);
      return;
    }

    if (prefs.containsKey(tokenKey) || prefs.containsKey(userIdKey)) {
      await prefs.remove(tokenKey);
      await prefs.remove(userIdKey);
    }
  }

  // ====== AUTH ======
  Future<void> saveLogin({
    required String token,
    required String userId,
  }) async {
    _token = token;
    _userId = userId;
    await _writeSecure(_secureTokenKey, token);
    await _writeSecure(_secureUserIdKey, userId);
    await prefs.setBool(guestKey, false);
    await prefs.setBool(accountNotificationsKey, true);
    await prefs.remove(tokenKey);
    await prefs.remove(userIdKey);
  }

  Future<void> setGuest(bool value) async {
    await prefs.setBool(guestKey, value);
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    await _deleteSecure(_secureTokenKey);
    await _deleteSecure(_secureUserIdKey);
    await prefs.remove(tokenKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userRoleKey);
    await prefs.remove(userStatusKey);
    await prefs.remove(_profileSnapshotKey);
    await prefs.remove(accountNotificationsKey);
  }

  String? get token => _token;
  String? get userId => _userId;
  bool get isGuest => prefs.getBool(guestKey) ?? false;
  bool get isLoggedIn => token != null && token!.isNotEmpty;

  // ====== USER DATA ======
  Future<void> saveUserName(String name) async =>
      await prefs.setString(userNameKey, name);

  String? get userName => prefs.getString(userNameKey);

  /// A verified user's absent/null name requires completion. Bind the snapshot
  /// to the user; never use a legacy cached name from another login.
  Map<String, dynamic>? get verifiedNameSnapshot {
    try {
      final raw = prefs.getString(_profileSnapshotKey);
      if (raw == null) return null;
      final value = jsonDecode(raw);
      if (value is Map<String, dynamic> &&
          value['id'] == userId &&
          value.containsKey('name')) {
        return value;
      }
    } catch (_) {}
    return null;
  }

  bool get isNameKnown => verifiedNameSnapshot != null;
  bool get hasCompletedName {
    final name = verifiedNameSnapshot?['name'];
    return name is String && name.trim().isNotEmpty;
  }

  Future<void> acceptVerifiedUser(Map<String, dynamic> user) async {
    await prefs.remove(_profileSnapshotKey);
    await prefs.remove(userNameKey);
    if (user['id']?.toString() != userId) return;
    final name = user['name'];
    if (name != null && name is! String) return;
    await saveVerifiedName(name as String?);
  }

  Future<void> saveVerifiedName(String? name) async {
    final trimmed = name?.trim();
    await prefs.setString(
      _profileSnapshotKey,
      jsonEncode({'id': userId, 'name': trimmed}),
    );
    if (trimmed == null) {
      await prefs.remove(userNameKey);
    } else {
      await saveUserName(trimmed);
    }
  }

  /// Remove account data, retaining only non-account presentation choices.
  Future<void> clearAccountData() async {
    final lang = language;
    final onboarding = isOnboardingDone;
    await clearAll();
    if (lang != null) await saveLanguage(lang);
    await setOnboardingDone(onboarding);
  }

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
    await prefs.setString(activeOrderCreatedAtKey, createdAt.toIso8601String());
  }

  Map<String, dynamic>? get activeOrder {
    try {
      final id = prefs.getString(activeOrderIdKey);
      final created = prefs.getString(activeOrderCreatedAtKey);
      if (id == null || created == null) return null;
      return {"orderId": int.parse(id), "createdAt": DateTime.parse(created)};
    } catch (_) {
      return null;
    }
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

  // ====== ONBOARDING ======
  Future<void> setOnboardingDone(bool value) async =>
      await prefs.setBool(onboardingDoneKey, value);

  bool get isOnboardingDone => prefs.getBool(onboardingDoneKey) ?? false;

  Future<void> restOnboarding() async => await prefs.remove(onboardingDoneKey);

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
    await prefs.setString(_favoritesKey(userId), jsonEncode(favorites));
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
    await prefs.setString(_favoritesPendingKey(userId), jsonEncode(pending));
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
  Future<void> clearAll() async {
    _token = null;
    _userId = null;
    await _deleteSecure(_secureTokenKey);
    await _deleteSecure(_secureUserIdKey);
    await prefs.clear();
  }

  /// تسجيل الدخول بيرجع access token فقط، وما في refresh token بالـ API.
  /// إذا السيرفر رد 401 والتوكن موجود، الجلسة خلصت وما فينا نجددها.
  void dropExpiredSession() {
    if (_droppingSession || !isLoggedIn) return;
    _droppingSession = true;
    logout().whenComplete(() {
      _droppingSession = false;
      if (Get.currentRoute == '/') return;
      Get.offAllNamed('/');
      Get.snackbar(
        'تنبيه',
        'انتهت الجلسة، سجّل الدخول من جديد',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<String?> _readSecure(String key) async {
    try {
      return await _secure.read(key: key).timeout(_secureIoTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<bool> _writeSecure(String key, String value) async {
    try {
      await _secure.write(key: key, value: value).timeout(_secureIoTimeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _deleteSecure(String key) async {
    try {
      await _secure.delete(key: key).timeout(_secureIoTimeout);
    } catch (_) {}
  }
}
