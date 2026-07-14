class SliderModel {
  int? id;
  String? title;
  String? targetType;
  int? targetId;
  String? imageFilePath;
  String? imageUrl;

  SliderModel({
    this.id,
    this.title,
    this.targetType,
    this.targetId,
    this.imageFilePath,
    this.imageUrl,
  });

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    title = json['title']?.toString();
    targetType = json['target_type']?.toString();
    targetId = _toInt(json['target_id']);
    imageFilePath = json['image_file_path']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['target_type'] = targetType;
    data['target_id'] = targetId;
    data['image_file_path'] = imageFilePath;
    data['image_url'] = imageUrl;
    return data;
  }
}
