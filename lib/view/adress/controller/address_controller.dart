import 'package:get/get.dart';
import '../model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;

  final selectedLat = 0.0.obs;
  final selectedLng = 0.0.obs;

  void setLocation(double lat, double lng) {
    selectedLat.value = lat;
    selectedLng.value = lng;
  }

  void addAddress(AddressModel address) {
    addresses.add(address);
  }
}

