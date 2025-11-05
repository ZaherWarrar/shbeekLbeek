import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class OtpData {
  Crud crud;

  OtpData(this.crud);

  // ignore: strict_top_level_inference
  otpData(String otpCode, String phoneNumber ) async {
    var response = await crud
        .postData(ApiLinks.verifyCode, {"otp": otpCode, "phone_number": phoneNumber, });
    return response.fold((l) => l, (r) => r);
  }
}
