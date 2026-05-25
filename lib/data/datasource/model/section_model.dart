// ignore_for_file: prefer_collection_literals

class SectionModel {
  int? id;
  int? categoryId;
  int? storeId;
  String? name;
  String? description;
  String? imageFilePath;
  int? regularPrice;
  int? salePrice;
  int? saleStart;
  int? saleEnd;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  SectionModel(
      {this.id,
      this.categoryId,
      this.storeId,
      this.name,
      this.description,
      this.imageFilePath,
      this.regularPrice,
      this.salePrice,
      this.saleStart,
      this.saleEnd,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  SectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    storeId = json['store_id'];
    name = json['name'];
    description = json['description'];
    imageFilePath = json['image_file_path'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    saleStart = json['sale_start'];
    saleEnd = json['sale_end'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['category_id'] = categoryId;
    data['store_id'] = storeId;
    data['name'] = name;
    data['description'] = description;
    data['image_file_path'] = imageFilePath;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['sale_start'] = saleStart;
    data['sale_end'] = saleEnd;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}