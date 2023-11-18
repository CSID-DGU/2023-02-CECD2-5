import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_list.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<dynamic> recipeList = [];
  
  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe/');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    if (jsonData['success'] && jsonData['code'] == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        recipeList = jsonResponse['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("레시피 페이지"),
      ),
      body: ListView.builder(
        itemCount: recipeList.length,
        itemBuilder: (context, index) {
          var recipe = recipeList[index];
          return ListTile(
            title: Text(recipe['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeListPage(vegetableId: recipe['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

