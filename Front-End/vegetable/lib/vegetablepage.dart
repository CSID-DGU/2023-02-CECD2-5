import 'package:flutter/material.dart';

class VegetablePage extends StatefulWidget {
  @override
  _VegetablePageState createState() => _VegetablePageState();
}

class _VegetablePageState extends State<VegetablePage> {
  // 임시로 채소 데이터를 만듭니다.
  List<Map<String, dynamic>> vegetables = List.generate(
    20,
    (index) => {'name': '채소$index', 'image': 'assets/temp_image.png'},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("채소 페이지"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 기능을 여기에 추가합니다.
            },
          ),
          PopupMenuButton(
            onSelected: (value) {
              // 선택한 항목에 따른 작업을 처리합니다.
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("옵션 1"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("옵션 2"),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // 2열로 설정합니다.
        ),
        itemCount: vegetables.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              // 실제 이미지를 사용하려면 아래 코드의 'assets/temp_image.png' 경로를 실제 이미지 경로로 변경해야 합니다.
              Image.asset('assets/temp_image.png', width: 100, height: 100),  // 임시 이미지를 표시합니다.
              Text(vegetables[index]['name']),  // 채소의 이름을 표시합니다.
            ],
          );
        },
      ),
    );
  }
}
