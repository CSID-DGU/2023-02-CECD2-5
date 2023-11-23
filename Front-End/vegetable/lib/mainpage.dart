import 'dart:convert';
import 'package:flutter/material.dart';
import 'vegetablepage.dart';
import 'underbar.dart';
import 'menu.dart';
import 'recipepage.dart';
import 'package:http/http.dart' as http;
import 'vegetable_detail.dart';
import 'recipe_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        fontFamily: 'SOYO_Maple_Bold',
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
  List<dynamic> homeVegetableList = [];
  List<dynamic> homeRecipeList = [];

  @override
  void initState() {
    super.initState();
    fetchHomeVegetables();
    fetchHomeRecipes();
  }

  Future<void> fetchHomeVegetables() async {
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/home/vegetable/');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    if (jsonData['success'] && jsonData['code'] == 200) {
      setState(() {
        homeVegetableList = json.decode(utf8.decode(response.bodyBytes))['data'];
      });
    }
  }

  Future<void> fetchHomeRecipes() async {
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/home/recipe/');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    if (jsonData['success'] && jsonData['code'] == 200) {
      setState(() {
        homeRecipeList = json.decode(utf8.decode(response.bodyBytes))['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
        elevation: 0,
      ),
      endDrawer: buildMenuDrawer(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          VegetablePage(),
          MainContent(homeVegetableList: homeVegetableList, homeRecipeList: homeRecipeList),
          RecipePage(),
        ],
      ),
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

class MainContent extends StatelessWidget {
  final List<dynamic> homeVegetableList;
  final List<dynamic> homeRecipeList;

  MainContent({Key? key, required this.homeVegetableList, required this.homeRecipeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 오늘의 채소, 레시피 영역
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 118, 191, 126),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "오늘의 채소",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SOYO_Maple_Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "오늘의 레시피",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SOYO_Maple_Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 좋아요 높은 채소 TOP 5
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("좋아요 높은 채소 TOP 5", style: TextStyle(fontSize: 20.0, fontFamily: 'SOYO_Maple_Bold')),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VegetablePage(),
                          ),
                        );
                      },
                      child: Text(
                        "더보기",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, fontFamily: 'SOYO_Maple_Regular'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeVegetableList.length,
                  itemBuilder: (context, index) {
                    var vegetable = homeVegetableList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VegetableDetailPage(
                              vegetableId: vegetable['id'],
                              price: 0.0, // Replace with actual price if available
                              unit: 'unit', // Replace with actual unit if available
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(vegetable['image'], height: 90, width:120), // 이미지 표시
                            ],
                          ),
                          SizedBox(height: 10), // Add spacing between image and text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                vegetable['name'], 
                                style: TextStyle(
                                  fontFamily: 'SOYO_Maple_Regular',
                                  fontSize: 15
                                )
                              ), // 채소 이름 표시
                              SizedBox(width: 8), // Add some spacing between name and heart icon
                              Icon(Icons.favorite, color: Colors.red, size: 15,), // Heart icon
                              SizedBox(width: 1), // Add some spacing between heart icon and like count
                              Text(
                                '(' + vegetable['likeCount'].toString() + ')',
                                style: TextStyle(
                                  fontFamily: 'SOYO_Maple_Regular',
                                  fontSize: 12
                                )
                              ), // Like count
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // 좋아요 높은 레시피 TOP 5
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("좋아요 높은 레시피 TOP 5", style: TextStyle(fontSize: 20.0, fontFamily: 'SOYO_Maple_Bold')),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePage(),
                          ),
                        );
                      },
                      child: Text(
                        "더보기",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, fontFamily: 'SOYO_Maple_Regular'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeRecipeList.length,
                  itemBuilder: (context, index) {
                    var recipe = homeRecipeList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipeId: recipe['id'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(recipe['image'], height: 90, width:120), // 이미지 표시
                            ],
                          ),
                          SizedBox(height: 10), // Add spacing between image and text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                recipe['title'], 
                                style: TextStyle(
                                  fontFamily: 'SOYO_Maple_Regular',
                                  fontSize: 15
                                )
                              ), // 채소 이름 표시
                              SizedBox(width: 8), // Add some spacing between name and heart icon
                              Icon(Icons.favorite, color: Colors.red, size: 15,), // Heart icon
                              SizedBox(width: 1), // Add some spacing between heart icon and like count
                              Text(
                                '(' + recipe['likeCount'].toString() + ')',
                                style: TextStyle(
                                  fontFamily: 'SOYO_Maple_Regular',
                                  fontSize: 12
                                )
                              ), // Like count
                            ],
                          ),
                        ],
                      ),
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
