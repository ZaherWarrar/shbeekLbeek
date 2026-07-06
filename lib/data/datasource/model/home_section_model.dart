// ignore_for_file: prefer_collection_literals

class HomeSectionModel {
  int? id;
  String? name;
  String? type;

  HomeSectionModel({this.id, this.name, this.type});

  HomeSectionModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    type = json['type']?.toString();
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
    data['type'] = type;
    return data;
  }
}