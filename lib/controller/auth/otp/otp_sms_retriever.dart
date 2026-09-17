import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class OtpSmsRetriever implements SmsRetriever {
  OtpSmsRetriever({SmartAuth? smartAuth})
    : _smartAuth = smartAuth ?? SmartAuth.instance;

  final SmartAuth _smartAuth;

  @override
  bool get listenForMultipleSms => true;

  @override
  Future<String?> getSmsCode() async {
    final res = await _smartAuth.getSmsWithUserConsentApi();
    final code = res.data?.code;
    if (code == null || code.isEmpty) return null;

    final digits = code.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return null;
    return digits.substring(digits.length - 6);
  }

  @override
  Future<void> dispose() async {
    await _smartAuth.removeUserConsentApiListener();
  }
}
