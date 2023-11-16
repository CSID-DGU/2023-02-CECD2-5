import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:vegetable/login_platform.dart';
import 'package:vegetable/mainpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String globalUserName = "";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? token;
  LoginPlatform _loginPlatform = LoginPlatform.none;

  @override
  void initState() {
    super.initState();
    registerNotification();
  }

  void registerNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    token = await FirebaseMessaging.instance.getToken();
    print("Device Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.notification?.body}");
    });
  }

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );
      
      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      // 로그인 성공 시 사용자 정보를 서버에 전송
      User user = await UserApi.instance.me();
      await sendUserDataToServer(user);

      // 로그인 성공 시 메인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  Future<void> sendUserDataToServer(User user) async {
    try {
    // 사용자 정보를 스프링 서버에 전송
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/user');
   
    User user = await UserApi.instance.me();
    globalUserName = user.kakaoAccount?.profile?.nickname ?? "익명 사용자";
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
      
    );
    
    if (response.statusCode == 200) {
      print('사용자 정보 전송 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

    } else {
      print('사용자 정보 전송 실패\nHTTP Status Code: ${response.statusCode}\nResponse Body: ${response.body}');
    }
  } catch (error) {
    print('사용자 정보 전송 중 오류 발생: $error');
  }
  }

  void signOut() async {
    // 로그아웃 처리
    // ...

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(160, 180, 245, 187),
              Color.fromARGB(255, 104, 204, 170),
              Color.fromARGB(255, 104, 204, 170)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(flex: 1),
            Text(
              "Veggie Hunter",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: 'RighteousRegular', fontSize: 50),
            ),
            Center(
              child: Container(
                width: 250,
                height: 45,
                margin: const EdgeInsets.only(top: 20 ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  "환영합니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontFamily:'SOYO_Maple_Bold', fontSize: 25),
                ),
              ),
            ),
            Spacer(flex: 1),
            SizedBox(height: 150),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _loginButton('kakao_logo', signInWithKakao),
                ],
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Container(
      width: 300,
      height: 54,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              'assets/images/kakao.png',
              width: 300,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
