import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vegetable/recipe_info.dart';

class RecipeListPage extends StatefulWidget {
  final int vegetableId;

  RecipeListPage({required this.vegetableId});

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
      appBar: AppBar(title: Text("Recipe List")),
      body: recipes == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recipes!.length,
              itemBuilder: (context, index) {
                final recipe = recipes![index];
                return ListTile(
                  title: Text(recipe['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipeId: recipe['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
