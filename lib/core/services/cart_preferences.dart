import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartPreferences {
  static const String _keyCart = 'cart_items';
  static const String _keyDiscountCode = 'discount_code';
  static const String _keyNotes = 'cart_notes';
  static const String _keyActiveOrderId = 'active_order_id';
  static const String _keyActiveOrderCreatedAt = 'active_order_created_at';

  late SharedPreferences _prefs;

  Future<CartPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ====== CART ======
  Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final jsonString = jsonEncode(cart);
    await _prefs.setString(_keyCart, jsonString);
  }

  List<Map<String, dynamic>> getCart() {
    final jsonString = _prefs.getString(_keyCart);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> clearCart() async {
    await _prefs.remove(_keyCart);
  }

  // ====== DISCOUNT CODE ======
  Future<void> saveDiscountCode(String code) async =>
      await _prefs.setString(_keyDiscountCode, code);

  String? getDiscountCode() => _prefs.getString(_keyDiscountCode);

  Future<void> removeDiscountCode() async =>
      await _prefs.remove(_keyDiscountCode);

  // ====== NOTES ======
  Future<void> saveNotes(String notes) async =>
      await _prefs.setString(_keyNotes, notes);

  String? getNotes() => _prefs.getString(_keyNotes);

  Future<void> removeNotes() async => await _prefs.remove(_keyNotes);

  // ====== ACTIVE ORDER ======
  Future<void> saveActiveOrder(int orderId, DateTime createdAt) async {
    await _prefs.setString(_keyActiveOrderId, orderId.toString());
    await _prefs.setString(
        _keyActiveOrderCreatedAt, createdAt.toIso8601String());
  }

  bool hasActiveOrder() => _prefs.getString(_keyActiveOrderId) != null;

  Future<void> clearActiveOrder() async {
    await _prefs.remove(_keyActiveOrderId);
    await _prefs.remove(_keyActiveOrderCreatedAt);
  }
}