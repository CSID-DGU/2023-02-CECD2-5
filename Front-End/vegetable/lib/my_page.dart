import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "마이페이지",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126), // 앱바 배경색
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), // 탭바의 높이 설정
          child: Material(
            color: Colors.white, // 탭바 배경색을 여기서 설정
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[300],
              labelStyle: TextStyle(fontFamily: 'SOYO_Maple_Bold', fontSize: 16),
              indicatorColor: Color.fromARGB(255, 118, 191, 126),
              indicatorWeight: 3,
              
              tabs: [
                Tab(text: "채소"),
                Tab(text: "레시피"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text("채소 페이지")),
          Center(child: Text("레시피 페이지")),
        ],
      ),
    );
  }
}

