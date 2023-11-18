import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'graph.dart';

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
  bool likesData = false;
  late Future<Map<String, dynamic>> vegetableDetail;
  Map<String, double> processedGraphData = {}; // 초기화
  Map<String, bool> processedLikesData = {};

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

      likesData = await fetchLikes(id);
      print(likesData);

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

  Future<bool> fetchLikes(int id) async {
    final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetableLikes/isLikes/$id');
    User user = await UserApi.instance.me();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),

    );
    print('Vegetable Likes Response: $response');

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json['data']);
      return json['data'];
    } else {
      throw Exception('Failed to load likes data');
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
                  title: Padding(
                    padding: const EdgeInsets.only(top:5, left: 12.0), // Adjust the left padding as needed
                    child: Text(
                      data['name'],
                      style: TextStyle(fontSize: 24, fontFamily: 'SOYO_Maple_Bold'),
                    ),
                  ),

                  trailing: IconButton(
                    padding: const EdgeInsets.only(top: 5, left: 12.0),
                    icon: likesData
                        ? Icon(Icons.favorite, color: Colors.red) // 좋아요일 때는 색깔 있는 하트
                        : Icon(Icons.favorite_border), // 좋아요가 아닐 때는 빈 하트
                    onPressed: () async {
                      User user = await UserApi.instance.me();
                      final url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetableLikes/${widget.vegetableId}');

                      if (likesData) {
                        // 이미 좋아요한 경우에는 삭제
                        final response = await http.delete(
                          url,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                        );
                      } else {
                        // 좋아요하지 않은 경우에는 추가
                        final response = await http.post(
                          url,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({'userId': '${user.id}', 'userName': '${user.kakaoAccount?.profile?.nickname}'}),
                        );
                      }

                      // 상태 갱신
                      setState(() {
                        likesData = !likesData; // 토글
                      });
                    },
                    iconSize: 30,
                  ),
                ),
                Divider(thickness: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top:20, left: 20.0, bottom:20, right:20),
                        child: Image.network(data['image'], height: 130),
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right:30), // 원하는 간격 설정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '최저가 ',
                                  style: TextStyle(fontSize: 20, fontFamily: 'SOYO_Maple_Bold'),
                                ),
                                Text(
                                  '(${widget.unit} 당)',
                                  style: TextStyle(fontSize: 16, fontFamily: 'SOYO_Maple_Regular'),
                                ),
                              ],
                            ),
                            SizedBox(height: 15), // 가격과 단위 사이 간격 조절
                            Text(
                              '${widget.price.round()}원',
                              style: TextStyle(fontSize: 22, fontFamily: 'SOYO_Maple_Regular'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 2,),
                VegetableGraph(vegetableId: widget.vegetableId),
                Divider(thickness: 2,),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    
                    child: Text(
                      '보관법',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SOYO_Maple_Bold',
                      ),
                    ), 
                  ),
                ),
                Padding(
                  
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right:20),
                  child: Text(
                    '${data['storageMethod']}',
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

