import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VegetableGraph extends StatefulWidget {
  final int vegetableId;

  VegetableGraph({Key? key, required this.vegetableId}) : super(key: key);

  @override
  _VegetableGraphState createState() => _VegetableGraphState();
}

class _VegetableGraphState extends State<VegetableGraph> {
  late Future<Map<String, double>> chartData;

  @override
  void initState() {
    super.initState();
    chartData = fetchDataForUnit(widget.vegetableId);
  }

  Future<Map<String, double>> fetchDataForUnit(int id) async {
  var url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/$id/graph');
  print('Fetching graph data from: $url');

  try {
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var decodedResponse = json.decode(response.body);
      print('Decoded response: $decodedResponse');

      if (decodedResponse['success'] == true && decodedResponse['data'] != null) {
        List<dynamic> responseData = decodedResponse['data'];
        Map<String, double> data = {};
        
        for (var item in responseData) {
          String date = item['date'];
          double price = item['price']?.toDouble() ?? 0.0;
          data[date] = price;
        }

        return data;
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to fetch data from the server');
    }
  } catch (e) {
    print('Error fetching data: $e');
    rethrow;  // 오류를 상위로 전파
  }
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: chartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터 로딩 중
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 오류 발생
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          // 데이터가 로드되었을 때만 차트 그리기
          return MyLineChart(data: snapshot.data!);
        } else {
          // 데이터 없음
          return Text("No data available");
        }
      },
    );
  }
}

class MyLineChart extends StatelessWidget {
  final Map<String, double> data;

  MyLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = [];
    Map<double, String> dateTitles = {};

    int index = 0;
    data.forEach((key, value) {
      try {
        DateTime date = DateTime.parse(key);
        dates.add(date);
        dateTitles[index.toDouble()] = "${date.month}/${date.day}";
        index++;
      } catch (e) {
        print('Error parsing date: $e');
      }
    });

    List<FlSpot> spots = data.entries.map((entry) {
      try {
        final dateTime = DateTime.parse(entry.key);
        final dataIndex = dates.indexOf(dateTime);
        if (dataIndex != -1) {
          return FlSpot(dataIndex.toDouble(), entry.value);
        }
      } catch (e) {
        print('Error creating FlSpot: $e');
        return null;
      }
      return null;
    }).where((spot) => spot != null).cast<FlSpot>().toList();


    double maxY = data.values.fold(0, (max, e) => e > max ? e : max);
    double minY = data.values.fold(maxY, (min, e) => e < min ? e : min);
    double interval = _calculateYAxisInterval(maxY, minY);

    maxY += interval;
    minY -= interval;
    print('min, Max = $minY, $maxY');
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 300.0,

        child: LineChart(
          LineChartData(
            // 나머지 차트 설정 코드...
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                // 기타 설정...
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitles: (value) {
                  return dateTitles[value] ?? '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: interval, // y축 간격 설정 (예: 500 단위마다 레이블 표시)
                getTitles: (value) {
                  return value.toStringAsFixed(0); // y축 레이블 포맷
                },
              ),
            ), 
            minY: minY,
            maxY: maxY,           
          ),
        ),
      ),
    );
  }

  double _calculateYAxisInterval(double maxY, double minY) {
    // 최대값과 최솟값의 차를 6으로 나누어 간격을 계산합니다.
    double range = maxY - minY;
    return range / 5;
  }
}



