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
