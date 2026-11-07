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
        payload?['success'] != false &&
        payload?['status'] != false &&
        payload?['error'] == null &&
        payload?['errors'] == null;
  }
}
