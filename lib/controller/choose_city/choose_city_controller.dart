import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCityController extends GetxController {
  static const String _keyId = 'selected_city_id';
  static const String _keyName = 'selected_city_name';

  final RxnInt selectedCityId = RxnInt();
  final RxnString selectedCityName = RxnString();

  SharedPreferences? _prefs;

  //========اختبار اذا كانت مخزنة أو لأ =====
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    selectedCityId.value = _prefs!.getInt(_keyId);
    selectedCityName.value = _prefs!.getString(_keyName);
  }

  //======حفظ في الذاكرة ======
  Future<void> selectCity({required int id, required String name}) async {
    selectedCityId.value = id;
    selectedCityName.value = name;
  }

  //==========حذف من الذاكرة =====
  Future<void> clearSelection() async {
    selectedCityId.value = null;
    selectedCityName.value = null;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_keyId);
    await _prefs!.remove(_keyName);
  }

  //=====فحص اذا كان في خيار محفوظ======
  bool get hasSelected => selectedCityId.value != null;

}
