import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class CouponsData {
  Crud crud;

  CouponsData(this.crud);

  Future<Object> couponsData() async {
    var response = await crud
        .getData(ApiLinks.coupons, {});
    return response.fold((l) => l, (r) => r);
  }
  Future<Object> couponsCheckData(String code) async {
    var response = await crud
        .getData("${ApiLinks.couponCheck}/$code", {});
    return response.fold((l) => l, (r) => r);
  }
}
