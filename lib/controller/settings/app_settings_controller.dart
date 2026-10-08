import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/app_snackbar.dart';
import 'package:app/core/function/app_version.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/app_settings_preferences.dart';
import 'package:app/data/datasource/model/app_settings_model.dart';
import 'package:app/data/datasource/remot/settings_data.dart';
import 'package:app/view/settings/app_settings_notice_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSettingsController extends GetxController {
  final SettingsData _data = SettingsData(Get.find());
  final AppSettingsPreferences _prefs = AppSettingsPreferences();

  AppSettingsModel settings = const AppSettingsModel();
  bool settingsLoaded = false;
  Future<void>? _loadingSettings;

  List<String> get contactNumbers {
    final numbers = <String>[];
    for (final raw in [settings.contactNum1, settings.contactNum2]) {
      final number = raw.trim();
      if (number.isEmpty || number == '0') continue;
      numbers.add(number);
    }
    return numbers;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkOnLaunch();
    });
  }

  Future<void> loadSettings() {
    final current = _loadingSettings;
    if (current != null) return current;

    final future = _fetchSettings();
    _loadingSettings = future;
    return future.whenComplete(() => _loadingSettings = null);
  }

  Future<void> _fetchSettings() async {
    final response = await _data.fetchSettings();
    if (handlingData(response) == StatusRequest.success && response is Map) {
      settings = AppSettingsModel.fromJson(Map<String, dynamic>.from(response));
    }
    settingsLoaded = true;
    update();
  }

  Future<void> callNumber(String number) async {
    final cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return;

    try {
      final opened = await launchUrl(Uri.parse('tel:$cleaned'));
      if (!opened) {
        AppSnackbar.show('تنبيه', 'تعذر فتح تطبيق الاتصال');
      }
    } catch (_) {
      AppSnackbar.show('تنبيه', 'تعذر فتح تطبيق الاتصال');
    }
  }

  Future<void> checkOnLaunch() async {
    await _prefs.init();
    await loadSettings();
    await _showMessageIfChanged(settings.message);
    await _showUpdateIfVersionChanged(settings.androidVersion);
  }

  Future<void> _showMessageIfChanged(String rawMessage) async {
    final message = _normalizeMessage(rawMessage);
    if (message.isEmpty || message == '0') return;

    final previous = _prefs.lastMessage;
    if (previous != null && _normalizeMessage(previous) == message) return;

    await Get.dialog<void>(
      AppSettingsNoticeDialog(title: 'رسالة', message: message),
      barrierDismissible: true,
    );
    await _prefs.saveMessage(message);
  }

  Future<void> _showUpdateIfVersionChanged(String rawVersion) async {
    final remote = rawVersion.trim();
    if (remote.isEmpty || remote == '0') return;

    final local = (await PackageInfo.fromPlatform()).version.trim();
    if (!isNewerVersion(remote, local)) return;

    final announced = _prefs.announcedAndroidVersion;
    if (announced != null && isSameVersion(announced, remote)) return;

    await Get.dialog<void>(
      AppSettingsNoticeDialog(
        title: 'تحديث جديد',
        message: 'يتوفر تحديث جديد للتطبيق.\nالإصدار المتاح: $remote',
        actionLabel: 'تحديث',
        onAction: () => openAppUpdate(remote),
      ),
      barrierDismissible: true,
    );
    await _prefs.saveAnnouncedAndroidVersion(remote);
  }

  Future<void> openAppUpdate(String version) async {
    final remote = version.trim();
    if (remote.isEmpty) return;

    final url = Uri.parse(
      'https://shbeeklbeek.com/download/shbeeklbeek$remote.apk',
    );

    try {
      final opened = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        AppSnackbar.show('تنبيه', 'تعذر فتح رابط التحديث');
        return;
      }
      if (Get.isDialogOpen ?? false) Get.back();
    } catch (_) {
      AppSnackbar.show('تنبيه', 'تعذر فتح رابط التحديث');
    }
  }

  String _normalizeMessage(String value) {
    return value.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();
  }
}
