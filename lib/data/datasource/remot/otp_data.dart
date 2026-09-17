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

  /// Reuses login to send a new OTP — there is no dedicated resend endpoint.
  Future<Object> resendOtp(String phoneNumber, {String name = ''}) async {
    var response = await crud.postData(ApiLinks.login, {
      "name": name,
      "phone_number": phoneNumber,
    });
    return response.fold((l) => l, (r) => r);
  }
}
