import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/link_api.dart';
import 'package:get/get.dart';

class StoreReviewsData {
  final Crud crud;
  final SessionService session = Get.find<SessionService>();

  StoreReviewsData(this.crud);

  Map<String, String> _getHeaders({bool requireAuth = false}) {
    final token = session.token;
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    } else if (requireAuth) {
      // caller will handle unauthorized
    }
    return headers;
  }

  Future<Object> fetchStoreReviews(int storeId) async {
    final url = "${ApiLinks.storeReviews}/$storeId";
    final response = await crud.getData(url, {}, headers: _getHeaders());
    return response.fold((l) => l, (r) => r);
  }

  Future<Object> createReview({
    required int storeId,
    required int rating,
    String? text,
  }) async {
    final headers = _getHeaders(requireAuth: true);
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }
    final body = <String, dynamic>{
      "store_id": storeId,
      "rating": rating,
      "text": text,
    };
    final response = await crud.postData(
      ApiLinks.storeReviews,
      body,
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }
}

