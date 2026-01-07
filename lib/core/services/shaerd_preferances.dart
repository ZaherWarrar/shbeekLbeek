import 'dart:convert';

import 'package:get/get.dart';
import 'package:app/core/services/services.dart';

class UserPreferences {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = "user_role";
  static const String _keyUserStatus = "user_status";
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
