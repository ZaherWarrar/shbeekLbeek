import 'package:app/core/class/statusrequest.dart';

StatusRequest handlingData(dynamic response) {
  if (response is StatusRequest) {
    return response;
  } else {
    return StatusRequest.success;
  }
}
