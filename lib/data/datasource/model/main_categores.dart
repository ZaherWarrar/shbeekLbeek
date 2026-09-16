// ignore_for_file: prefer_collection_literals

import 'package:app/core/function/resolve_media_url.dart';

class MainCategoriesModel {
  int? id;
  String? name;
  String? imageUrl;

  MainCategoriesModel({this.id, this.name, this.imageUrl});

  MainCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    imageUrl = resolveMediaUrl(json['image_url']?.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    return data;
  }
}