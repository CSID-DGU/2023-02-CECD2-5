import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:vegetable/vegetable_detail.dart';
import 'recipe_info.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchVegetables() async {
  User user = await UserApi.instance.me();
  final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetableLikes');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(jsonResponse['data']);
  } else {
    print("Error fetching vegetable likes: ${response.body}");
    throw Exception('Failed to load vegetable likes from the server');
  }
}

Future<List<Map<String, dynamic>>> fetchRecipes() async {
  User user = await UserApi.instance.me();
  final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipeLikes');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(jsonResponse['data']);
  } else {
    print("Error fetching recipe likes: ${response.body}");
    throw Exception('Failed to load recipe likes from the server');
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool likesData = false; // Add a variable to track likes state

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
          _buildVegetablesPage(),
          // 레시피 페이지
          _buildRecipesPage(),
        ],
      ),
    );
  }

  Widget _buildVegetablesPage() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchVegetables(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('좋아하는 채소가 없습니다. \n좋아요를 눌러보세요!', textAlign: TextAlign.center));
        } else {
          final vegetables = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: (MediaQuery.of(context).size.width) / (100 + 16),
            ),
            itemCount: vegetables.length,
            itemBuilder: (context, index) {
              final vegetable = vegetables[index];
              double rate = vegetable['rate'];
              int vegetableId = vegetable['id'];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VegetableDetailPage(
                      vegetableId: vegetableId,
                      price: vegetable['price'],
                      unit: vegetable['unit'].toString(),
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 12.0, right: 5.0, bottom: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Image.network(
                                vegetable['image'],
                                fit: BoxFit.contain,
                                height: 100,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${vegetable['name']}',
                                style: TextStyle(
                                  fontSize: (vegetable['name'].length >= 4) ? 17 : 20,
                                  fontFamily: 'SOYO_Maple_Bold',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    '${(rate > 0 ? '+' : '')}${((vegetable['rate'] as double) * 100).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'SOYO_Maple_Bold',
                                      color: rate > 0 ? Colors.red : (rate == 0 ? Colors.black : Colors.blue),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    '${vegetable['price'].round()}원 / ${vegetable['unit']}',
                                    style: TextStyle(
                                      fontFamily: 'SOYO_Maple_Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2, // Adjust the spacing between the icon and other widgets
                            child: IconButton(
                              icon: (vegetable['isLikes'])
                                ? Icon(Icons.favorite, color: Colors.red) // Show a colored heart when liked
                                : Icon(Icons.favorite_border), // Show an outline heart when not liked
                              onPressed: () async {
                                User user = await UserApi.instance.me();
                                int vegetableId = vegetable['id'];

                                final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetableLikes/$vegetableId');

                                if (vegetable['isLikes']) {
                                  final response = await http.delete(
                                    url,
                                    headers: {'Content-Type': 'application/json'},
                                    body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                                  );
                                } else {
                                  final response = await http.post(
                                    url,
                                    headers: {'Content-Type': 'application/json'},
                                    body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                                  );
                                }
                                setState(() {
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildRecipesPage() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('좋아하는 레시피가 없습니다. \n좋아요를 눌러보세요!', textAlign: TextAlign.center));
        } else {
          final recipes = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: (MediaQuery.of(context).size.width) / (100 + 16),
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              String title = recipe['title'];
              int recipeId = recipe['id'];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(
                      recipeId: recipeId,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 12.0, right: 5.0, bottom: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Image.network(
                                recipe['image'],
                                fit: BoxFit.contain,
                                height: 100,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${recipe['title']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SOYO_Maple_Bold',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3, // Adjust the spacing between the icon and other widgets
                            child: IconButton(
                              icon: (recipe['isLikes'])
                                ? Icon(Icons.favorite, color: Colors.red) // Show a colored heart when liked
                                : Icon(Icons.favorite_border), // Show an outline heart when not liked
                              onPressed: () async {
                                User user = await UserApi.instance.me();
                                int recipeId = recipe['id'];

                                final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipeLikes/$recipeId');

                                if (recipe['isLikes']) {
                                  final response = await http.delete(
                                    url,
                                    headers: {'Content-Type': 'application/json'},
                                    body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                                  );
                                } else {
                                  final response = await http.post(
                                    url,
                                    headers: {'Content-Type': 'application/json'},
                                    body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                                  );
                                }
                                setState(() {
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
