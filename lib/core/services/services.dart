// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyServices extends GetxService {
//   late SharedPreferences sharedPreferences;

//   // ===== مفاتيح التخزين =====
//   static const String cityIdKey = 'selected_city_id';
//   static const String cityNameKey = 'selected_city_name';
//   static const String guestKey = 'is_guest';
//   static const String tokenKey = 'token';
//   static const String userIdKey = 'user_id';

//   Future<MyServices> init() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     return this;
//   }

//   // ====== المدينة ======
//   Future<void> saveCity(int id, String name) async {
//     await sharedPreferences.setInt(cityIdKey, id);
//     await sharedPreferences.setString(cityNameKey, name);
//   }

//   int? get cityId => sharedPreferences.getInt(cityIdKey);
//   String? get cityName => sharedPreferences.getString(cityNameKey);

//   Future<void> clearCity() async {
//     await sharedPreferences.remove(cityIdKey);
//     await sharedPreferences.remove(cityNameKey);
//   }

//   // ====== الضيف ======
//   Future<void> setGuest(bool value) async {
//     await sharedPreferences.setBool(guestKey, value);
//   }

//   bool get isGuest => sharedPreferences.getBool(guestKey) ?? false;

//   // ====== التوكن ======
//   Future<void> saveToken(String token) async {
//     await sharedPreferences.setString(tokenKey, token);
//   }

//   String? get token => sharedPreferences.getString(tokenKey);

//   Future<void> clearToken() async {
//     await sharedPreferences.remove(tokenKey);
//   }

//   // ====== المستخدم ======
//   Future<void> saveUserId(String id) async {
//     await sharedPreferences.setString(userIdKey, id);
//   }

//   String? get userId => sharedPreferences.getString(userIdKey);

//   // ====== تسجيل الخروج ======
//   Future<void> logout() async {
//     await clearToken();
//     await clearCity();
//     await setGuest(false);
//   }
// }

// Future<void> initialServices() async {
//   await Get.putAsync(() => MyServices().init());
// }
