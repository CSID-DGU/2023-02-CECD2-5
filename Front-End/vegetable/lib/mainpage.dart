import 'package:flutter/material.dart';
import 'vegetablepage.dart';
import 'underbar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메인 페이지")),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class VegetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("채소 페이지")),
      body: Center(child: Text("채소 페이지 내용"))
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

void main() => runApp(MaterialApp(home: MainPage()));