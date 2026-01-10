import 'package:app/core/services/shaerd_preferances.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final UserPreferences _prefs = UserPreferences();

  final selectedLat = 0.0.obs;
  final selectedLng = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  // تحميل العناوين من SharedPreferences
  void loadAddresses() {
    final addressesList = _prefs.getAddresses();
    addresses.value = addressesList
        .map((json) => AddressModel.fromJson(json))
        .toList();
  }

  // حفظ العناوين في SharedPreferences
  Future<void> _saveAddresses() async {
    final addressesJson = addresses.map((address) => address.toJson()).toList();
    await _prefs.saveAddresses(addressesJson);
  }

  void setLocation(double lat, double lng) {
    selectedLat.value = lat;
    selectedLng.value = lng;
  }

  // الحصول على الموقع الحالي
  Future<void> getCurrentLocation() async {
    try {
      // التحقق من تفعيل خدمة الموقع
      bool serviceEnabled;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        // في حالة MissingPluginException، نعرض رسالة واضحة
        Get.snackbar(
          'تنبيه',
          'يرجى إعادة بناء التطبيق (flutter clean && flutter pub get && flutter run)',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      if (!serviceEnabled) {
        Get.snackbar(
          'تنبيه',
          'خدمة الموقع غير مفعّلة. يرجى تفعيلها من الإعدادات.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'تنبيه',
            'تم رفض أذونات الموقع. يرجى السماح بالوصول للموقع.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'تنبيه',
          'تم رفض أذونات الموقع بشكل دائم. يرجى تفعيلها من إعدادات التطبيق.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // تحديث الإحداثيات
      setLocation(position.latitude, position.longitude);

      Get.snackbar(
        'نجاح',
        'تم الحصول على الموقع الحالي بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      String errorMessage = 'حدث خطأ أثناء الحصول على الموقع';

      if (e.toString().contains('MissingPluginException')) {
        errorMessage =
            'يرجى إعادة بناء التطبيق:\nflutter clean\nflutter pub get\nflutter run';
      } else {
        errorMessage = 'حدث خطأ: ${e.toString()}';
      }

      Get.snackbar(
        'خطأ',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // إضافة عنوان جديد
  Future<void> addAddress(AddressModel address) async {
    addresses.add(address);
    await _saveAddresses();
  }

  // حذف عنوان
  Future<void> deleteAddress(String addressId) async {
    addresses.removeWhere((address) => address.id == addressId);
    await _saveAddresses();
  }

  // تحديث عنوان
  Future<void> updateAddress(AddressModel updatedAddress) async {
    final index = addresses.indexWhere(
      (address) => address.id == updatedAddress.id,
    );
    if (index != -1) {
      addresses[index] = updatedAddress;
      await _saveAddresses();
    }
  }

  // تعيين عنوان كافتراضي
  Future<void> setDefaultAddress(String addressId) async {
    // إلغاء الافتراضي من جميع العناوين
    for (var address in addresses) {
      if (address.id != addressId && address.isDefault) {
        final updatedAddress = AddressModel(
          id: address.id,
          title: address.title,
          description: address.description,
          lat: address.lat,
          lng: address.lng,
          isDefault: false,
        );
        final index = addresses.indexWhere((a) => a.id == address.id);
        if (index != -1) {
          addresses[index] = updatedAddress;
        }
      }
    }

    // تعيين العنوان المحدد كافتراضي
    final index = addresses.indexWhere((address) => address.id == addressId);
    if (index != -1) {
      final address = addresses[index];
      final updatedAddress = AddressModel(
        id: address.id,
        title: address.title,
        description: address.description,
        lat: address.lat,
        lng: address.lng,
        isDefault: true,
      );
      addresses[index] = updatedAddress;
      await _saveAddresses();
    }
  }
}
