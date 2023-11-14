import 'package:flutter/material.dart';
import 'my_page.dart'; // 마이페이지
import 'loginpage.dart';


Drawer buildMenuDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // 드로어 헤더
        DrawerHeader(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        // 알림 버튼 기능
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        // 설정 버튼 기능
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, 0.5),
                child: Text(
                  '$globalUserName님, 환영합니다!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('마이페이지'),
          onTap: () {
            // 마이페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()), // MyPage로 이동
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.announcement),
          title: Text('공지사항'),
          onTap: () {
            // 공지사항 페이지로 이동
          },
        ),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text('고객센터'),
          onTap: () {
            // 고객센터 페이지로 이동
          },
        ),
      ],
    ),
  );
}