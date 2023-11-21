import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'recipe_send.dart';
import 'recipe_list.dart';

class MakeRecipePage extends StatefulWidget {
  final int vegetableId;
  final String vegetableName;

  MakeRecipePage({required this.vegetableId, required this.vegetableName});

  @override
  _MakeRecipePageState createState() => _MakeRecipePageState();
}

class _MakeRecipePageState extends State<MakeRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String _recipeName = '';
  List<Map<String, String>> _ingredients = [{'ingredient': '', 'quantity': ''}];
  List<TextEditingController> _ingredientNameControllers = [];
  List<TextEditingController> _ingredientQuantityControllers = [];
  List<String> _steps = [''];
  List<TextEditingController> _stepControllers = [];
  List<File> _selectedImages = [];  // 수정: 이미지들을 담을 List<File> 추가
  String? _validationError;
  Map<String, String?> _ingredientValidationErrors = {};
  

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    for (var ingredient in _ingredients) {
      _ingredientNameControllers.add(TextEditingController(text: ingredient['ingredient']));
      _ingredientQuantityControllers.add(TextEditingController(text: ingredient['quantity']));
    }
    for (var step in _steps) {
      _stepControllers.add(TextEditingController(text: step));
    }
  }

Future<void> _pickImage() async {
  List<XFile> pickedFiles = [];

  try {
    pickedFiles = await _picker.pickMultiImage();
  } catch (e) {
    print('Error picking images: $e');
    // Handle any errors here
  }

  List<File> selectedImages = [];
  for (var pickedFile in pickedFiles) {
    // Convert XFile to File
    File imageFile = File(pickedFile.path);
    selectedImages.add(imageFile);
  }

  setState(() {
    _selectedImages = selectedImages;
  });
}

  void _addNewIngredientField() {
    setState(() {
      _ingredients.add({'ingredient': '', 'quantity': ''});
      _ingredientNameControllers.add(TextEditingController());
      _ingredientQuantityControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredients.removeAt(index);
      _ingredientNameControllers[index].dispose();
      _ingredientQuantityControllers[index].dispose();
      _ingredientNameControllers.removeAt(index);
      _ingredientQuantityControllers.removeAt(index);
    });
  }

  void _addNewStepField() {
    setState(() {
      _steps.add('');
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepField(int index) {
    setState(() {
      _steps.removeAt(index);
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }


  void handleSubmit() {
    // 레시피 이름 검증
    if (_recipeName.isEmpty) {
      setState(() {
        _validationError = '제목을 입력하세요.';
      });
      return;
    }

    // 재료 검증
    for (var controller in _ingredientNameControllers) {
      if (controller.text.isEmpty) {
        setState(() {
          _validationError = '재료를 입력하세요.';
        });
        return;
      }
    }

    // 요리 순서 검증
    for (var controller in _stepControllers) {
      if (controller.text.isEmpty) {
        setState(() {
          _validationError = '요리 순서를 입력하세요.';
        });
        return;
      }
    }

    // 모든 검증을 통과했을 경우
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      printRecipeData();

      var recipeSender = RecipeSender(
        recipeName: _recipeName,
        vegetableId: widget.vegetableId,
        ingredients: _ingredients,
        steps: _steps,
        selectedImages: _selectedImages,
      );

      recipeSender.sendRecipe();

      Navigator.pop(context); // 모든 입력이 완료되면 이전 화면으로 돌아감
    }
  }

  void printRecipeData() {
    print('Recipe Name: $_recipeName');
    print('Vegetable ID: ${widget.vegetableId}');
    print('Ingredients:');
    for (var i = 0; i < _ingredients.length; i++) {
      print('  Ingredient ${i + 1}: ${_ingredientNameControllers[i].text}, Quantity: ${_ingredientQuantityControllers[i].text}');
    }
    print('Steps:');
    for (var i = 0; i < _steps.length; i++) {
      print('  Step ${i + 1}: ${_stepControllers[i].text}');
    }
    if (_selectedImages.isNotEmpty) {
      print('Selected Image: ${_selectedImages[0].path}');
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '레시피 등록',
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    child: Text(
                      '레시피 제목',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SOYO_Maple_Bold',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _validationError = (value == null || value.isEmpty)
                            ? 'Please enter a recipe name'
                            : null;
                      });
                    },
                    onSaved: (value) {
                      _recipeName = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '레시피 제목',
                      errorText: _validationError,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126)),
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 2,),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          child: Text(
                            '음식 사진',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SOYO_Maple_Bold',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10), // 왼쪽 여백 조절
                      child: ElevatedButton(
                        onPressed: () => _pickImage(),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 118, 191, 126),
                        ),
                        child: Text(
                          '+ 사진 추가',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SOYO_Maple_Regular',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _selectedImages.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          '음식 사진을 추가해보세요',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SOYO_Maple_Regular',
                          ),
                        ),
                      )
                    : Row(
                      children: _selectedImages
                        .map((image) => Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Image.file(image, width: 150, height: 150),
                        ))
                        .toList(),
                    ),
                Divider(thickness: 2,),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10), // 왼쪽 여백 조절
                      child: ElevatedButton(
                        onPressed: () => _addNewIngredientField(),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 118, 191, 126),
                        ),
                        child: Text(
                          '+ 재료 추가',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SOYO_Maple_Regular',
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                ..._buildIngredientFields(),
                Divider(thickness: 2,),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10), // 왼쪽 여백 조절
                      child: ElevatedButton(
                        onPressed: () => _addNewStepField(),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 118, 191, 126),
                        ),
                        child: Text(
                          '+ 순서 추가',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SOYO_Maple_Regular',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ..._buildStepFields(),
                Padding(
                  padding: EdgeInsets.only(top:30), // 왼쪽 여백 조절
                  child: ElevatedButton(
                  onPressed: () {
                    handleSubmit();
                    // RecipeListPage로 이동
                  if (_validationError == null) {
                    // 에러가 없을 경우에만 RecipeListPage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeListPage(vegetableId: widget.vegetableId, vegetableName: widget.vegetableName)),
                    );
                  }
                },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 118, 191, 126),
                      minimumSize: Size(100, 45),
                    ),
                    child: Text(
                      '레시피 등록',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SOYO_Maple_Bold',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientFields() {
    List<Widget> ingredientFields = [];
    for (int i = 0; i < _ingredients.length; i++) {
      ingredientFields.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _ingredientNameControllers[i],
                  onChanged: (value) {
                    setState(() {
                      _ingredientValidationErrors['ingredient'] =
                          (value == null || value.isEmpty)
                              ? 'Please enter an ingredient'
                              : null;
                    });
                  },
                  onSaved: (value) {
                    _ingredients[i]['ingredient'] = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '재료 이름',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126)),
                    ),
                    errorText: _ingredientValidationErrors['ingredient'],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _ingredientQuantityControllers[i],
                  onChanged: (value) {
                    setState(() {
                      _ingredientValidationErrors['quantity'] =
                          (value == null || value.isEmpty)
                              ? 'Please enter a quantity'
                              : null;
                    });
                  },
                  onSaved: (value) {
                    _ingredients[i]['quantity'] = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '재료의 양',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126)),
                    ),
                    errorText: _ingredientValidationErrors['quantity'],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeIngredientField(i),
            ),
          ],
        ),
      );
    }
    return ingredientFields;
  }




  List<Widget> _buildStepFields() {
    List<Widget> stepFields = [];
    for (int i = 0; i < _steps.length; i++) {
      stepFields.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _validationError = (value == null || value.isEmpty)
                          ? 'Please enter a step'
                          : null;
                    });
                  },
                  onSaved: (value) {
                    _steps[i] = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Step ${i + 1}',
                    errorText: _validationError,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126)),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeStepField(i),
            ),
          ],
        ),
      );
    }
    return stepFields;
  }




  @override
  void dispose() {
    for (var controller in _ingredientNameControllers) {
      controller.dispose();
    }
    for (var controller in _ingredientQuantityControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
