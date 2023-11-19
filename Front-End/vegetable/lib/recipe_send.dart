import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'loginpage.dart'; // Assuming globalUserName is defined here

class RecipeSender {
  final String recipeName;
  final int vegetableId;
  final List<Map<String, String>> ingredients;
  final List<String> steps;
  final File? selectedImage;

  RecipeSender({
    required this.recipeName,
    required this.vegetableId,
    required this.ingredients,
    required this.steps,
    this.selectedImage,
  });

  Future<void> sendRecipe() async {
    var uri = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/recipe');
    var request = http.MultipartRequest('POST', uri);

    // RecipeRequest
    request.fields['recipeRequest'] = jsonEncode({
      "title": recipeName,
      "writer": globalUserName, // Use the globalUserName from loginpage.dart
      "vegetableId": vegetableId,
    });

    // RecipeStepsRequestList
    var stepsData = List.generate(steps.length, (i) => {
      "step": (i + 1).toString(),
      "content": steps[i] // Directly use the string from steps list
    });
    request.fields['recipeStepsRequestList'] = jsonEncode(stepsData);

    // IngredientRequestList
    var ingredientsData = ingredients.map((ingredient) {
      return {
        "name": ingredient['ingredient']!,
        "amount": ingredient['quantity']!
      };
    }).toList();
    request.fields['ingredientRequestList'] = jsonEncode(ingredientsData);

    // MultipartFileList
    if (selectedImage != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        'files',
        selectedImage!.path,
      );
      request.files.add(multipartFile);
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
