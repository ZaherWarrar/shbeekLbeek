import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class TopRatingData {
  Crud crud;

  TopRatingData(this.crud);

  Future<Object> topRatingData(int cityId) async {
    var response = await crud
        .getData("${ApiLinks.home}$cityId/top_rating", {});
    return response.fold((l) => l, (r) => r);
  }
}
