import 'package:app/core/services/shaerd_preferances.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final UserPreferences _prefs = UserPreferences();

  final selectedLat = 0.0.obs;
  final selectedLng = 0.0.obs;

  // حقول المدينة والعنوان الكامل
  final cityName = ''.obs;
  final fullAddress = ''.obs;
  final isLoadingAddress = false.obs;

  @override
  void onInit() {
    super.onInit();
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

      // تحديث الإحداثيات والحصول على العنوان
      await setLocation(position.latitude, position.longitude);

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
