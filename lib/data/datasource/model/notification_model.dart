class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.type,
  });

  factory NotificationModel.fromApiJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: dataMap['title']?.toString() ?? 'إشعار',
      body: dataMap['message']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['read_at'] != null,
      type: json['type']?.toString(),
    );
  }

  /// تخزين محلي (SharedPreferences).
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] == true,
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
        if (type != null) 'type': type,
      };

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}
