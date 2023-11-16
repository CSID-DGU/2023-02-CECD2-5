import 'package:http/http.dart' as http;
import 'dart:convert';

class Alarm {
  static Future<void> sendFCMMessage(String title, String body) async {
    final String serverToken = 'YOUR_SERVER_KEY';
    final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    try {
      await http.post(
        Uri.parse(fcmUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'to': "/topics/all", // Assuming you want to send to all devices subscribed to a topic
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}

