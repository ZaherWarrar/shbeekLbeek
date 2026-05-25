import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:get/get.dart';

Map<String, dynamic> buildOrderPayload({
  required CartController cart,
  String? notes,
}) {
  final items = cart.cartItems
      .where((item) => item['productId'] != null)
      .map(
        (item) => {
          'product': {'id': item['productId'] as int},
          'quantity': item['quantity'] as int,
          'variation_name': item['variationName']?.toString(),
          'notes': item['itemNotes']?.toString(),
        },
      )
      .toList();

  final addressController = Get.find<AddressController>();
  final defaultAddressList =
      addressController.addresses.where((a) => a.isDefault);

  double latitude;
  double longitude;
  if (defaultAddressList.isNotEmpty) {
    final address = defaultAddressList.first;
    latitude = address.lat;
    longitude = address.lng;
  } else {
    latitude = addressController.selectedLat.value;
    longitude = addressController.selectedLng.value;
  }

  final payload = <String, dynamic>{
    'cart': {'items': items},
    'latitude': latitude,
    'longitude': longitude,
  };

  if (notes != null && notes.trim().isNotEmpty) {
    payload['notes'] = notes.trim();
  }

  final discountCode = cart.discountCode?.trim();
  if (discountCode != null && discountCode.isNotEmpty) {
    payload['apply_coupon'] = discountCode;
  }

  return payload;
}
