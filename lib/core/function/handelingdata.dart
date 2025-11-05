import 'package:app/core/class/statusrequest.dart';

// ignore: strict_top_level_inference
StatusRequest handelingData(response) {
  if (response is StatusRequest) {
    return response;
  } else {
    return StatusRequest.success;
  }
}
