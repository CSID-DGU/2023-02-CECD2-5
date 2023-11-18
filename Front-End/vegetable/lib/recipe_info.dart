import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
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
      appBar: AppBar(title: Text("레시피 상세")),
      body: recipeDetail == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Image Slider
                  Container(
                    height: 200,
                    child: PageView.builder(
                      itemCount: recipeDetail!['photoList'].length,
                      itemBuilder: (context, index) {
                        return Image.network(recipeDetail!['photoList'][index]);
                      },
                    ),
                  ),
                  // Recipe Title
                  Text(
                    recipeDetail!['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // Recipe Ingredients
                  Text('재료', style: TextStyle(fontSize: 20)),
                  ...recipeIngredients!.map((ingredient) => ListTile(
                        title: Text(ingredient['name']),
                        subtitle: Text(ingredient['amount']),
                      )),
                  // Recipe Steps
                  Text('조리 방법', style: TextStyle(fontSize: 20)),
                  ...recipeSteps!.map((step) => ListTile(
                        leading: Text('단계 ${step['step']}'),
                        title: Text(step['content']),
                      )),
                ],
              ),
            ),
    );
  }
}
