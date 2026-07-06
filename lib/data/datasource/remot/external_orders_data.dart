import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/auth_headers.dart';
import 'package:app/data/datasource/model/external_order_model.dart';
import 'package:app/link_api.dart';

class ExternalOrdersData {
  final Crud crud;

  ExternalOrdersData(this.crud);

  Future<Object> createExternalOrder(Map<String, dynamic> payload) async {
    final headers = AuthHeaders.build();
    if (!headers.containsKey('Authorization')) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.postData(
      ApiLinks.externalOrders,
      payload,
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<Object> fetchExternalOrders() async {
    if (!AuthHeaders.hasToken) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.getData(
      ApiLinks.externalOrders,
      {},
      headers: AuthHeaders.build(),
    );

    return response.fold(
      (status) => status,
      (data) {
        if (data is! Map<String, dynamic>) {
          return StatusRequest.failure;
        }
        final rawList = data['data'];
        if (rawList is! List) {
          return StatusRequest.failure;
        }

        return rawList
            .whereType<Map>()
            .map(
              (item) => ExternalOrderModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .where((order) => order.id > 0)
            .toList();
      },
    );
  }
}
