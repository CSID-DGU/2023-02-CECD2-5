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
  Map<String, dynamic>? today;
  List<dynamic> homeVegetableList = [];
  List<dynamic> homeRecipeList = [];

  @override
  void initState() {
    super.initState();
    fetchToday();
    fetchHomeVegetables();
    fetchHomeRecipes();
  }

  Future<void> fetchToday() async {
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/home/today');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    if (jsonData['success'] && jsonData['code'] == 200) {
      setState(() {
        today = json.decode(utf8.decode(response.bodyBytes))['data'];
      });
    }
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
          MainContent(homeVegetableList: homeVegetableList, homeRecipeList: homeRecipeList, today: today),
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
  final Map<String, dynamic>? today;

  MainContent({Key? key, required this.homeVegetableList, required this.homeRecipeList, required this.today}) : super(key: key);

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
    child: today != null && today!['vegetable'] != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "오늘의 채소\n",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SOYO_Maple_Regular',
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // VegetableDetailPage()로 이동하는 코드를 작성
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VegetableDetailPage(
                      vegetableId: today!['vegetable']['id'],
                      price: today!['vegetable']['price'],
                      unit: today!['vegetable']['unit'],
                    )),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        today!['vegetable']['image'] ?? '',
                        width: 140,
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '\n' + today!['vegetable']['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SOYO_Maple_Regular',
                  color: Colors.white,
                ),
              ),
            ],
          )
        : CircularProgressIndicator(),
  ),
),

                Expanded(
                  child: Center(
                    child: today != null && today!['recipe'] != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "오늘의 레시피\n",  // Add a line break here
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SOYO_Maple_Regular',
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // VegetableDetailPage()로 이동하는 코드를 작성
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RecipeDetailPage(
                                    recipeId: today!['recipe']['id'],
                                  )),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      today!['recipe']['image'] ?? '',
                                      width: 140,
                                      height: 80,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              '\n'+today!['recipe']['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SOYO_Maple_Regular',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "오늘의 레시피\n",  // Add a line break here
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SOYO_Maple_Regular',
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              height: 145,
                              padding: EdgeInsets.all(16.0), // Adjust the padding as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Text(
                                  "레시피를 추가해보세요!",  // Add a line break here
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SOYO_Maple_Regular',
                                    color: Colors.white,
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ]
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
                              price: vegetable['price'], // Replace with actual price if available
                              unit: vegetable['unit'], // Replace with actual unit if available
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                        margin: EdgeInsets.symmetric(horizontal: 8.0), // Add margin between cards
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(vegetable['image'], height: 80), // 이미지 표시
                            SizedBox(height: 20), 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 7), // Add spacing between the text and the container edge
                                Text(
                                  vegetable['name'],
                                  style: TextStyle(
                                    fontFamily: 'SOYO_Maple_Regular',
                                    fontSize: 15,
                                  ),
                                ),
                                Spacer(), // Add Spacer to push the following widgets to the right
                                Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red, size: 15,),
                                    SizedBox(width: 4),
                                    Text(
                                      '(' + vegetable['likeCount'].toString() + ')',
                                      style: TextStyle(
                                        fontFamily: 'SOYO_Maple_Regular',
                                        fontSize: 12,
                                      ),
                                    ), // Like count
                                  ],
                                ),
                                SizedBox(width: 7), // Add spacing between the icon and the like count
                              ],
                            ),
                          ],
                        ),
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
                              recipeId: recipe['id'],),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                        margin: EdgeInsets.symmetric(horizontal: 8.0), // Add margin between cards
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(recipe['image'], height: 80), // 이미지 표시
                            SizedBox(height: 20), 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 7), // Add spacing between the text and the container edge
                                Text(
                                  recipe['title'],
                                  style: TextStyle(
                                    fontFamily: 'SOYO_Maple_Regular',
                                    fontSize: 15,
                                  ),
                                ),
                                Spacer(), // Add Spacer to push the following widgets to the right
                                Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red, size: 15,),
                                    SizedBox(width: 4),
                                    Text(
                                      '(' + recipe['likeCount'].toString() + ')',
                                      style: TextStyle(
                                        fontFamily: 'SOYO_Maple_Regular',
                                        fontSize: 12,
                                      ),
                                    ), // Like count
                                  ],
                                ),
                                SizedBox(width: 7), // Add spacing between the icon and the like count
                              ],
                            ),
                          ],
                        ),
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
