import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'graph.dart'; // 이 부분은 실제 프로젝트의 구조에 맞게 조정하세요.

class VegetableDetailPage extends StatefulWidget {
  final int vegetableId;
  final double price;
  final String unit;

  VegetableDetailPage({
    Key? key,
    required this.vegetableId,
    required this.price,
    required this.unit,
  }) : super(key: key) {
    print('VegetableDetailPage: price = $price, unit = $unit');
  }

  @override
  _VegetableDetailPageState createState() => _VegetableDetailPageState();
}

class _VegetableDetailPageState extends State<VegetableDetailPage> {
  late Future<Map<String, dynamic>> vegetableDetail;
  Map<String, double> processedGraphData = {}; // 초기화

  @override
  void initState() {
    super.initState();
    vegetableDetail = fetchVegetableDetail(widget.vegetableId);
  }

  Future<Map<String, dynamic>> fetchVegetableDetail(int id) async {
    final vegetableResponse = await http.get(
      Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/$id'),
    );
    print('Vegetable Detail Response: $vegetableResponse');

    if (vegetableResponse.statusCode == 200) {
      // 식물 상세 정보를 불러온 후 그래프 데이터도 함께 가져오기
      final graphData = await fetchGraphData(widget.vegetableId.toString());
      processedGraphData = processGraphData(graphData);
      print('Processed Graph Data: $processedGraphData'); // 처리된 데이터 확인

      return json.decode(utf8.decode(vegetableResponse.bodyBytes));
    } else {
      throw Exception('Failed to load vegetable detail');
    }
  }

  Future<List<dynamic>> fetchGraphData(String vegetableId) async {
    final url = 'http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/$vegetableId/graph';
    final response = await http.get(Uri.parse(url));
    print('Graph Data Response: $response');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load graph data');
    }
  }

  Map<String, double> processGraphData(List<dynamic> data) {
    Map<String, List<double>> groupedData = {};
    Map<String, double> processedData = {};

    for (var item in data) {
      String date = item['date'];
      double price = item['price'].toDouble();

      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(price);
    }

    groupedData.forEach((date, prices) {
      double averagePrice = prices.reduce((a, b) => a + b) / prices.length;
      processedData[date] = averagePrice;
    });

    return processedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vegetable Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color.fromARGB(255, 118, 191, 126),
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
                      // 즐겨찾기 기능
                    },
                  ),
                ),
                Divider(thickness: 2,),
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
                          style: TextStyle(fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
                        ),
                      ),
                    ),
                  ],
                ),
                VegetableGraph(vegetableId: widget.vegetableId),
                Padding(
                  
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '보관법\n\n${data['storageMethod']}',
                    style: TextStyle(fontSize: 16, fontFamily: 'SOYO_Maple_Regular'),
                  ),
                ),
                
              ],
            );
          }
        },
      ),
    );
  }
}

