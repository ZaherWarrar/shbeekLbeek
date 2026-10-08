import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsPreferences {
  static const _messageKey = 'settings_last_message';
  static const _versionKey = 'settings_update_prompt_version';

  late final SharedPreferences _prefs;

  Future<AppSettingsPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get lastMessage => _prefs.getString(_messageKey);

  Future<void> saveMessage(String message) =>
      _prefs.setString(_messageKey, message);

  String? get announcedAndroidVersion => _prefs.getString(_versionKey);

  Future<void> saveAnnouncedAndroidVersion(String version) =>
      _prefs.setString(_versionKey, version);
}
