/// Raw auth payload stays in memory only; never print/serialize this object.
class AuthReply {
  const AuthReply({this.statusCode, this.payload, this.failure});
  final int? statusCode;
  final Map<String, dynamic>? payload;
  final String? failure;

  bool get httpSucceeded =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;

  // The login endpoint acknowledges sending with HTTP 200 and a message.
  // Message wording is presentation text, not a stable success identifier.
  bool get loginSucceeded {
    final message = payload?['message'];
    return statusCode == 200 &&
        message is String &&
        message.trim().isNotEmpty &&
        !_isExplicitFailure(payload?['success']) &&
        !_isExplicitFailure(payload?['status']) &&
        !_hasErrorValue(payload?['error']) &&
        !_hasErrorValue(payload?['errors']);
  }

  /// نص يظهر للمستخدم. أخطاء قاعدة البيانات لا تُعرض كما وصلت من الخادم.
  String? get loginRejection {
    if (failure != null && failure!.trim().isNotEmpty) {
      return _userFacing(failure);
    }
    final errors = payload?['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        final text = _userFacing(_firstText(value));
        if (text != null) return text;
      }
    }
    final text = _userFacing(_firstText(payload?['message']));
    if (text != null) return text;
    if (statusCode != null && !loginSucceeded) {
      return 'تعذر إرسال الرمز. حاول مرة أخرى بعد قليل.';
    }
    return null;
  }

  static const _duplicatePhoneMessage =
      'هذا الرقم مسجّل مسبقاً. تعذر إرسال رمز التحقق الآن، حاول مرة أخرى بعد قليل.';
  static const _serverFailureMessage =
      'تعذر إرسال الرمز حالياً. حاول مرة أخرى بعد قليل.';

  static String? _userFacing(String? text) {
    final value = text?.trim() ?? '';
    if (value.isEmpty) return null;
    final lower = value.toLowerCase();
    if (lower.contains('duplicate entry') ||
        lower.contains('integrity constraint') ||
        lower.contains('users_phone_number_unique')) {
      return _duplicatePhoneMessage;
    }
    if (lower.contains('sqlstate') ||
        lower.contains('sql:') ||
        lower.contains('insert into') ||
        lower.contains('exception') ||
        lower.contains('stack trace') ||
        value.contains('.php')) {
      return _serverFailureMessage;
    }
    return value;
  }

  static bool _isExplicitFailure(Object? value) =>
      value == false || value == 0 || value == '0' || value == 'false';

  static bool _hasErrorValue(Object? value) {
    if (value == null || value == false) return false;
    if (value is String) return value.trim().isNotEmpty;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    return true;
  }

  static String? _firstText(Object? value) {
    if (value is List && value.isNotEmpty) return _firstText(value.first);
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }
}
