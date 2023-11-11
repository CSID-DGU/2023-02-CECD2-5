import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'menu.dart';

class VegetableDetailPage extends StatefulWidget {
  final int vegetableId;
  final double price;
  final String unit;

  VegetableDetailPage({
    Key? key,
    required this.vegetableId,
    required this.price,
    required this.unit,
    }) : super(key: key){
      print('VegetableDetailPage: price = $price, unit = $unit');
    }

  @override
  _VegetableDetailPageState createState() => _VegetableDetailPageState();
}

class _VegetableDetailPageState extends State<VegetableDetailPage> {
  late Future<Map<String, dynamic>> vegetableDetail;

  @override
  void initState() {
    super.initState();
    vegetableDetail = fetchVegetableDetail(widget.vegetableId);
  }

  Future<Map<String, dynamic>> fetchVegetableDetail(int id) async {
    final response = await http.get(
      Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/$id'),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load vegetable detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
        actions: <Widget>[
          buildPopupMenuButton(context),
        ]
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: vegetableDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
final data = snapshot.data!['data'];
          return ListView(
            children: [
              ListTile(
                title: Text(data['name'], style: TextStyle(fontSize: 24, fontFamily: 'SOYO_Maple_Bold')),
                trailing: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // 즐겨찾기 관련 동작
                  },
                ),
              ),
              Divider(thickness: 2,), // 밑줄 추가
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(data['image'], height: 200),
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.price}원 / ${widget.unit}',
                        style: TextStyle(fontSize: 20, fontFamily: 'SOYO_Maple_Bold',),
                      ),
                    ),
                  ),
                ],
              ),
              // 레시피 섹션
              Padding(
                padding: const EdgeInsets.all(8.0),
                
                child: Text(
                  '보관법\n\n${data['storageMethod']}',
                  style: TextStyle(fontSize: 16, fontFamily: 'SOYO_Maple_Regular',),
                ),
              ),
              // 추가기능구현위치
            ],
          );
          // ...
        };
        }
      ),
    );
  }
}