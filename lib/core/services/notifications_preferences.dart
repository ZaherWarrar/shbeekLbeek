import 'dart:convert';

import 'package:app/data/datasource/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPreferences {
  static const String _key = 'app_notifications';

  late SharedPreferences _prefs;

  Future<NotificationsPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  List<NotificationModel> getNotifications() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveNotifications(List<NotificationModel> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }

  Future<void> addNotification({
    required String title,
    required String body,
  }) async {
    final items = getNotifications();
    items.insert(
      0,
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
    await saveNotifications(items);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_key);
  }
}
