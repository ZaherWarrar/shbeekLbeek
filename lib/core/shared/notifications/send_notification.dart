import 'dart:convert';
import 'package:http/http.dart' as http;

class SendNotification {
  // ignore: non_constant_identifier_names
  static Future<void> SendNotificationApi(
    // ignore: strict_top_level_inference
    tokenserver,
    // ignore: strict_top_level_inference
    token,
    // ignore: strict_top_level_inference
    bodies,
    // ignore: strict_top_level_inference
    title,
  ) async {
    String url =
        'https://fcm.googleapis.com/v1/projects/shbeekLbeek/messages:send';
    //'https://fcm.googleapis.com/v1/projects/messages-19d86/messages:send';
    Map<String, dynamic> messages = {
      "message": {
        "token": await token,
        "notification": {'body': bodies, 'title': title},
        "data": {},
      },
    };
    Map<String, String>? headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${await tokenserver}',
    };

    final http.Response res = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(messages),
    );
    if (res.statusCode == 200) {
      // ignore: avoid_print
      print('notification send successfuly');
    } else {
      // ignore: avoid_print
      print('notification not not not send successfuly');
    }
  }
}
