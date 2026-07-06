import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/model/city_model.dart';
import 'package:app/data/datasource/remot/cities_data.dart';
import 'package:get/get.dart';

class ChooseCityController extends GetxController {
  final session = Get.find<SessionService>();
  final CitiesData _citiesData = CitiesData(Get.find<Crud>());

  final RxnInt selectedCityId = RxnInt();
  final RxnString selectedCityName = RxnString();
  final isSelectingCity = false.obs;

  StatusRequest citiesStatus = StatusRequest.none;
  List<CityModel> cities = [];

  @override
  void onInit() {
    selectedCityId.value = session.cityId;
    selectedCityName.value = session.cityName;
    super.onInit();
    _initCities();
  }

  Future<void> _initCities() async {
    await fetchCities();
    await _autoSelectIfSingleCity();
  }

  Future<void> fetchCities() async {
    citiesStatus = StatusRequest.loading;
    update();

    final response = await _citiesData.fetchCities();
    citiesStatus = handlingData(response);

    if (citiesStatus == StatusRequest.success) {
      cities = _parseCities(response);
      if (cities.isEmpty) {
        citiesStatus = StatusRequest.failure;
      }
    } else {
      cities = [];
    }

    update();
  }

  List<CityModel> _parseCities(Object response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => CityModel.fromJson(Map<String, dynamic>.from(item)))
          .where((city) => city.id > 0 && city.name.isNotEmpty)
          .toList();
    }

    if (response is Map<String, dynamic>) {
      final data = response['data'] ?? response['cities'];
      if (data is List) {
        return _parseCities(data);
      }
    }

    return [];
  }

  Future<void> _autoSelectIfSingleCity() async {
    if (cities.length != 1) return;

    final city = cities.first;
    await selectCityAndGo(id: city.id, name: city.name);
  }

  Future<void> selectCity({
    required int id,
    required String name,
  }) async {
    selectedCityId.value = id;
    selectedCityName.value = name;
    await session.saveCity(id, name);
  }

  Future<void> selectCityAndGo({
    required int id,
    required String name,
  }) async {
    if (isSelectingCity.value) return;
    isSelectingCity.value = true;
    update();
    try {
      await selectCity(id: id, name: name);
      if (Get.isRegistered<HomeControllerImp>()) {
        final home = Get.find<HomeControllerImp>();
        await Future.wait([
          home.fetchSliders(),
          home.fetchMainCategores(),
          home.fetchAllItem(),
          home.fetchHomeSection(),
        ]);
      }
      Get.offAllNamed(AppRoutes.start);
    } finally {
      isSelectingCity.value = false;
      update();
    }
  }

  Future<void> clearSelection() async {
    selectedCityId.value = null;
    selectedCityName.value = null;
    await session.clearCity();
  }

  bool get hasSelected => selectedCityId.value != null;

  bool get shouldShowCityList =>
      citiesStatus == StatusRequest.success && cities.length > 1;

  bool get isBootstrapping =>
      citiesStatus == StatusRequest.loading ||
      isSelectingCity.value ||
      (citiesStatus == StatusRequest.success && cities.length == 1);
}
