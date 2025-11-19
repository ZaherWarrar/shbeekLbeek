import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class NewArrivalData {
  Crud crud;

  NewArrivalData(this.crud);

  Future<Object> newArrivalData(int cityId) async {
    var response = await crud
        .getData("${ApiLinks.home}$cityId/new_arrival", {});
    return response.fold((l) => l, (r) => r);
  }
}
