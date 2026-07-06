import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/auth_headers.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:app/link_api.dart';

class NotificationsData {
  NotificationsData(this.crud);

  final Crud crud;

  Future<Object> fetchNotifications() async {
    if (!AuthHeaders.hasToken) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.getData(
      ApiLinks.notifications,
      {},
      headers: AuthHeaders.build(),
    );

    return response.fold(
      (status) => status,
      (data) {
        if (data is! Map<String, dynamic>) {
          return StatusRequest.failure;
        }
        final rawList = data['notifications'];
        if (rawList is! List) {
          return StatusRequest.failure;
        }

        return rawList
            .whereType<Map>()
            .map(
              (item) => NotificationModel.fromApiJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .where((n) => n.id.isNotEmpty)
            .toList();
      },
    );
  }

  Future<Object> markAsRead(String id) async {
    if (!AuthHeaders.hasToken) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.postData(
      '${ApiLinks.notifications}/$id/mark-as-read',
      {},
      headers: AuthHeaders.build(),
    );

    return response.fold((status) => status, (data) => data);
  }

  Future<Object> markAllAsRead() async {
    if (!AuthHeaders.hasToken) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.postData(
      '${ApiLinks.notifications}/mark-all-as-read',
      {},
      headers: AuthHeaders.build(),
    );

    return response.fold((status) => status, (data) => data);
  }

  Future<Object> deleteNotification(String id) async {
    if (!AuthHeaders.hasToken) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.deleteData(
      '${ApiLinks.notifications}/$id',
      headers: AuthHeaders.build(),
    );

    return response.fold((status) => status, (data) => data);
  }
}
