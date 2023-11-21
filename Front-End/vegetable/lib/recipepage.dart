import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_list.dart';
import 'underbar.dart';
import 'menu.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int _selectedIndex = 2;
  List<dynamic> recipeList = [];
  List<Map<String, dynamic>> _allVegetables = [];
  List<Map<String, dynamic>> _filteredVegetables = [];
  String _searchQuery = "";
  bool _isSearching = false;

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "검색어를 입력하세요",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white60),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'SOYO_Maple_Bold'),
      onChanged: _updateSearchQuery,
    );
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      if (newQuery.isNotEmpty) {
        _filteredVegetables = _allVegetables.where((recipe) {
          return recipe['name'].toLowerCase().contains(newQuery.toLowerCase());
        }).toList();
      } else {
        _filteredVegetables = _allVegetables;
      }
    });
  }

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
        title: _isSearching ? _buildSearchField() : Text(
          "레시피",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _updateSearchQuery("");
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _updateSearchQuery("");
                }
              });
            },
          ),
          // 메뉴 버튼 추가
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      endDrawer: buildMenuDrawer(context),
    body: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Set the number of columns here
        crossAxisSpacing: 8.0, // Set spacing between columns
        mainAxisSpacing: 8.0, // Set spacing between rows
      ),
      itemCount: recipeList.length,
      itemBuilder: (context, index) {
        var recipe = recipeList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeListPage(vegetableId: recipe['id'], vegetableName: recipe['name']),
              ),
            );
          },
          
          child: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 12,
                  child: Image.network(
                    recipe['image'],
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                  child: Text(
                    recipe['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SOYO_Maple_Bold',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    bottomNavigationBar: CustomBottomBar(
      selectedIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    ),
  );
}
}

