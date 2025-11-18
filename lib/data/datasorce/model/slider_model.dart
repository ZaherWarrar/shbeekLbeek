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
    id = json['id'];
    title = json['title'];
    targetType = json['target_type'];
    targetId = json['target_id'];
    imageFilePath = json['image_file_path'];
    imageUrl = json['image_url'];
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
