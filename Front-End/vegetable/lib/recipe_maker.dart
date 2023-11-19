import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MakeRecipePage extends StatefulWidget {
  final int vegetableId;

  MakeRecipePage({required this.vegetableId});

  @override
  _MakeRecipePageState createState() => _MakeRecipePageState();
}

class _MakeRecipePageState extends State<MakeRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String _recipeName = '';
  List<Map<String, String>> _ingredients = [{'ingredient': '', 'quantity': ''}];
  List<String> _steps = [''];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle any errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Recipe Name'),
                  onSaved: (value) {
                    _recipeName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe name';
                    }
                    return null;
                  },
                ),
                ..._buildIngredientFields(),
                ElevatedButton(
                  onPressed: () => _addNewIngredientField(),
                  child: Text('+ Add Ingredient'),
                ),
                ..._buildStepFields(),
                ElevatedButton(
                  onPressed: () => _addNewStepField(),
                  child: Text('+ Add Step'),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Attach Photo'),
                ),
                _selectedImage == null
                    ? Text('No image selected.')
                    : Image.file(_selectedImage!, width: 100, height: 100),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: Implement submit functionality, including handling of the image
                    }
                  },
                  child: Text('Submit Recipe'),
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
                decoration: InputDecoration(labelText: 'Ingredient'),
                initialValue: _ingredients[i]['ingredient'],
                onSaved: (value) {
                  _ingredients[i]['ingredient'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ingredient';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                initialValue: _ingredients[i]['quantity'],
                onSaved: (value) {
                  _ingredients[i]['quantity'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
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

  void _addNewIngredientField() {
    setState(() {
      _ingredients.add({'ingredient': '', 'quantity': ''});
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  List<Widget> _buildStepFields() {
    List<Widget> stepFields = [];
    for (int i = 0; i < _steps.length; i++) {
      stepFields.add(
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Step ${i + 1}'),
                initialValue: _steps[i],
                onSaved: (value) {
                  _steps[i] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a step';
                  }
                  return null;
                },
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

  void _addNewStepField() {
    setState(() {
      _steps.add('');
    });
  }

  void _removeStepField(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }
}
