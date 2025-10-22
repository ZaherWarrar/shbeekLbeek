import 'package:app/core/class/statusrequest.dart';

handelingData(response) {
  if (response is StatusRequest) {
    return response;
  } else {
    return StatusRequest.success;
  }
}
