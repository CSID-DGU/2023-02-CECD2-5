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
  String selectedUnit = '';
  List<String> units = [];
  Future<Map<String, double>>? chartData;


  @override
  void initState() {
    super.initState();
    fetchDataUnits().then((_) {
      if (units.isNotEmpty) {
        setState(() {
          selectedUnit = units.first;
          chartData = fetchDataForUnit(widget.vegetableId, selectedUnit);
        });
      }
    });
  }

  Future<void> fetchDataUnits() async {
    var url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/${widget.vegetableId}/graph');
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      // 'data' 리스트 내의 모든 'unit' 값을 추출하여 중복을 제거합니다.
      units = jsonResponse['data']
          .map<String>((item) => item['unit'] as String)
          .toSet()
          .toList();
    } else {
      throw Exception('Failed to load units');
    }
  }

  Future<Map<String, double>> fetchDataForUnit(int id, String unit) async {
  var url = Uri.parse('http://ec2-54-180-36-184.ap-northeast-2.compute.amazonaws.com:8080/vegetable/$id/graph');
  print('Fetching graph data from: $url');

  try {
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> responseData = jsonResponse['data'];
        Map<String, double> data = {};

        for (var item in responseData) {
          if (item['unit'] == unit) {  // 선택된 유닛에 맞는 데이터만 필터링
            String date = item['date'];
            double price = item['price']?.toDouble() ?? 0.0;
            data[date] = price;
          }
        }

        return data;
      } else {
        throw Exception('Invalid data format');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 유닛 선택 버튼

        
        // 그래프 표시
        Flexible(
          fit: FlexFit.loose,
          child: FutureBuilder<Map<String, double>>(
            future: chartData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                return Container(
                  height: 300.0,
                  child: MyLineChart(data: snapshot.data!),
                );
              } else {
                return Text("No data available");
              }
            },
          ),
        ),
                if (units.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: units.map((unit) => ElevatedButton(
              onPressed: () => setState(() {
                selectedUnit = unit;
                chartData = fetchDataForUnit(widget.vegetableId, unit);
              }),
              child: Text(unit),
            )).toList(),
          ),
      ],
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
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 50),
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
                reservedSize: 50,
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



