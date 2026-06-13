import 'package:app/core/services/address_preferences.dart';
import 'package:app/data/datasource/remot/reverse_geocoding_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../data/datasource/model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final ReverseGeocodingData _reverseGeocoding = ReverseGeocodingData();
  int _geocodeSeq = 0;

  late AddressPreferences _prefs;

  final selectedLat = 0.0.obs;
  final selectedLng = 0.0.obs;

  // حقول المدينة والعنوان الكامل
  final cityName = ''.obs;
  final fullAddress = ''.obs;
  final isLoadingAddress = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    // 🔥 تهيئة SharedPreferences قبل أي استخدام
    _prefs = await AddressPreferences().init();

    // 🔥 الآن آمن تحميل العناوين
    loadAddresses();
    // الحصول على الموقع الحالي عند فتح الصفحة
    _initializeLocation();
  }

  // تهيئة الموقع عند بدء التطبيق (بدون طلب إذن تلقائي)
  Future<void> _initializeLocation() async {
    if (selectedLat.value != 0.0 && selectedLng.value != 0.0) return;
    _setDefaultLocation();
  }

  /// فتح الخريطة على الموقع الحالي (يُستدعى عند فتح صفحة إضافة عنوان).
  Future<bool> centerOnCurrentLocationForMap({
    bool showSuccessSnackbar = false,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('تنبيه', 'يرجى تفعيل خدمة الموقع');
        _setDefaultLocation();
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('تنبيه', 'تم رفض إذن الموقع');
          _setDefaultLocation();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('تنبيه', 'إذن الموقع مرفوض بشكل دائم');
        _setDefaultLocation();
        return false;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await setLocation(pos.latitude, pos.longitude);

      if (showSuccessSnackbar) {
        Get.snackbar('نجاح', 'تم تحديد الموقع بنجاح');
      }
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر الحصول على الموقع الحالي');
      _setDefaultLocation();
      return false;
    }
  }

  // تعيين الموقع الافتراضي
  void _setDefaultLocation() {
    try {
      if (addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => addresses.first,
        );
        setLocation(defaultAddress.lat, defaultAddress.lng);
        // استخراج المدينة من الوصف
        final parts = defaultAddress.description.split(',');
        if (parts.isNotEmpty) {
          cityName.value = parts.first.trim();
        }
        fullAddress.value = defaultAddress.description;
      } else {
        // استخدام دمشق كبديل افتراضي
        setLocation(33.5138, 36.2765);
        _getAddressFromCoordinates(33.5138, 36.2765);
      }
    } catch (e) {
      // في حالة عدم وجود عناوين، نستخدم دمشق
      setLocation(33.5138, 36.2765);
      _getAddressFromCoordinates(33.5138, 36.2765);
    }
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

  // تحديث الموقع والحصول على العنوان
  Future<void> setLocation(double lat, double lng) async {
    selectedLat.value = lat;
    selectedLng.value = lng;
    // الحصول على العنوان من الإحداثيات
    await _getAddressFromCoordinates(lat, lng);
  }

  // الحصول على العنوان من الإحداثيات (جهاز + OSM احتياطاً)
  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    final seq = ++_geocodeSeq;
    isLoadingAddress.value = true;
    try {
      final resolved = await _reverseGeocoding.resolve(lat, lng);
      if (seq != _geocodeSeq) return;

      cityName.value = resolved.city;
      fullAddress.value = resolved.fullAddress;

      if (resolved.city.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لم يتم التعرف على المدينة — يمكنك تعديل الحقل يدوياً',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (seq != _geocodeSeq) return;
      cityName.value = '';
      fullAddress.value = 'فشل في الحصول على العنوان';
      Get.snackbar(
        'تنبيه',
        'فشل في الحصول على العنوان من الموقع',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      if (seq == _geocodeSeq) {
        isLoadingAddress.value = false;
      }
    }
  }

  // الحصول على الموقع (زر الخريطة)
  Future<void> getCurrentLocation() async {
    await centerOnCurrentLocationForMap(showSuccessSnackbar: true);
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