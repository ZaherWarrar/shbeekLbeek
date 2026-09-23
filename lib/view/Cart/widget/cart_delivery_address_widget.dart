import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/Cart/widget/cart_address_picker.dart';
import 'package:app/view/address/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartDeliveryAddressWidget extends StatelessWidget {
  const CartDeliveryAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cart) {
        return Obx(() {
          final address = cart.checkoutAddress;
          return InkWell(
            onTap: () => _changeAddress(cart),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColor().primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColor().primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address == null ? 'موقع التوصيل' : address.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address?.description ?? 'لم يتم تحديد عنوان التوصيل',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor().descriptionColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _changeAddress(cart),
                    child: Text(
                      address == null ? 'إضافة' : 'تعديل',
                      style: TextStyle(color: AppColor().primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _changeAddress(CartController cart) async {
    final addressController = Get.find<AddressController>();
    final knownIds = addressController.addresses.map((a) => a.id).toSet();

    if (addressController.addresses.isEmpty) {
      await Get.to(() => const AddAddressPage());
      _selectNewlyAdded(cart, addressController, knownIds);
      return;
    }

    final result = await showCartAddressPicker(
      addressController: addressController,
      selectedId: cart.checkoutAddress?.id,
    );

    if (result == cartAddressPickerAddNew) {
      await Get.to(() => const AddAddressPage());
      _selectNewlyAdded(cart, addressController, knownIds);
      return;
    }

    if (result != null) {
      cart.selectCheckoutAddress(result);
    }
  }

  void _selectNewlyAdded(
    CartController cart,
    AddressController addressController,
    Set<String> knownIds,
  ) {
    final added = addressController.addresses.where(
      (address) => !knownIds.contains(address.id),
    );
    if (added.isNotEmpty) {
      cart.selectCheckoutAddress(added.last.id);
    } else if (cart.checkoutAddress != null) {
      cart.update();
    }
  }
}
