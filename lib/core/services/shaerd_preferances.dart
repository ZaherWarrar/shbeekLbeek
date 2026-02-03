import 'dart:convert';

import 'package:get/get.dart';
import 'package:app/core/services/services.dart';

class UserPreferences {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = "user_role";
  static const String _keyUserStatus = "user_status";
  static const String _keyUserName = "user_name";
  static const String _keyUserEmail = "user_email";
  static const String _keyActiveOrderId = "active_order_id";
  static const String _keyActiveOrderCreatedAt = "active_order_created_at";
  MyServices myServices = Get.find();
  // ===================== save token ============================
  Future<void> saveToken(String token) async {
    await myServices.sharedPreferences.setString(_keyToken, token);
  }

  // ===================== get token ============================
  Future<String?> getToken() async {
    return myServices.sharedPreferences.getString(_keyToken);
  }

  // ===================== delete token ============================
  Future<void> clearToken() async {
    await myServices.sharedPreferences.remove(_keyToken);
  }

  // ===================== save UserId ============================
  Future<void> saveUserId(String userId) async {
    await myServices.sharedPreferences.setString(_keyUserId, userId);
  }

  // ===================== get UserId ============================
  String? getUserId() {
    return myServices.sharedPreferences.getString(_keyUserId);
  }

  // ===================== delete UserId ============================
  Future<void> clearUserId() async {
    await myServices.sharedPreferences.remove(_keyUserId);
  }

  // ===================== save UserRole ============================
  Future<void> saveUserRole(String userRole) async {
    await myServices.sharedPreferences.setString(_keyUserRole, userRole);
  }

  // ===================== get UserRole ============================
  Future<String?> getUserRole() async {
    return myServices.sharedPreferences.getString(_keyUserRole);
  }

  // ===================== delete UserRole ============================
  Future<void> clearUserRole() async {
    await myServices.sharedPreferences.remove(_keyUserRole);
  }

  // ===================== save UsreStatuse ============================
  Future<void> saveUserStatus(String userStatus) async {
    await myServices.sharedPreferences.setString(_keyUserStatus, userStatus);
  }

  // ===================== get UserStatus ============================
  Future<String?> getUserStatus() async {
    return myServices.sharedPreferences.getString(_keyUserStatus);
  }

  // ===================== delete UserStatuse ============================
  Future<void> clearUserStatus() async {
    await myServices.sharedPreferences.remove(_keyUserStatus);
  }

  // ===================== Delete everything (SignOut) ============================
  Future<void> clearAll() async {
    await myServices.sharedPreferences.clear();
  }

  // ===================== save Cart ============================
  Future<void> saveCart(List<Map<String, dynamic>> cartItems) async {
    String cartJson = jsonEncode(cartItems);
    await myServices.sharedPreferences.setString('cart_items', cartJson);
  }

