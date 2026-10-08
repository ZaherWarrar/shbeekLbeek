import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class SettingsData {
  SettingsData(this.crud);

  final Crud crud;

  Future<Object> fetchSettings() async {
    final response = await crud.getData(ApiLinks.settings, {});
    return response.fold((l) => l, (r) => r);
  }
}
