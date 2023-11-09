import 'package:flutter/material.dart';
import 'vegetablepage.dart';
import 'underbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        // BMHANNAPro 글씨체를 앱의 기본 글씨체로 설정
        fontFamily: 'NotoSansKR-Bold',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions = [
    VegetablePage(),
    MainContent(),
    RecipePage(),
  ];

    void _selectedMenuItem(int item) {
    // 실행기능 추가 필요
    switch (item) {
      case 1:
        print('찜한 목록');
        // TODO: 찜한 목록 페이지로 이동
        break;
      case 2:
        print('마이페이지');
        // TODO: 마이페이지로 이동
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: _selectedMenuItem,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('찜한 목록'),
                ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('마이페이지'),
              ),
            ],
            icon: Icon(
              Icons.menu,
              size: 30
            ),
          )
        ]
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            }
          );
        }
      ),
    );
  }
}


class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("레시피 페이지")),
      body: Center(child: Text("레시피 페이지 내용"))
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 오늘의 채소, 레시피 영역
        Expanded(
          child: Container(
            color: Colors.lightGreen[100],
            child: Row(
              children: [
                Expanded(child: Center(child: Text("오늘의 채소"))),
                Expanded(child: Center(child: Text("오늘의 레시피")))
              ],
            ),
          ),
        ),
        // 가장 많이 본 채소 TOP 10
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("가장 많이 본 채소 TOP 10", style: TextStyle(fontSize: 20.0)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VegetablePage())); // '채소' 페이지로 이동
                      },
                      child: Text(
                        "더보기",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(child: Text("채소 ${index + 1}")),
                      color: Colors.grey
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // 가장 많이 본 레시피 TOP 10
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("가장 많이 본 레시피 TOP 10", style: TextStyle(fontSize: 20.0)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipePage())); // '레시피' 페이지로 이동
                      },
                      child: Text(
                        "더보기",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(child: Text("레시피 ${index + 1}")),
                      color: Colors.grey
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//void main() => runApp(MaterialApp(home: MainPage()));

