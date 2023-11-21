import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'recipe_send.dart';  // 이 부분은 실제로 데이터를 전송하는 로직을 구현한 클래스입니다.
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
  List<File> _selectedImages = [];
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
    }

    List<File> selectedImages = [];
    for (var pickedFile in pickedFiles) {
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
    if (_ingredients.length > 1) {
      setState(() {
        _ingredients.removeAt(index);
        _ingredientNameControllers[index].dispose();
        _ingredientQuantityControllers[index].dispose();
        _ingredientNameControllers.removeAt(index);
        _ingredientQuantityControllers.removeAt(index);
      });
    }
  }

  void _addNewStepField() {
    setState(() {
      _steps.add('');
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepField(int index) {
    if (_steps.length > 1) {
      setState(() {
        _steps.removeAt(index);
        _stepControllers[index].dispose();
        _stepControllers.removeAt(index);
      });
    }
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 데이터 전송 로직 (레시피 데이터 처리)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레시피 등록'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: '레시피 제목'),
                  onChanged: (value) => _recipeName = value,
                  validator: (value) => value!.isEmpty ? '제목을 입력하세요.' : null,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('사진 추가'),
                ),
                _selectedImages.isEmpty
                    ? Container()
                    : SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) => Image.file(_selectedImages[index]),
                        ),
                      ),
                ..._buildIngredientFields(),
                ElevatedButton(
                  onPressed: _addNewIngredientField,
                  child: Text('재료 추가'),
                ),
                ..._buildStepFields(),
                ElevatedButton(
                  onPressed: _addNewStepField,
                  child: Text('요리 순서 추가'),
                ),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text('레시피 등록'),
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
              child: TextFormField(
                controller: _ingredientNameControllers[i],
                decoration: InputDecoration(labelText: '재료 ${i + 1}'),
                validator: (value) => value!.isEmpty ? '재료를 입력하세요.' : null,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _ingredientQuantityControllers[i],
                decoration: InputDecoration(labelText: '재료의 양'),
                validator: (value) => value!.isEmpty ? '재료의 양을 입력하세요.' : null,
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
              child: TextFormField(
                controller: _stepControllers[i],
                decoration: InputDecoration(labelText: '순서 ${i + 1}'),
                validator: (value) => value!.isEmpty ? '요리 순서를 입력하세요.' : null,
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
