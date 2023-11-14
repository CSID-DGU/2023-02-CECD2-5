import 'package:flutter/material.dart';
import 'my_page.dart';
import 'loginpage.dart';
import 'settings.dart';
import 'announcement.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void _sendEmail() async {
  final Email email = Email(
    body: '',
    subject: '[VeggieHunter 문의]',
    recipients: ['eogus0512@gmail.com'],
    cc: [],
    bcc: [],
    attachmentPaths: [],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    String title = "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드리겠습니다 :)\n\neogus0512@gmail.com";
    String message = "";
    print(error);
  }
}

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
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()), // MyPage로 이동
                        );
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
                    fontFamily: 'SOYO_maple_Bold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            '마이페이지',
            style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'SOYO_maple_Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()), // MyPage로 이동
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.announcement),
          title: Text(
            '공지사항',
            style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'SOYO_maple_Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnnouncementPage()), // MyPage로 이동
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text(
            '문의하기',
            style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'SOYO_maple_Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          onTap: () {
              _sendEmail();
          },
        ),
      ],
    ),
  );
}