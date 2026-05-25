// ignore_for_file: prefer_collection_literals

class MainCategoriesModel {
  int? id;
  String? name;
  String? imageUrl;

  MainCategoriesModel({this.id, this.name, this.imageUrl});

  MainCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    return data;
  }
}