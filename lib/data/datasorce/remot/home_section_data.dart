import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class HomeSectionData {
  Crud crud;

  HomeSectionData(this.crud);

  Future<Object> homeSectionData() async {
    var response = await crud
        .getData("${ApiLinks.baseUrl}/home_sections", {});
    return response.fold((l) => l, (r) => r);
  }
  Future<Object> sectionData(int cityId, String sectionName, {int? categoryId}) async {
    var response = await crud.getData(
      categoryId == null
          ? "${ApiLinks.home}$cityId/section_products/$sectionName"
          : "${ApiLinks.home}$cityId/section_products/$sectionName/$categoryId",
      {},
    );
    return response.fold((l) => l, (r) => r);
  }
}
