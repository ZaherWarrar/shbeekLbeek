class TopOrderedModel {
  int? id;
  String? name;
  String? imageUrl;
  List<String>? categories;
  String? deliveryTime;
  int? ratingValue;
  int? ratingCount;

  TopOrderedModel(
      {this.id,
      this.name,
      this.imageUrl,
      this.categories,
      this.deliveryTime,
      this.ratingValue,
      this.ratingCount});

  TopOrderedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    categories = json['categories'].cast<String>();
    deliveryTime = json['delivery_time'];
    ratingValue = json['rating_value'];
    ratingCount = json['rating_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['categories'] = categories;
    data['delivery_time'] = deliveryTime;
    data['rating_value'] = ratingValue;
    data['rating_count'] = ratingCount;
    return data;
  }
}