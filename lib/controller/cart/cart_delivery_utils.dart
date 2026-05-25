double? parseDeliveryFee(dynamic raw) {
  if (raw == null) return null;
  if (raw is num) return raw.toDouble();
  final s = raw.toString().trim();
  if (s.isEmpty) return null;
  final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
  return double.tryParse(cleaned);
}

double? deriveDeliveryFeeFromCart(List<Map<String, dynamic>> cartItems) {
  double? fee;
  for (final item in cartItems) {
    final raw = item['deliveryFee'] ?? item['shopDeliveryFee'];
    final parsed = parseDeliveryFee(raw);
    if (parsed == null) continue;
    fee = fee == null ? parsed : (parsed > fee ? parsed : fee);
  }
  return fee;
}

double calculateSubtotal(List<Map<String, dynamic>> cartItems) {
  double total = 0.0;
  for (final item in cartItems) {
    final subtotalValue = item['subtotal'];
    if (subtotalValue is int) {
      total += subtotalValue.toDouble();
    } else if (subtotalValue is double) {
      total += subtotalValue;
    }
  }
  return total;
}

double calculateDiscount({
  required double subtotal,
  required String? discountCode,
  required double discountPercentage,
  required double discountAmount,
}) {
  if (discountCode == null || discountCode.isEmpty) return 0.0;
  if (discountPercentage > 0) {
    return subtotal * (discountPercentage / 100);
  }
  return discountAmount;
}

int parseItemQuantity(Map<String, dynamic> item) {
  final q = item['quantity'];
  if (q is int) return q;
  if (q is double) return q.toInt();
  return int.tryParse(q?.toString() ?? '') ?? 0;
}

int totalItemCount(List<Map<String, dynamic>> cartItems) {
  return cartItems.fold(0, (sum, item) => sum + parseItemQuantity(item));
}
