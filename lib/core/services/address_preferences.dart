import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة خاصة بحفظ واسترجاع العناوين من SharedPreferences
class AddressPreferences {
  static const String _keyAddresses = 'saved_addresses';

  late SharedPreferences _prefs;

  /// تهيئة SharedPreferences
  Future<AddressPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  /// حفظ قائمة العناوين
  Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
    final jsonString = jsonEncode(addresses);
    await _prefs.setString(_keyAddresses, jsonString);
  }

  /// استرجاع قائمة العناوين
  List<Map<String, dynamic>> getAddresses() {
    final jsonString = _prefs.getString(_keyAddresses);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// حذف جميع العناوين
  Future<void> clearAddresses() async {
    await _prefs.remove(_keyAddresses);
  }
}