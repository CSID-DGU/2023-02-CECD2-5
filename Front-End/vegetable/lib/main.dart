import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GradientBackgroundScreen(),
    );
  }
}

class GradientBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 6. 배경색은 위쪽은 연두- 아래쪽은 초록으로 그라데이션
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(214, 153, 226, 156), Color.fromARGB(159, 220, 166, 81)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙에 위치하도록 설정
          crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 방향으로 최대 너비 사용
          children: [
            // 1. 화면 1/4 지점에 흰색 글자로 "Vegetable"이라는 타이틀.
            Spacer(flex: 1), // 1/4을 차지하도록 Spacer 사용
            Text(
              "Veggie Hunter",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: 'Pacifico', fontSize: 50),
            ),
            
            // 2. 그 아래 옆이 둥근 직사각형으로 흰색 글자로 "환영합니다" 라는 문구
            Center(
              child: Container(
                width: 250,  // 원하는 너비 값으로 조절
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                //padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25),
                ),
              alignment: Alignment.center,
              child: Text(
                "환영합니다",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),



            Spacer(flex: 1), // 1/2의 공간을 차지하도록 Spacer 사용

            SizedBox(height: 150),

            // 3. 화면 3/4지점에 흰색 사각형 안에 있는 "네이버로 로그인하기" 버튼
            Center(
              child: InkWell(
                onTap: () async{
                  final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/login');
                  if (await canLaunchUrl(url)){
                    await launchUrl(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not launch $url'),
                        ),
                    );
                  }
                },
              child: Container(
                width: 250,
                height: 45,

                child: Row(
                  children: [
                    // 이미지 위젯 (박스의 왼쪽 끝에 위치)
                    Image.asset(
                      'assets/images/naver.png',
                      width: 250, // 이미지의 너비를 조절할 수 있습니다.
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            ),

/*          
            // 4. 흰색 사각형 아래 흰색 글자로 "또는"이라는 문구
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "─────────   또는   ─────────",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // 5. "또는" 문구 아래 흰색 선의 투명한 직사각형 안에 있는 흰색 글자로 "회원가입" 버튼
            Center(
              child: Container(
                width: 250,
                height: 45,
                margin: const EdgeInsets.only(top: 12),
                //padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                //borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
              child: Text(
                "회원가입",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              ),
            ),
*/
            Spacer(flex: 1), // 나머지 공간을 차지하도록 Spacer 사용
          ],
        ),
      ),
    );
  }
}
