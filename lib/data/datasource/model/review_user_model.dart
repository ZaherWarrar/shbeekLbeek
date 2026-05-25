class ReviewUserModel {
  int? id;
  String? name;
  String? avatarUrl;

  ReviewUserModel({this.id, this.name, this.avatarUrl});

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  ReviewUserModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    avatarUrl = (json['avatar_url'] ?? json['avatarUrl'])?.toString();
  }
}
