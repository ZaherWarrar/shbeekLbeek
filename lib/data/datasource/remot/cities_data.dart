import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class CitiesData {
  final Crud crud;

  CitiesData(this.crud);

  Future<Object> fetchCities() async {
    final response = await crud.getData(ApiLinks.cities, {});
    return response.fold((l) => l, (r) => r);
  }
}
