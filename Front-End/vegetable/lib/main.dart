import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_project/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String serverKey = "AAAA-LGyPwU:APA91bHEWfwOC4kHKv11pKbw_IQknf-h-RUvsUtwQV671LVWhealEzYB5873jKT7DaozNPzop04KwjuFlFnd2AGmJmaGRDPNbachaxbbekuWraUS1aJQCvGdj0sQoXBYjsZRnyyiSnOg";
String myDeviceToken = "fEVnGgviT5injJArEMm94H:APA91bFJ4i-05OWlW41RpoaFxBmVSlZb5uLSTYkYDL1k1LWm6-_NDRlNKnVCnc3uZnvc5mLILgA0_9xqNSem6Xlshe55z5_nml0Cf2QLqLLrFg30fS_9XQDBX7xwWtpjwatn1VnIEjKL";

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Additional details if needed...
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  // Add action... Parameters can be passed using details.payload
}

void initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      // Add action...
    },
    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'high_importance_notification',
            importance: Importance.max,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data['test_parameter1']
      );
      print("수신자 측 메시지 수신");
    }
  });

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // Action section -> Parameters can be like initialMessage.data['test_parameter1']...
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var messageString = "";
  bool isSent = false;

  void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("내 디바이스 토큰: $token");
  }

  Future<void> sendNotificationToDevice({required String deviceToken, required String title,
      required String content, required Map<String, dynamic> data}) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final body = {
      'notification': {'title': title, 'body': content, 'data': data},
      'to': deviceToken,
    };
    final response = await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      print("성공적으로 전송되었습니다.");
      print("$title $content");
    } else {
      print("전송에 실패하였습니다.");
    }
  }

  @override
  void initState() {
    super.initState();
    getMyDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("메시지 내용: $messageString"),
            ElevatedButton(
              onPressed: () => sendNotificationToDevice(
                  deviceToken: myDeviceToken,
                  title: '푸시 알림 테스트',
                  content: '푸시 알림 내용',
                  data: {'test_parameter1': 1, 'test_parameter2': '테스트1'}),
              child: const Text("알림 전송"),
            )
          ],
        ),
      ),
    );
  }
}
