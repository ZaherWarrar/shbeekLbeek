// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserPreferences {
//   static late SharedPreferences _prefs;

//   static const String _keyToken = 'token';
//   static const String _keyUserId = 'user_id';
//   static const String _keyUserName = 'user_name';
//   static const String _keyUserEmail = 'user_email';
//   static const String _keyUserRole = 'user_role';
//   static const String _keyUserStatus = 'user_status';
//   static const String _keyActiveOrderId = 'active_order_id';
//   static const String _keyActiveOrderCreatedAt = 'active_order_created_at';
//   static const String _keyCityId = 'selected_city_id';
//   static const String _keyCityName = 'selected_city_name';
//   static const String _keyLanguage = 'language';

//   Future<UserPreferences> init() async {
//     _prefs = await SharedPreferences.getInstance();
//     return this;
//   }

//   // ====== Token ======
//   Future<void> saveToken(String token) async => await _prefs.setString(_keyToken, token);
//   Future<String?> getToken() async => _prefs.getString(_keyToken);
//   Future<void> clearToken() async => await _prefs.remove(_keyToken);

//   // ====== User Data ======
//   Future<void> saveUserId(String id) async => await _prefs.setString(_keyUserId, id);
//   String? getUserId() => _prefs.getString(_keyUserId);
//   Future<void> saveUserName(String name) async => await _prefs.setString(_keyUserName, name);
//   String? getUserName() => _prefs.getString(_keyUserName);
//   Future<void> saveUserEmail(String email) async => await _prefs.setString(_keyUserEmail, email);
//   String? getUserEmail() => _prefs.getString(_keyUserEmail);
//   Future<void> saveUserRole(String role) async => await _prefs.setString(_keyUserRole, role);
//   Future<String?> getUserRole() async => _prefs.getString(_keyUserRole);
//   Future<void> saveUserStatus(String status) async => await _prefs.setString(_keyUserStatus, status);
//   Future<String?> getUserStatus() async => _prefs.getString(_keyUserStatus);

//   // ====== Active Order ======
//   Future<void> saveActiveOrder(int orderId, DateTime createdAt) async {
//     await _prefs.setString(_keyActiveOrderId, orderId.toString());
//     await _prefs.setString(_keyActiveOrderCreatedAt, createdAt.toIso8601String());
//   }

//   Map<String, dynamic>? getActiveOrder() {
//     final orderIdStr = _prefs.getString(_keyActiveOrderId);
//     final createdAtStr = _prefs.getString(_keyActiveOrderCreatedAt);
//     if (orderIdStr == null || createdAtStr == null) return null;
//     return {
//       'orderId': int.parse(orderIdStr),
//       'createdAt': DateTime.parse(createdAtStr),
//     };
//   }

//   Future<void> clearActiveOrder() async {
//     await _prefs.remove(_keyActiveOrderId);
//     await _prefs.remove(_keyActiveOrderCreatedAt);
//   }

//   bool hasActiveOrder() => _prefs.getString(_keyActiveOrderId) != null;

//   // ====== City ======
//   Future<void> saveCity(int id, String name) async {
//     await _prefs.setInt(_keyCityId, id);
//     await _prefs.setString(_keyCityName, name);
//   }

//   int? get cityId => _prefs.getInt(_keyCityId);
//   String? get cityName => _prefs.getString(_keyCityName);

//   Future<void> clearCity() async {
//     await _prefs.remove(_keyCityId);
//     await _prefs.remove(_keyCityName);
//   }

//   // ====== Language ======
//   Future<void> saveLanguage(String code) async => await _prefs.setString(_keyLanguage, code);
//   String? getLanguage() => _prefs.getString(_keyLanguage);


