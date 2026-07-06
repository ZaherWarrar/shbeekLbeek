import 'package:app/core/class/crud.dart';
import 'package:app/core/function/auth_headers.dart';
import 'package:app/link_api.dart';

class CouponsData {
  final Crud crud;

  CouponsData(this.crud);

  Future<Object> couponsData() async {
    var response = await crud.getData(
      ApiLinks.coupons,
      {},
      headers: AuthHeaders.build(),
    );
    return response.fold((l) => l, (r) => r);
  }

  /// GET /api/coupons/check/{coupon_code}
  Future<Object> couponsCheckData(String code) async {
    final url = '${ApiLinks.couponCheck}$code';
    var response = await crud.getData(
      url,
      {},
      headers: AuthHeaders.build(),
    );
    return response.fold((l) => l, (r) => r);
  }
}
