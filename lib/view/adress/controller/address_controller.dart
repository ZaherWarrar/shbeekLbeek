import 'package:app/core/services/address_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;

  late AddressPreferences _prefs;

  final selectedLat = 0.0.obs;
  final selectedLng = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    // 🔥 تهيئة SharedPreferences قبل أي استخدام
    _prefs = await AddressPreferences().init();

    // 🔥 الآن آمن تحميل العناوين
    loadAddresses();
  }

  // تحميل العناوين
  void loadAddresses() {
    final list = _prefs.getAddresses();
    addresses.value =
        list.map((json) => AddressModel.fromJson(json)).toList();
  }

  // حفظ العناوين
  Future<void> _saveAddresses() async {
    final jsonList = addresses.map((e) => e.toJson()).toList();
    await _prefs.saveAddresses(jsonList);
  }

  void setLocation(double lat, double lng) {
    selectedLat.value = lat;
    selectedLng.value = lng;
  }

  // الحصول على الموقع
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('تنبيه', 'يرجى تفعيل خدمة الموقع');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('تنبيه', 'تم رفض إذن الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('تنبيه', 'تم رفض إذن الموقع بشكل دائم');
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setLocation(pos.latitude, pos.longitude);

      Get.snackbar('نجاح', 'تم تحديد الموقع بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ: ${e.toString()}');
    }
  }

  // إضافة عنوان
  Future<void> addAddress(AddressModel address) async {
    addresses.add(address);
    await _saveAddresses();
  }

  // حذف عنوان
  Future<void> deleteAddress(String id) async {
    addresses.removeWhere((a) => a.id == id);
    await _saveAddresses();
  }

  // تحديث عنوان
  Future<void> updateAddress(AddressModel updated) async {
    final index = addresses.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      addresses[index] = updated;
      await _saveAddresses();
    }
  }

  // تعيين عنوان افتراضي
  Future<void> setDefaultAddress(String id) async {
    // إزالة الافتراضي من الجميع
    for (var a in addresses) {
      if (a.id != id && a.isDefault) {
        final updated = AddressModel(
          id: a.id,
          title: a.title,
          description: a.description,
          lat: a.lat,
          lng: a.lng,
          isDefault: false,
        );
        addresses[addresses.indexWhere((x) => x.id == a.id)] = updated;
      }
    }

    // تعيين الافتراضي
    final index = addresses.indexWhere((a) => a.id == id);
    if (index != -1) {
      final a = addresses[index];
      final updated = AddressModel(
        id: a.id,
        title: a.title,
        description: a.description,
        lat: a.lat,
        lng: a.lng,
        isDefault: true,
      );
      addresses[index] = updated;
      await _saveAddresses();
    }
  }
}