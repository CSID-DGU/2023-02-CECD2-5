import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'menu.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  PageController _pageController = PageController();
  bool likesData = false;
  Map<String, dynamic>? recipeDetail;
  List<dynamic>? recipeSteps;
  List<dynamic>? recipeIngredients;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails(widget.recipeId);
  }

  Future<void> fetchRecipeDetails(int id) async {
    final detailUrl = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe/detail/$id');
    final stepsUrl = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe/steps/$id');
    final ingredientsUrl = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe/ingredient/$id');



    // Fetch recipe steps
    final stepsResponse = await http.get(stepsUrl);
    if (stepsResponse.statusCode == 200) {
      var stepsData = json.decode(utf8.decode(stepsResponse.bodyBytes));
      if (stepsData['success'] && stepsData['code'] == 200) {
        setState(() {
          recipeSteps = stepsData['data'];
          print('\n\nsteps: $stepsData\n\n');
        });
      }
    }

    // Fetch recipe ingredients
    final ingredientsResponse = await http.get(ingredientsUrl);
    if (ingredientsResponse.statusCode == 200) {
      var ingredientsData = json.decode(utf8.decode(ingredientsResponse.bodyBytes));
            if (ingredientsData['success'] && ingredientsData['code'] == 200) {
        setState(() {
          recipeIngredients = ingredientsData['data'];
          print('\n\ningregients: $ingredientsData\n\n');
        });
      }
    }

    // Fetch recipe detail
    final detailResponse = await http.get(detailUrl);
    if (detailResponse.statusCode == 200) {
      var detailData = json.decode(utf8.decode(detailResponse.bodyBytes));
      if (detailData['success'] && detailData['code'] == 200) {
        setState(() {
          recipeDetail = detailData['data'];
          print('\n\ndetail: $detailData\n\n');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: recipeDetail == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Image Slider
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: recipeDetail!['photoList'].length,
                          itemBuilder: (context, index) {
                            return ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.srcATop,
                              ),
                              child: Image.network(
                                recipeDetail!['photoList'][index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      // Back Button inside the Image
                      Positioned(
                        top: 22.0,
                        left: 8.0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 22.0,
                        right: 16.0,
                        child: GestureDetector(
                          onTap: () => buildMenuDrawer(context),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.menu, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Recipe Title
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 12.0),
                      child: Text(
                        recipeDetail!['title'],
                        style: TextStyle(fontSize: 24, fontFamily: 'SOYO_Maple_Bold'),
                      ),
                    ),
                    trailing: IconButton(
                      padding: const EdgeInsets.only(top: 5, left: 12.0),
                      icon: likesData
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                      onPressed: () async {
                        User user = await UserApi.instance.me();
                        final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipeLikes/${widget.recipeId}');

                        if (likesData) {
                          // 이미 좋아요한 경우에는 삭제
                          final response = await http.delete(
                            url,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                          );
                        } else {
                          // 좋아요하지 않은 경우에는 추가
                          final response = await http.post(
                            url,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                          );
                        }

                        // 상태 갱신
                        setState(() {
                          likesData = !likesData; // 토글
                        });
                      },
                      iconSize: 30,
                    ),
                  ),

                  Divider(thickness: 2,),

                  // Recipe Ingredients
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                      child: Text(
                        '재료',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SOYO_Maple_Bold',
                        ),
                      ), 
                    ),
                  ),
                  ...recipeIngredients!.map((ingredient) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ingredient['name'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SOYO_Maple_Regular',
                            ),
                          ),
                          Text(
                            ingredient['amount'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SOYO_Maple_Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  Divider(thickness: 2,),

                  // Recipe Steps
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                      child: Text(
                        '요리 순서',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SOYO_Maple_Bold',
                        ),
                      ), 
                    ),
                  ),
                  ...recipeSteps!.map((step) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: ListTile(
                          title: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Color.fromARGB(255, 118, 191, 126),
                                ),
                                child: Text(
                                  'Step ${step['step']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SOYO_Maple_Bold',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: Text(
                                  step['content'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SOYO_Maple_Regular',
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey, // You can set the color of the divider
                        thickness: 1.0, // You can set the thickness of the divider
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                    ],
                  )),

                ],
              ),
            ),
    );
  }
}