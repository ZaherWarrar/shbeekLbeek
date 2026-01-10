// ignore_for_file: prefer_collection_literals

class HomeSectionModel {
  int? id;
  String? name;
  String? type;

  HomeSectionModel({this.id, this.name, this.type});

  HomeSectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}