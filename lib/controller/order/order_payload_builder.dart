import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/constant/payment_method.dart';
import 'package:get/get.dart';

/// جسم POST /api/order:
/// apply_coupon، cart.items (product.id, quantity, variation_name, notes)،
/// latitude، longitude، address، address_description، notes، payment_method.
Map<String, dynamic> buildOrderPayload({
  required CartController cart,
  String? notes,
}) {
  final items = <Map<String, dynamic>>[];
  for (final item in cart.cartItems) {
    final productId = _asInt(item['productId']);
    final quantity = _asInt(item['quantity']);
    if (productId == null || productId <= 0) continue;
    if (quantity == null || quantity <= 0) continue;

    final row = <String, dynamic>{
      'product': {'id': productId},
      'quantity': quantity,
    };

    final variation = item['variationName']?.toString().trim();
    if (variation != null && variation.isNotEmpty) {
      row['variation_name'] = variation;
    }
    final itemNotes = item['itemNotes']?.toString().trim();
    if (itemNotes != null && itemNotes.isNotEmpty) {
      row['notes'] = itemNotes;
    }
    items.add(row);
  }

  final addressController = Get.find<AddressController>();
  final checkoutAddress = cart.checkoutAddress;
  final latitude = checkoutAddress?.lat ?? addressController.selectedLat.value;
  final longitude = checkoutAddress?.lng ?? addressController.selectedLng.value;

  final payload = <String, dynamic>{
    'cart': {'items': items},
    'latitude': latitude,
    'longitude': longitude,
    'payment_method': PaymentMethod.fromUseWallet(cart.useWallet),
  };

  final place = checkoutAddress?.description.trim() ?? '';
  final label = checkoutAddress?.title.trim() ?? '';
  if (place.isNotEmpty) {
    payload['address'] = place;
  } else if (label.isNotEmpty) {
    payload['address'] = label;
  }
  if (label.isNotEmpty) {
    payload['address_description'] = label;
  }

  if (notes != null && notes.trim().isNotEmpty) {
    payload['notes'] = notes.trim();
  }

  final discountCode = cart.discountCode?.trim();
  if (discountCode != null && discountCode.isNotEmpty) {
    payload['apply_coupon'] = discountCode;
  }

  return payload;
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
