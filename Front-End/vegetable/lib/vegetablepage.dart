import 'package:flutter/material.dart';
import 'package:vegetable/vegetable_detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mainpage.dart';
import 'underbar.dart';
import 'menu.dart';

Future<List<Map<String, dynamic>>> fetchVegetables() async {
  final response = await http.get(
    Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable'),
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return List<Map<String, dynamic>>.from(jsonResponse['data']);
  } else {
    print("Error fetching vegetables: ${response.body}");
    throw Exception('Failed to load vegetables from the server');
  }
}

class VegetablePage extends StatefulWidget {
  @override
  _VegetablePageState createState() => _VegetablePageState();
}

class _VegetablePageState extends State<VegetablePage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  String _searchQuery = "";
  List<Map<String, dynamic>> _allVegetables = [];
  List<Map<String, dynamic>> _filteredVegetables = [];

  @override
  void initState() {
    super.initState();
    _fetchVegetables();
  }

  Future<void> _fetchVegetables() async {
    var vegetables = await fetchVegetables();
    setState(() {
      _allVegetables = vegetables;
      _filteredVegetables = vegetables;
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      if (newQuery.isNotEmpty) {
        _filteredVegetables = _allVegetables.where((vegetable) {
          return vegetable['name'].toLowerCase().contains(newQuery.toLowerCase());
        }).toList();
      } else {
        _filteredVegetables = _allVegetables;
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
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text(
          "채소",
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
        ],
      ),
      endDrawer: buildMenuDrawer(context),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchVegetables(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // _allVegetables를 최초 로드한 후에는 _filteredVegetables 리스트를 사용합니다.
          _allVegetables = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: (MediaQuery.of(context).size.width) / (100 + 16),
            ),
            itemCount: _isSearching ? _filteredVegetables.length : _allVegetables.length,
            itemBuilder: (context, index) {
              final vegetable = _isSearching ? _filteredVegetables[index] : _allVegetables[index];
                double rate = vegetable['rate'];
                int vegetableId = vegetable['id'];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VegetableDetailPage(
                        vegetableId: vegetableId,
                        price: vegetable['price'],
                        unit: vegetable['unit'].toString(),
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
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.network(
                              vegetable['image'],
                              fit: BoxFit.contain,
                              height: 100, // 이미지의 높이를 지정합니다.
                            ),
                          ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('${vegetable['name']}',
                              style: TextStyle(fontSize: 20, fontFamily: 'SOYO_Maple_Bold',)),),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets. only(right: 20.0),
                                  child: Text(
                                    '${(rate > 0 ? '+' : '')}${((vegetable['rate'] as double) * 100).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'SOYO_Maple_Bold',
                                      color: rate > 0 ? Colors.red : (rate == 0 ? Colors.black : Colors.blue),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    '${vegetable['price'].round()}원 / ${vegetable['unit']}',
                                    style: TextStyle(
                                      fontFamily: 'SOYO_Maple_Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),
                    ),
                  ),
                );
              },
            );
          }
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