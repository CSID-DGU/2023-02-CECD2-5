import 'package:flutter/material.dart';
import 'underbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchVegetables() async {
  print("Fetching vegetables from API...");

  final response = await http.get(Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable'));

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
  int _selectedIndex = 0; // 현재 선택된 하단바 아이템의 인덱스

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("채소 페이지"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 기능을 여기에 추가합니다.
            },
          ),
          PopupMenuButton(
            onSelected: (value) {
              // 선택한 항목에 따른 작업을 처리합니다.
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("옵션 1"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("옵션 2"),
              ),
            ],
          ),
        ],
      ),
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
                childAspectRatio: (MediaQuery.of(context).size.width) / (100 + 16), // 이미지 높이 + 여백
              ),
              itemCount: vegetables.length,
              itemBuilder: (context, index) {
                final vegetable = vegetables[index];
                double rate = vegetable['rate'];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Image.network(
                            vegetable['image'],
                            fit: BoxFit.contain,
                            height: 100, // 이미지의 높이를 지정합니다.
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text('${vegetable['name']}',
                          style: TextStyle(fontSize: 16)),),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${vegetable['price'].round()} 원 / ${vegetable['unit']}',
                              style: TextStyle(fontSize: 16)),
                              Text(
                                '${((vegetable['rate'] as double) * 100).toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: rate > 0 ? Colors.red : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: null
    );
  }
}