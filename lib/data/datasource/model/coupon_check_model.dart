enum CouponApplyRange {
  invoice,
  delivery;

  bool get isDelivery => this == CouponApplyRange.delivery;

  static CouponApplyRange fromValue(dynamic raw) {
    final value = raw?.toString().trim().toLowerCase();
    if (value == 'delivery') return CouponApplyRange.delivery;
    return CouponApplyRange.invoice;
  }
}

class CouponDetails {
  final String type;
  final double value;
  final CouponApplyRange applyRange;

  const CouponDetails({
    required this.type,
    required this.value,
    this.applyRange = CouponApplyRange.invoice,
  });

  bool get isPercent {
    final t = type.toLowerCase();
    return t == 'percent' || t == 'percentage';
  }

  bool get isFixed => type.toLowerCase() == 'fixed';

  bool get appliesToDelivery => applyRange.isDelivery;

  factory CouponDetails.fromJson(
    Map<String, dynamic>? json, {
    CouponApplyRange applyRange = CouponApplyRange.invoice,
  }) {
    if (json == null) {
      return CouponDetails(type: '', value: 0, applyRange: applyRange);
    }
    return CouponDetails(
      type: json['type']?.toString() ?? '',
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0.0,
      applyRange: json['apply_range'] != null
          ? CouponApplyRange.fromValue(json['apply_range'])
          : applyRange,
    );
  }
}

class CouponRestrictions {
  final List<int>? categories;
  final List<int>? stores;
  final List<int>? products;

  const CouponRestrictions({this.categories, this.stores, this.products});

  bool get appliesToWholeCart {
    final hasCategories = categories != null && categories!.isNotEmpty;
    final hasStores = stores != null && stores!.isNotEmpty;
    final hasProducts = products != null && products!.isNotEmpty;
    return !hasCategories && !hasStores && !hasProducts;
  }

  factory CouponRestrictions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CouponRestrictions();

    return CouponRestrictions(
      categories: _parseIntList(json['categories']),
      stores: _parseIntList(json['stores']),
      products: _parseIntList(json['products']),
    );
  }

  static List<int>? _parseIntList(dynamic raw) {
    if (raw == null) return null;
    if (raw is! List) return null;
    if (raw.isEmpty) return null;
    return raw
        .map((e) {
          if (e is int) return e;
          if (e is num) return e.toInt();
          return int.tryParse(e.toString());
        })
        .whereType<int>()
        .toList();
  }
}

class CouponCheckModel {
  final bool valid;
  final String? message;
  final CouponDetails details;
  final CouponRestrictions restrictions;

  const CouponCheckModel({
    required this.valid,
    this.message,
    required this.details,
    required this.restrictions,
  });

  factory CouponCheckModel.fromJson(Map<String, dynamic> json) {
    final detailsJson = json['details'] is Map<String, dynamic>
        ? json['details'] as Map<String, dynamic>
        : null;
    final applyRange = CouponApplyRange.fromValue(
      json['apply_range'] ?? detailsJson?['apply_range'],
    );

    return CouponCheckModel(
      valid: json['valid'] == true,
      message: json['message']?.toString(),
      details: CouponDetails.fromJson(detailsJson, applyRange: applyRange),
      restrictions: CouponRestrictions.fromJson(
        json['restrictions'] is Map<String, dynamic>
            ? json['restrictions'] as Map<String, dynamic>
            : null,
      ),
    );
  }
}
