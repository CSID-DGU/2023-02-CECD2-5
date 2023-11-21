import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'loginpage.dart'; // Assuming globalUserName is defined here

class RecipeSender {
  final String recipeName;
  final int vegetableId;
  final List<Map<String, String>> ingredients;
  final List<String> steps;
  final List<File> selectedImages;

  RecipeSender({
    required this.recipeName,
    required this.vegetableId,
    required this.ingredients,
    required this.steps,
    required this.selectedImages,
  });

  Future<void> sendRecipe() async {
    var uri = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe');
    var request = http.MultipartRequest('POST', uri);

    // Convert structured data to JSON
    Map<String, dynamic> recipeRequest = {
      'title': recipeName,
      'writer': globalUserName, // Assuming this is the writer's name
      'vegetableId': vegetableId
    };
    List<Map<String, dynamic>> stepsRequestList = steps
        .asMap()
        .map((i, step) => MapEntry(i, {'step': i + 1, 'content': step}))
        .values
        .toList();
    List<Map<String, dynamic>> ingredientsRequestList = ingredients
        .map((ingredient) => {
          'name': ingredient['ingredient']!,
          'amount': ingredient['quantity']!
        })
        .toList();

    // Add parts to request as MultipartFiles
    request.files.add(http.MultipartFile.fromString(
      'recipeRequest', 
      jsonEncode(recipeRequest), 
      contentType: MediaType('application', 'json')
    ));
    request.files.add(http.MultipartFile.fromString(
      'recipeStepsRequestList', 
      jsonEncode(stepsRequestList), 
      contentType: MediaType('application', 'json')
    ));
    request.files.add(http.MultipartFile.fromString(
      'ingredientRequestList', 
      jsonEncode(ingredientsRequestList), 
      contentType: MediaType('application', 'json')
    ));

    // Add multipart file for image, if present
    if (selectedImages != null) {
      for (var image in selectedImages) {
        request.files.add(await http.MultipartFile.fromPath(
          'files', image.path,
        ));
      }
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Recipe created successfully!');
      } else {
        print('Failed to create recipe: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }
}
