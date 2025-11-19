import 'package:get/get.dart';

// ignore: strict_top_level_inference
validTextForm(String val, String type, int max, int min) {
  if (val.isEmpty) {
    return "9".tr;
  }
  if (val.length <= min) {
    return "${"7".tr}$min";
  }
  if (val.length >= max) {
    return "${"8".tr}$max";
  }

  if (type == "Email") {
    if (!GetUtils.isEmail(val)) {
      return "6".tr;
    }
  }
}
