import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyLineChartTestApp());

class MyLineChartTestApp extends StatefulWidget {
  @override
  _MyLineChartTestAppState createState() => _MyLineChartTestAppState();
}

class _MyLineChartTestAppState extends State<MyLineChartTestApp> {
  String selectedUnit = '';
  List<String> units = [];
  Future<Map<String, double>>? chartData;

  @override
  void initState() {
    super.initState();
    initializeChartData();
  }

  void initializeChartData() async {
    await fetchDataUnits();
    if (units.isNotEmpty) {
      setState(() {
        selectedUnit = units.first;
        chartData = fetchDataForUnit(selectedUnit);
      });
    }
  }

  Future<void> fetchDataUnits() async {
    var url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/5/graph');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var decodedString = utf8.decode(response.bodyBytes);
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['success'] == true && decodedResponse['data'] != null) {
        List<dynamic> responseData = decodedResponse['data'];
        units = responseData.map((item) => item['unit'] as String).toSet().toList();
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, double>> fetchDataForUnit(String unit) async {
    var url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/5/graph');
    var response = await http.get(url);

    Map<String, double> data = {};
    if (response.statusCode == 200) {
      var decodedString = utf8.decode(response.bodyBytes);
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['success'] == true && decodedResponse['data'] != null) {
        List<dynamic> responseData = decodedResponse['data'];
        for (var item in responseData) {
          if (item['unit'] == unit) {
            String date = item['date'];
            double price = item['price']?.toDouble() ?? 0.0;
            data[date] = price;
          }
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Line Chart Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: chartData != null
                  ? FutureBuilder(
                      future: chartData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return MyLineChart(data: snapshot.data as Map<String, double>);
                        }
                      },
                    )
                  : CircularProgressIndicator(),
              ),
              if (units.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: units.map((unit) => ElevatedButton(
                    onPressed: () => setState(() {
                      selectedUnit = unit;
                      chartData = fetchDataForUnit(unit);
                    }),
                    child: Text(unit),
                  )).toList(),
                ),
            ],
          ),
        ),
      ),
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
        // 오류 처리: 잘못된 날짜 형식 등
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
        // 오류 처리
      }
      return null;
    }).where((spot) => spot != null).cast<FlSpot>().toList();


    double maxY = data.values.fold(0, (max, e) => e > max ? e : max);
    double minY = data.values.fold(maxY, (min, e) => e < min ? e : min);
    double interval = _calculateYAxisInterval(maxY, minY);

    maxY += interval;
    minY -= interval;

    return Padding(
      padding: const EdgeInsets.all(30.0),
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
    );
  }

  double _calculateYAxisInterval(double maxY, double minY) {
    // 최대값과 최솟값의 차를 6으로 나누어 간격을 계산합니다.
    double range = maxY - minY;
    return range / 5;
  }
}



