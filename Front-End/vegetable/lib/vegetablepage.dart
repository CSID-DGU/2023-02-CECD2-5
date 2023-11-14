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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "채소",
          style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
        ),
        
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // 검색 기능을 여기에 추가합니다.
            },
          ),
        ]
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
            final vegetables = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: (MediaQuery.of(context).size.width) / (100 + 16),
              ),
              itemCount: vegetables.length,
              itemBuilder: (context, index) {
                final vegetable = vegetables[index];
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

// vegetable_detail.dart
// 상세 페이지 구현
// 이 부분에 VegetableDetailPage 위젯을 구현합니다.
