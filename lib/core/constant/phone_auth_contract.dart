/// Login request and response confirmed by the supplied Postman evidence.
/// Verify and resend remain separate contracts.
class PhoneAuthContract {
  PhoneAuthContract._();
  static const confirmed = true;
  static const loginReplyConfirmed = true;
  static const loginSuccessMessage = 'تم إرسال رمز التحقق بنجاح. يرجى التحقق.';
  static const resendConfirmed = false;
  static const unavailableMessage =
      'تسجيل الدخول غير متاح مؤقتاً. يمكنك المتابعة كضيف أو التواصل مع الدعم.';
}
