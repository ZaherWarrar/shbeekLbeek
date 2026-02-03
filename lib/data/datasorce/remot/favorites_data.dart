import 'package:app/core/class/crud.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/link_api.dart';

class FavoritesData {
  Crud crud;
  UserPreferences userPreferences = UserPreferences();

  FavoritesData(this.crud);

  Future<Map<String, String>> _getHeaders() async {
    final token = await userPreferences.getToken();
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Future<Object> addFavoriteData(String type, int id) async {
    final headers = await _getHeaders();
    // إرسال الصيغتين: type/id للـ API البسيط، favoritable_type/favoritable_id لـ Laravel
    final body = <String, dynamic>{
      "type": type,
      "id": id,
      "favoritable_type": _toFavoritableType(type),
      "favoritable_id": id,
    };
    var response = await crud.postData(
      ApiLinks.addFavorite,
      body,
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }

  /// تحويل نوع المفضلة لصيغة Laravel (مثلاً App\Models\Product)
  static String _toFavoritableType(String type) {
    if (type == 'product') return 'App\\Models\\Product';
    if (type == 'category') return 'App\\Models\\Item';
    return type;
  }

  Future<Object> listFavoritesData() async {
    final headers = await _getHeaders();
    var response = await crud.getData(
      ApiLinks.addFavorite,
      {},
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<Object> removeFavoriteData(String type, int id) async {
    final headers = await _getHeaders();
    final uri = Uri.parse(
      ApiLinks.addFavorite,
    ).replace(queryParameters: {"type": type, "id": id.toString()});
    var response = await crud.deleteData(uri.toString(), headers: headers);
    return response.fold((l) => l, (r) => r);
  }
}
