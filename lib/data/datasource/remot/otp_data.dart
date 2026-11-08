import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/phone_auth_contract.dart';
import 'package:app/data/datasource/model/auth_reply.dart';

class OtpData {
  Crud crud;

  OtpData(this.crud);

  Future<AuthReply> otpData(String otpCode, String phoneNumber) async {
    return crud.authPost(ApiLinks.verifyCode, {
      "otp": otpCode,
      "phone_number": phoneNumber,
    });
  }

  /// Existing implementation reuses login. Resend semantics are NOT confirmed.
  Future<Object> resendOtp(String phoneNumber) async {
    if (!PhoneAuthContract.resendConfirmed) return StatusRequest.failure;
    var response = await crud.postData(ApiLinks.login, {
      "phone_number": phoneNumber,
    });
    return response.fold((l) => l, (r) => r);
  }
}
