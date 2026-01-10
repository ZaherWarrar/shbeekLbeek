class ItemModel {
  int? id;
  int? parentId;
  String? name;
  int? cityId;
  int? minTotalToOrder;
  int? minTotalForFreeDeliver;
  String? description;
  String? imageFilePath;
  WorkSchedule? workSchedule;
  String? deliveryFee;
  String? createdAt;
  String? updatedAt;
  int? sortOrder;
  String? type;
  String? imageUrl;
  List<Products>? products;

  ItemModel(
      {this.id,
      this.parentId,
      this.name,
      this.cityId,
      this.minTotalToOrder,
      this.minTotalForFreeDeliver,
      this.description,
      this.imageFilePath,
      this.workSchedule,
      this.deliveryFee,
      this.createdAt,
      this.updatedAt,
      this.sortOrder,
      this.type,
      this.imageUrl,
      this.products});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    cityId = json['city_id'];
    minTotalToOrder = json['min_total_to_order'];
    minTotalForFreeDeliver = json['min_total_for_free_deliver'];
    description = json['description'];
    imageFilePath = json['image_file_path'];
    workSchedule = json['work_schedule'] != null
        ? WorkSchedule.fromJson(json['work_schedule'])
        : null;
    deliveryFee = json['delivery_fee'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sortOrder = json['sort_order'];
    type = json['type'];
    imageUrl = json['image_url'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['city_id'] = cityId;
    data['min_total_to_order'] = minTotalToOrder;
    data['min_total_for_free_deliver'] = minTotalForFreeDeliver;
    data['description'] = description;
    data['image_file_path'] = imageFilePath;
    if (workSchedule != null) {
      data['work_schedule'] = workSchedule!.toJson();
    }
    data['delivery_fee'] = deliveryFee;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sort_order'] = sortOrder;
    data['type'] = type;
    data['image_url'] = imageUrl;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkSchedule {
  Saturday? saturday;
  Saturday? sunday;
  Saturday? monday;
  Saturday? tuesday;
  Saturday? wednesday;
  Saturday? thursday;
  Saturday? friday;

  WorkSchedule(
      {this.saturday,
      this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday});

  WorkSchedule.fromJson(Map<String, dynamic> json) {
    saturday = json['Saturday'] != null
        ? Saturday.fromJson(json['Saturday'])
        : null;
    sunday =
        json['Sunday'] != null ? Saturday.fromJson(json['Sunday']) : null;
    monday =
        json['Monday'] != null ? Saturday.fromJson(json['Monday']) : null;
    tuesday =
        json['Tuesday'] != null ? Saturday.fromJson(json['Tuesday']) : null;
    wednesday = json['Wednesday'] != null
        ? Saturday.fromJson(json['Wednesday'])
        : null;
    thursday = json['Thursday'] != null
        ? Saturday.fromJson(json['Thursday'])
        : null;
    friday =
        json['Friday'] != null ? Saturday.fromJson(json['Friday']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (saturday != null) {
      data['Saturday'] = saturday!.toJson();
    }
    if (sunday != null) {
      data['Sunday'] = sunday!.toJson();
    }
    if (monday != null) {
      data['Monday'] = monday!.toJson();
    }
    if (tuesday != null) {
      data['Tuesday'] = tuesday!.toJson();
    }
    if (wednesday != null) {
      data['Wednesday'] = wednesday!.toJson();
    }
    if (thursday != null) {
      data['Thursday'] = thursday!.toJson();
    }
    if (friday != null) {
      data['Friday'] = friday!.toJson();
    }
    return data;
  }
}

class Saturday {
  String? start;
  String? end;

  Saturday({this.start, this.end});

  Saturday.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}

class Products {
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

  Products(
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

  Products.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
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