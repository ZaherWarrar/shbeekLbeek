import 'dart:convert';

import 'package:app/data/datasource/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPreferences {
  static const String _itemsKey = 'app_notifications';
  static const String _deletedKey = 'app_notifications_deleted';

  static Future<List<NotificationModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    await _prune(prefs);
    final deleted = _deletedIds(prefs);
    return _readItems(prefs)
        .where((item) => item.id.isNotEmpty && !deleted.contains(item.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> saveAll(List<NotificationModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = _deletedIds(prefs);
    final fresh = items
        .where(
          (item) =>
              item.id.isNotEmpty &&
              !item.isExpired &&
              !deleted.contains(item.id),
        )
        .toList();
    await prefs.setString(
      _itemsKey,
      jsonEncode(fresh.map((item) => item.toJson()).toList()),
    );
  }

  static Future<void> upsert(NotificationModel item) async {
    if (item.id.isEmpty || item.isExpired) return;
    final prefs = await SharedPreferences.getInstance();
    if (_deletedIds(prefs).contains(item.id)) return;
    final items = _readItems(prefs).where((current) => current.id != item.id).toList();
    items.insert(0, item);
    await prefs.setString(
      _itemsKey,
      jsonEncode(items.where((current) => !current.isExpired).map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> markDeleted(String id) async {
    if (id.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final items = _readItems(prefs).where((item) => item.id != id).toList();
    await prefs.setString(
      _itemsKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
    final deleted = _readDeleted(prefs).where((entry) => entry.id != id).toList()
      ..add(_DeletedNotification(id, DateTime.now()));
    await prefs.setString(
      _deletedKey,
      jsonEncode(deleted.map((entry) => entry.toJson()).toList()),
    );
  }

  static Future<bool> isDeleted(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return _deletedIds(prefs).contains(id);
  }

  static Future<void> restore(NotificationModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = _readDeleted(prefs).where((entry) => entry.id != item.id).toList();
    await prefs.setString(
      _deletedKey,
      jsonEncode(deleted.map((entry) => entry.toJson()).toList()),
    );
    await upsert(item);
  }

  static Future<void> _prune(SharedPreferences prefs) async {
    final items = _readItems(prefs).where((item) => !item.isExpired).toList();
    await prefs.setString(
      _itemsKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
    final deleted = _readDeleted(prefs).where((entry) => !entry.isExpired).toList();
    await prefs.setString(
      _deletedKey,
      jsonEncode(deleted.map((entry) => entry.toJson()).toList()),
    );
  }

  static List<NotificationModel> _readItems(SharedPreferences prefs) {
    final raw = prefs.getString(_itemsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return [];
      return list
          .whereType<Map>()
          .map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Set<String> _deletedIds(SharedPreferences prefs) {
    return _readDeleted(prefs).map((entry) => entry.id).toSet();
  }

  static List<_DeletedNotification> _readDeleted(SharedPreferences prefs) {
    final raw = prefs.getString(_deletedKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return [];
      return list
          .whereType<Map>()
          .map((item) => _DeletedNotification.fromJson(Map<String, dynamic>.from(item)))
          .where((entry) => entry.id.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }
}

class _DeletedNotification {
  _DeletedNotification(this.id, this.deletedAt);

  final String id;
  final DateTime deletedAt;

  bool get isExpired =>
      DateTime.now().difference(deletedAt) >= NotificationModel.retention;

  Map<String, dynamic> toJson() => {
        'id': id,
        'deletedAt': deletedAt.toIso8601String(),
      };

  factory _DeletedNotification.fromJson(Map<String, dynamic> json) {
    return _DeletedNotification(
      json['id']?.toString() ?? '',
      DateTime.tryParse(json['deletedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
