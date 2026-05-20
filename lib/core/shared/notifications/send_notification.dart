import 'dart:convert';
import 'package:http/http.dart' as http;

class SendNotification {
  static Future<void> SendNotificationApi(
    tokenserver,
    token,
    bodies,
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
      print('notification send successfuly');
    } else {
      print('notification not not not send successfuly');
    }
  }
}
