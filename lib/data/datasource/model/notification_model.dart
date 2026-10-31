import 'dart:convert';

class NotificationModel {
  static const Duration retention = Duration(days: 7);

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? type;

  /// الصفحة المرتبطة: order | product | store | cart | wallet | home
  final String? screen;
  final int? orderId;
  final int? productId;
  final int? storeId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.type,
    this.screen,
    this.orderId,
    this.productId,
    this.storeId,
  });

  bool get isExpired => DateTime.now().difference(createdAt) >= retention;

  bool get hasDestination {
    if (orderId != null || productId != null || storeId != null) return true;
    switch (screen) {
      case 'order':
      case 'product':
      case 'store':
      case 'cart':
      case 'wallet':
      case 'home':
        return true;
      default:
        return false;
    }
  }

  String? get destinationLabel {
    switch (screen) {
      case 'order':
        return 'عرض الطلب';
      case 'product':
        return 'عرض المنتج';
      case 'store':
        return 'عرض المتجر';
      case 'cart':
        return 'عرض السلة';
      case 'wallet':
        return 'عرض المحفظة';
      case 'home':
        return 'عرض الصفحة الرئيسية';
      default:
        if (orderId != null) return 'عرض الطلب';
        if (productId != null) return 'عرض المنتج';
        if (storeId != null) return 'عرض المتجر';
        return null;
    }
  }

  factory NotificationModel.fromApiJson(Map<String, dynamic> json) {
    final dataMap = _asMap(json['data']);
    final type = json['type']?.toString();
    final orderId = _toInt(dataMap['order_id'] ?? dataMap['orderId']);
    final productId = _toInt(dataMap['product_id'] ?? dataMap['productId']);
    final storeId = _toInt(dataMap['store_id'] ?? dataMap['storeId']);

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: dataMap['title']?.toString() ?? 'إشعار',
      body: dataMap['message']?.toString() ?? dataMap['body']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['read_at'] != null,
      type: type,
      screen: _screen(dataMap, type, orderId, productId, storeId),
      orderId: orderId,
      productId: productId,
      storeId: storeId,
    );
  }

  factory NotificationModel.fromPush({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    final dataMap = data ?? const <String, dynamic>{};
    final orderId = _toInt(dataMap['order_id'] ?? dataMap['orderId']);
    final productId = _toInt(dataMap['product_id'] ?? dataMap['productId']);
    final storeId = _toInt(dataMap['store_id'] ?? dataMap['storeId']);
    final resolvedTitle =
        title?.trim().isNotEmpty == true ? title!.trim() : dataMap['title']?.toString() ?? 'إشعار';
    final resolvedBody = body?.trim().isNotEmpty == true
        ? body!.trim()
        : dataMap['message']?.toString() ?? dataMap['body']?.toString() ?? '';
    final explicitId = dataMap['notification_id']?.toString().trim();
    final resolvedId = (explicitId != null && explicitId.isNotEmpty)
        ? explicitId
        : (id?.trim().isNotEmpty == true
            ? id!.trim()
            : DateTime.now().millisecondsSinceEpoch.toString());

    return NotificationModel(
      id: resolvedId,
      title: resolvedTitle,
      body: resolvedBody,
      createdAt: createdAt ?? DateTime.now(),
      type: dataMap['type']?.toString(),
      screen: _screen(dataMap, dataMap['type']?.toString(), orderId, productId, storeId),
      orderId: orderId,
      productId: productId,
      storeId: storeId,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] == true,
      type: json['type']?.toString(),
      screen: json['screen']?.toString(),
      orderId: _toInt(json['orderId']),
      productId: _toInt(json['productId']),
      storeId: _toInt(json['storeId']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
        if (type != null) 'type': type,
        if (screen != null) 'screen': screen,
        if (orderId != null) 'orderId': orderId,
        if (productId != null) 'productId': productId,
        if (storeId != null) 'storeId': storeId,
      };

  Map<String, dynamic> toPayload() => {
        'notification_id': id,
        'title': title,
        'message': body,
        if (screen != null) 'screen': screen,
        if (orderId != null) 'order_id': orderId,
        if (productId != null) 'product_id': productId,
        if (storeId != null) 'store_id': storeId,
      };

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? type,
    String? screen,
    int? orderId,
    int? productId,
    int? storeId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      screen: screen ?? this.screen,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
    );
  }

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return int.tryParse(text);
  }

  static String? _screen(
    Map<String, dynamic> data,
    String? type,
    int? orderId,
    int? productId,
    int? storeId,
  ) {
    final raw = (data['screen'] ?? data['target'] ?? data['route'])
        ?.toString()
        .trim()
        .toLowerCase();
    if (raw != null && raw.isNotEmpty && raw != 'null') {
      if (raw == 'shop' || raw == 'shops') return 'store';
      if (raw == 'orders') return 'order';
      if (raw == 'products') return 'product';
      return raw;
    }
    final hint = (type ?? '').toLowerCase();
    if (hint.contains('order')) return 'order';
    if (hint.contains('product')) return 'product';
    if (hint.contains('store') || hint.contains('shop')) return 'store';
    if (hint.contains('wallet')) return 'wallet';
    if (hint.contains('cart')) return 'cart';
    if (orderId != null) return 'order';
    if (productId != null) return 'product';
    if (storeId != null) return 'store';
    return null;
  }
}
