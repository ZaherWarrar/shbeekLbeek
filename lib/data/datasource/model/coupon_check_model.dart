class CouponDetails {
  final String type;
  final double value;

  const CouponDetails({required this.type, required this.value});

  bool get isPercent {
    final t = type.toLowerCase();
    return t == 'percent' || t == 'percentage';
  }

  bool get isFixed => type.toLowerCase() == 'fixed';

  factory CouponDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CouponDetails(type: '', value: 0);
    }
    return CouponDetails(
      type: json['type']?.toString() ?? '',
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0.0,
    );
  }
}

class CouponRestrictions {
  final List<int>? categories;
  final List<int>? stores;
  final List<int>? products;

  const CouponRestrictions({
    this.categories,
    this.stores,
    this.products,
  });

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
    return CouponCheckModel(
      valid: json['valid'] == true,
      message: json['message']?.toString(),
      details: CouponDetails.fromJson(
        json['details'] is Map<String, dynamic>
            ? json['details'] as Map<String, dynamic>
            : null,
      ),
      restrictions: CouponRestrictions.fromJson(
        json['restrictions'] is Map<String, dynamic>
            ? json['restrictions'] as Map<String, dynamic>
            : null,
      ),
    );
  }
}
