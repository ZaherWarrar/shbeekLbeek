import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class AllItemData {
  Crud crud;

  AllItemData(this.crud);

  Future<Object> allItemData(int cityId) async {
    var response = await crud
        .getData("${ApiLinks.home}$cityId/stores", {});
    return response.fold((l) => l, (r) => r);
  }
}
