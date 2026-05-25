import 'package:app/core/services/address_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../../data/datasource/model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;

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

  // تهيئة الموقع عند فتح الصفحة
  Future<void> _initializeLocation() async {
    // محاولة الحصول على الموقع الحالي
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          await getCurrentLocation();
          return;
        }
      }
    } catch (e) {
      // في حالة الفشل، نستخدم العنوان الافتراضي أو دمشق
    }
    // في حالة عدم توفر الموقع الحالي، نستخدم العنوان الافتراضي أو دمشق
    _setDefaultLocation();
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

  // الحصول على العنوان من الإحداثيات (Reverse Geocoding)
  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    isLoadingAddress.value = true;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // استخراج المدينة
        String city =
            place.locality ??
            place.administrativeArea ??
            place.subAdministrativeArea ??
            '';

        // بناء العنوان الكامل
        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.subThoroughfare != null &&
            place.subThoroughfare!.isNotEmpty) {
          addressParts.add(place.subThoroughfare!);
        }
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          addressParts.add(place.thoroughfare!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (city.isNotEmpty) {
          addressParts.add(city);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        cityName.value = city;
        fullAddress.value = addressParts.isNotEmpty
            ? addressParts.join(', ')
            : 'عنوان غير محدد';
      } else {
        cityName.value = '';
        fullAddress.value = 'عنوان غير محدد';
      }
    } catch (e) {
      cityName.value = '';
      fullAddress.value = 'فشل في الحصول على العنوان';
      Get.snackbar(
        'تنبيه',
        'فشل في الحصول على العنوان من الموقع',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoadingAddress.value = false;
    }
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
        // ignore: deprecated_member_use
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