  // ===================== get Cart ============================
  List<Map<String, dynamic>> getCart() {
    String? cartJson = myServices.sharedPreferences.getString('cart_items');
    if (cartJson == null) return [];
    try {
      List<dynamic> decoded = jsonDecode(cartJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // ===================== clear Cart ============================
  Future<void> clearCart() async {
    await myServices.sharedPreferences.remove('cart_items');
    await myServices.sharedPreferences.remove('cart_discount_code');
    await myServices.sharedPreferences.remove('cart_notes');
  }

  // ===================== save Discount Code ============================
  Future<void> saveDiscountCode(String code) async {
    await myServices.sharedPreferences.setString('cart_discount_code', code);
  }

  // ===================== get Discount Code ============================
  String? getDiscountCode() {
    return myServices.sharedPreferences.getString('cart_discount_code');
  }

  // ===================== remove Discount Code ============================
  Future<void> removeDiscountCode() async {
    await myServices.sharedPreferences.remove('cart_discount_code');
  }

  // ===================== save Notes ============================
  Future<void> saveNotes(String notes) async {
    await myServices.sharedPreferences.setString('cart_notes', notes);
  }

  // ===================== get Notes ============================
  String? getNotes() {
    return myServices.sharedPreferences.getString('cart_notes');
  }

  // ===================== remove Notes ============================
  Future<void> removeNotes() async {
    await myServices.sharedPreferences.remove('cart_notes');
  }

  // ===================== save User Name ============================
  Future<void> saveUserName(String name) async {
    await myServices.sharedPreferences.setString(_keyUserName, name);
  }

  // ===================== get User Name ============================
  String? getUserName() {
    return myServices.sharedPreferences.getString(_keyUserName);
  }

  // ===================== delete User Name ============================
  Future<void> clearUserName() async {
    await myServices.sharedPreferences.remove(_keyUserName);
  }

  // ===================== save User Email ============================
  Future<void> saveUserEmail(String email) async {
    await myServices.sharedPreferences.setString(_keyUserEmail, email);
  }

  // ===================== get User Email ============================
  String? getUserEmail() {
    return myServices.sharedPreferences.getString(_keyUserEmail);
  }

  // ===================== delete User Email ============================
  Future<void> clearUserEmail() async {
    await myServices.sharedPreferences.remove(_keyUserEmail);
  }

  // ===================== save Active Order ============================
  Future<void> saveActiveOrder(int orderId, DateTime createdAt) async {
    await myServices.sharedPreferences.setString(
      _keyActiveOrderId,
      orderId.toString(),
    );
    await myServices.sharedPreferences.setString(
      _keyActiveOrderCreatedAt,
      createdAt.toIso8601String(),
    );
  }

  // ===================== get Active Order ============================
  Map<String, dynamic>? getActiveOrder() {
    final orderIdStr = myServices.sharedPreferences.getString(
      _keyActiveOrderId,
    );
    final createdAtStr = myServices.sharedPreferences.getString(
      _keyActiveOrderCreatedAt,
    );

    if (orderIdStr == null || createdAtStr == null) {
      return null;
    }

    try {
      final orderId = int.parse(orderIdStr);
      final createdAt = DateTime.parse(createdAtStr);
      return {'orderId': orderId, 'createdAt': createdAt};
    } catch (e) {
      return null;
    }
  }

  // ===================== clear Active Order ============================
  Future<void> clearActiveOrder() async {
    await myServices.sharedPreferences.remove(_keyActiveOrderId);
    await myServices.sharedPreferences.remove(_keyActiveOrderCreatedAt);
  }

  // ===================== has Active Order ============================
  bool hasActiveOrder() {
    return myServices.sharedPreferences.getString(_keyActiveOrderId) != null;
  }

  // ===================== save Addresses ============================
  Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
    String addressesJson = jsonEncode(addresses);
    await myServices.sharedPreferences.setString(
      'user_addresses',
      addressesJson,
    );
  }

  // ===================== get Addresses ============================
  List<Map<String, dynamic>> getAddresses() {
    String? addressesJson = myServices.sharedPreferences.getString(
      'user_addresses',
    );
    if (addressesJson == null) return [];
    try {
      List<dynamic> decoded = jsonDecode(addressesJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // ===================== clear Addresses ============================
  Future<void> clearAddresses() async {
    await myServices.sharedPreferences.remove('user_addresses');
  }

  // ===================== Favorites (Local) ============================
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
    final favoritesJson = jsonEncode(favorites);
    await myServices.sharedPreferences.setString(
      _favoritesKey(userId),
      favoritesJson,
    );
  }

  List<Map<String, dynamic>> getFavorites({String? userId}) {
    final favoritesJson = myServices.sharedPreferences.getString(
      _favoritesKey(userId),
    );
    if (favoritesJson == null) return [];
    try {
      final decoded = jsonDecode(favoritesJson);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<void> clearFavorites({String? userId}) async {
    await myServices.sharedPreferences.remove(_favoritesKey(userId));
  }

  Future<void> saveFavoritePending(
    List<Map<String, dynamic>> pending, {
    String? userId,
  }) async {
    final pendingJson = jsonEncode(pending);
    await myServices.sharedPreferences.setString(
      _favoritesPendingKey(userId),
      pendingJson,
    );
  }

  List<Map<String, dynamic>> getFavoritePending({String? userId}) {
    final pendingJson = myServices.sharedPreferences.getString(
      _favoritesPendingKey(userId),
    );
    if (pendingJson == null) return [];
    try {
      final decoded = jsonDecode(pendingJson);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<void> clearFavoritePending({String? userId}) async {
    await myServices.sharedPreferences.remove(_favoritesPendingKey(userId));
  }

  // // حفظ بيانات المستخدم (كـ JSON)
  // static Future<void> saveUser(Map<String, dynamic> user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String userJson = jsonEncode(user);
  //   await prefs.setString(_keyUser, userJson);
  // }

  // // جلب بيانات المستخدم
  // static Future<Map<String, dynamic>?> getUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? userJson = prefs.getString(_keyUser);
  //   if (userJson == null) return null;
  //   return jsonDecode(userJson);
  // }

  // // حذف بيانات المستخدم
  // static Future<void> clearUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_keyUser);
  // }
}
