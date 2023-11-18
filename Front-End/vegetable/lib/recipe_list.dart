import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vegetable/recipe_info.dart';

class RecipeListPage extends StatefulWidget {
  final int vegetableId;
  final String vegetableName;

  RecipeListPage({required this.vegetableId, required this.vegetableName});

  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  List<dynamic>? recipes;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe/${widget.vegetableId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print(jsonResponse);
      setState(() {
        recipes = jsonResponse['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vegetableName + '요리 레시피',
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126), // 앱바 배경색
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: recipes == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recipes!.length,
              itemBuilder: (context, index) {
                final recipe = recipes![index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(
                        recipeId: recipe['id'],
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
                      padding: const EdgeInsets.only(left: 0.0, top: 12.0, right: 8.0, bottom: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: Image.network(
                                recipe['image'],
                                fit: BoxFit.contain,
                                height: 100, // 이미지의 높이를 지정합니다.
                              ),
                          ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('${recipe['title']}',
                                style: TextStyle(fontSize: 20, fontFamily: 'SOYO_Maple_Bold',)
                                ),
                              ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets. only(right: 5.0),
                                  child: Text('${recipe['writer'].substring(0, 1)}OO',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontFamily: 'SOYO_Maple_Bold',
                                    )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text('${recipe['createdDate']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontFamily: 
                                      'SOYO_Maple_Regular',
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
