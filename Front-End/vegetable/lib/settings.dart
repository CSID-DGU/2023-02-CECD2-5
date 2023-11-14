import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'loginpage.dart';  // Assuming this is your login page

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsOn = true; // Initial state of the notification switch

  void _toggleNotification(bool newValue) {
    setState(() {
      _isNotificationsOn = newValue;
    });
    // Here you can add logic to actually handle notification settings
  }

  void _logout() async {
    try {
      await UserApi.instance.logout(); // Kakao logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
      );
    } catch (error) {
      // Handle logout error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "설정",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text(
              '푸시 알림',
              style: TextStyle(fontSize: 16, fontFamily: 'SOYO_Maple_Regular'
              ),
            ),
            value: _isNotificationsOn,
            onChanged: _toggleNotification,
            secondary: Icon(Icons.notifications),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              '로그아웃',
              style: TextStyle(fontSize: 16, fontFamily: 'SOYO_Maple_Regular'
              ),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
