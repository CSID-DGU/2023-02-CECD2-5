import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vegetable/recipe_info.dart';
import 'recipe_maker.dart';
import 'menu.dart';

class RecipeListPage extends StatefulWidget {
  final int vegetableId;
  final String vegetableName;

  RecipeListPage({required this.vegetableId, required this.vegetableName});

  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  List<dynamic>? recipes;
  bool _isSearching = false;
  String _searchQuery = "";
  List<Map<String, dynamic>> _allRecipes = [];
  List<Map<String, dynamic>> _filteredRecipes = [];
  
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
      setState(() {
        recipes = jsonResponse['data'];
        _allRecipes = List<Map<String, dynamic>>.from(recipes!);
        _filteredRecipes = _allRecipes;
      });
    }
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      if (newQuery.isNotEmpty) {
        _filteredRecipes = _allRecipes.where((recipe) {
          return recipe['title'].toLowerCase().contains(newQuery.toLowerCase());
        }).toList();
      } else {
        _filteredRecipes = _allRecipes;
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    List<dynamic> displayRecipes = _isSearching ? _filteredRecipes : recipes ?? [];

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
          ? _buildSearchField()
          : Text(
            widget.vegetableName + '요리 레시피',
            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
          ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
        leading: Navigator.of(context).canPop()
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
        actions: <Widget>[
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                });
              },
            ),
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: buildMenuDrawer(context),
      body: displayRecipes.isEmpty
        ? Center(
            child: Text(
              "레시피를 추가해주세요",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'SOYO_Maple_Bold',
              ),
              textAlign: TextAlign.center,
            ),
          )

        : ListView.builder(
            itemCount: displayRecipes.length,
            itemBuilder: (context, index) {
              final recipe = displayRecipes[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(
                      recipeId: recipe['id'],
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 12.0, right: 8.0, bottom: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: Image.network(
                                recipe['image'],
                                fit: BoxFit.contain,
                                height: 100,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${recipe['title']}',
                                style: TextStyle(fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    '${recipe['writer'].substring(0, 1)}OO',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'SOYO_Maple_Bold'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    '${recipe['createdDate']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'SOYO_Maple_Regular'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      floatingActionButton: Container(
        width: 80.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MakeRecipePage(vegetableId: widget.vegetableId, vegetableName: widget.vegetableName),
              ),
            ).then((_) {
              fetchRecipes();
            });
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Flexible(
                  flex: 2,
                  child: Icon(Icons.add_circle_outline),
                ),
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Flexible(
                  flex: 4,
                  child: Text(
                    '등록',
                    style: TextStyle(fontSize: 18, fontFamily: 'SOYO_Maple_Bold'),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 118, 191, 126),
        ),
      ),
    );
  }
}
