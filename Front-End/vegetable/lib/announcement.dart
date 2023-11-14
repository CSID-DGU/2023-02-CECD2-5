import 'package:flutter/material.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> with SingleTickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "공지사항",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126), // 앱바 배경색
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

