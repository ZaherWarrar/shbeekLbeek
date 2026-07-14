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
    id = _toInt(json['id']);
    categoryId = _toInt(json['category_id']);
    storeId = _toInt(json['store_id']);
    name = json['name']?.toString();
    description = json['description']?.toString();
    imageFilePath = json['image_file_path']?.toString();
    regularPrice = _toPriceInt(json['regular_price']);
    salePrice = _toPriceInt(json['sale_price']);
    saleStart = _toInt(json['sale_start']);
    saleEnd = _toInt(json['sale_end']);
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static int? _toPriceInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    final d = double.tryParse(value.toString());
    if (d != null) return d.toInt();
    return int.tryParse(value.toString());
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