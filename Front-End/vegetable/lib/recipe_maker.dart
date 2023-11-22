import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'recipe_send.dart';

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
  bool _isPhotoSelected = true; // 사진 선택 여부를 나타내는 상태 변수

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
      _isPhotoSelected = selectedImages.isNotEmpty; // 사진이 선택되었는지 확인
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

  void handleSubmit() async {
    if (_formKey.currentState!.validate() && _selectedImages.isNotEmpty) {
      // 모든 입력 필드의 값이 유효하고, 사진이 선택되었는지 확인
      _formKey.currentState!.save();

      // 데이터 전송 준비
      RecipeSender sender = RecipeSender(
        recipeName: _recipeName,
        vegetableId: widget.vegetableId,
        ingredients: _ingredients.map((i) => {
          'ingredient': i['ingredient']!,
          'quantity': i['quantity']!
        }).toList(),
        steps: _steps,
        selectedImages: _selectedImages,
      );

      // 입력된 값들을 콘솔에 출력
      print('레시피 이름: ${sender.recipeName}');
      print('야채 ID: ${sender.vegetableId}');
      print('재료: ${sender.ingredients}');
      print('요리 순서: ${sender.steps}');
      print('선택된 사진 수: ${sender.selectedImages.length}');

      // 데이터 전송
      await sender.sendRecipe();

      // 데이터 전송 후, 화면을 닫거나 다른 작업 수행
      Navigator.pop(context);
    } else if (_selectedImages.isEmpty) {
      // 사진이 선택되지 않았을 때 경고 메시지 설정
      setState(() {
        _isPhotoSelected = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레시피 등록',
        style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold')
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126), // 앱바 배경색
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
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        fontFamily: 'SOYO_Maple_regular',
                      ),
                    ),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '레시피 제목',
                      labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'), // 레이블에 폰트 적용
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  onChanged: (value) => _recipeName = value,
                  validator: (value) => value!.isEmpty ? '제목을 입력하세요.' : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(
                    '사진 추가',
                    style: TextStyle(fontFamily: 'SOYO_Maple_regular'),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 118, 191, 126),
                    onPrimary: Colors.white,
                  ),
                ),
                if (!_isPhotoSelected) // 사진이 선택되지 않았을 때의 경고 메시지
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '사진을 선택해주세요.',
                      style: TextStyle(color: Colors.red, fontFamily: 'SOYO_Maple_regular'),
                    ),
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
                  child: Text(
                    '재료 추가',
                    style: TextStyle(fontFamily: 'SOYO_Maple_regular'),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 118, 191, 126),
                    onPrimary: Colors.white, // 버튼의 글자색
                  ),
                ),
                ..._buildStepFields(),
                ElevatedButton(
                  onPressed: _addNewStepField,
                  child: Text(
                    '요리 순서 추가',
                    style: TextStyle(fontFamily: 'SOYO_Maple_regular'),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 118, 191, 126),
                    onPrimary: Colors.white, // 버튼의 글자색
                  ),                  
                ),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(
                    '레시피 등록',
                    style: TextStyle(fontFamily: 'SOYO_Maple_regular'),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 118, 191, 126),
                    onPrimary: Colors.white, // 버튼의 글자색
                    // 추가적인 스타일 요소들을 여기에 추가할 수 있습니다.
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
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        fontFamily: 'SOYO_Maple_regular',
                      ),
                    ),
                  ),
              child: TextFormField(
                controller: _ingredientNameControllers[i],
                decoration: InputDecoration(
                  labelText: '재료 ${i + 1}',
                  labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'),                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    ),

                    ),
                onChanged: (value) {
                  _ingredients[i]['ingredient'] = value;
                },
                validator: (value) => value!.isEmpty ? '재료를 입력하세요.' : null,
              ),
            ),
            ),
            Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        fontFamily: 'SOYO_Maple_regular',
                      ),
                    ),
                  ),
              child: TextFormField(
                controller: _ingredientQuantityControllers[i],
                decoration: InputDecoration(
                  labelText: '재료의 양',
                  labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'),                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  
                  ),
                onChanged: (value) {
                  _ingredients[i]['quantity'] = value;
                },
                validator: (value) => value!.isEmpty ? '재료의 양을 입력하세요.' : null,
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
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        fontFamily: 'SOYO_Maple_regular',
                      ),
                    ),
                  ),
              child: TextFormField(
                controller: _stepControllers[i],
                decoration: InputDecoration(
                  labelText: '순서 ${i + 1}',
                  labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'),                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  
                  ),
                onChanged: (value) {
                  _steps[i] = value;
                },
                validator: (value) => value!.isEmpty ? '요리 순서를 입력하세요.' : null,
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
