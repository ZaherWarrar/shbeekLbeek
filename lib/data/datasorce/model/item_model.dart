// ignore_for_file: prefer_collection_literals

class ItemModel {
  int? id;
  String? name;
  String? imageUrl;
  List<String>? categoryTree;
  String? deliveryTime;
  int? ratingValue;
  int? ratingCount;

  ItemModel(
      {this.id,
      this.name,
      this.imageUrl,
      this.categoryTree,
      this.deliveryTime,
      this.ratingValue,
      this.ratingCount});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    categoryTree = json['category_tree'].cast<String>();
    deliveryTime = json['delivery_time'];
    ratingValue = json['rating_value'];
    ratingCount = json['rating_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['category_tree'] = categoryTree;
    data['delivery_time'] = deliveryTime;
    data['rating_value'] = ratingValue;
    data['rating_count'] = ratingCount;
    return data;
  }
}