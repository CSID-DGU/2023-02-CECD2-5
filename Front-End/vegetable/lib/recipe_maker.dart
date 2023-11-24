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
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        fontFamily: 'SOYO_Maple_regular',
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126),
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '레시피 제목',
                        labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'), // 레이블에 폰트 적용
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    onChanged: (value) => _recipeName = value,
                    validator: (value) => value!.isEmpty ? '제목을 입력하세요.' : null,
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
                if (!_isPhotoSelected) // 사진이 선택되지 않았을 때의 경고 메시지
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '사진을 선택해주세요.',
                      style: TextStyle(color: Colors.red, fontFamily: 'SOYO_Maple_regular'),
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
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(
                    '레시피 등록',
                    style: TextStyle(fontFamily: 'SOYO_Maple_bold',
                    fontSize: 17.0),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 118, 191, 126),
                    onPrimary: Colors.white, // 버튼의 글자색
                    fixedSize: Size(120, 60)
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
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126),
                        ),
                      ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _ingredientNameControllers[i],
                    decoration: InputDecoration(
                      labelText: '재료 ${i + 1}',
                      labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'),                  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  onChanged: (value) {
                  _ingredients[i]['ingredient'] = value;
                },
                validator: (value) => value!.isEmpty ? '재료를 입력하세요.' : null,
              ),
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126),
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _ingredientQuantityControllers[i],
                      decoration: InputDecoration(
                        labelText: '재료의 양',
                        labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'),                  
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  onChanged: (value) {
                    _ingredients[i]['quantity'] = value;
                  },
                  validator: (value) => value!.isEmpty ? '재료의 양을 입력하세요.' : null,
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
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: TextStyle(
                        fontFamily: 'SOYO_Maple_regular',
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 118, 191, 126),
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _stepControllers[i],
                      decoration: InputDecoration(
                        labelText: '순서 ${i + 1}',
                        labelStyle: TextStyle(fontFamily: 'SOYO_Maple_regular'),                  
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.all(8.0),
                        ),
                      onChanged: (value) {
                        _steps[i] = value;
                      },
                      validator: (value) => value!.isEmpty ? '요리 순서를 입력하세요.' : null,
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
