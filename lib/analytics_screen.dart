import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';
import 'header.dart';
import 'bottomnavbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<List<OrdinalSales>> _chartData;
  late Future<Map<String, dynamic>> _statsData;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _chartData = _fetchChartData();
    _statsData = _fetchStatsData();
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<List<OrdinalSales>> _fetchChartData() async {
    final dio = Dio();
    final token = await _getToken();
    final response = await dio.get(
      'http://10.0.2.2:3003/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (response.statusCode == 200) {
      final data = response.data as List;
      final now = DateTime.now();
      final last7Days = now.subtract(Duration(days: 7));

      final List<Map<String, dynamic>> filteredData = data
          .map((item) => {
                'date': DateTime.parse(item['date']),
                'calories': item['calories'] is int
                    ? item['calories']
                    : int.parse(item['calories'].toString())
              })
          .where((item) => item['date'].isAfter(last7Days))
          .toList();

      filteredData.sort((a, b) => a['date'].compareTo(b['date']));

      final List<OrdinalSales> chartData = filteredData.map((item) {
        final date = item['date'];
        final day = '${date.day}.${date.month}.';
        return OrdinalSales(day, item['calories']);
      }).toList();

      return chartData;
    } else {
      throw Exception('Failed to load chart data');
    }
  }

  Future<Map<String, dynamic>> _fetchStatsData() async {
    final dio = Dio();
    final token = await _getToken();
    final response = await dio.get(
      'http://10.0.2.2:3003/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (response.statusCode == 200) {
      final data = response.data as List;
      final now = DateTime.now();
      final last7Days = now.subtract(Duration(days: 7));

      int totalWater = 0;
      int totalTrainings = 0;
      data
          .map((item) => {
                'date': DateTime.parse(item['date']),
                'water': item['water'] is int
                    ? item['water']
                    : int.parse(item['water'].toString()),
                'trainingFinished': item['trainingFinished'] is bool
                    ? item['trainingFinished']
                    : item['trainingFinished'].toString().toLowerCase() ==
                        'true'
              })
          .where((item) => item['date'].isAfter(last7Days))
          .forEach((item) {
        totalWater += (item['water'] as num).toInt();
        if (item['trainingFinished']) totalTrainings++;
      });

      return {
        'totalWater': totalWater,
        'totalTrainings': totalTrainings,
      };
    } else {
      throw Exception('Failed to load stats data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavbar(
      body: Column(
        children: [
          Header(title: 'Analitika', showBackButton: false),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: const Color(0xFFFFFFFF),
                    height: 8.0,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tedenska analiza',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/info.png',
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Vnesene kalorije',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<List<OrdinalSales>>(
                    future: _chartData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No data available');
                      }
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xfff2f2f2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(16),
                        child: charts.BarChart(
                          _createSampleData(snapshot.data!),
                          animate: true,
                          domainAxis: charts.OrdinalAxisSpec(
                            renderSpec: charts.SmallTickRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: charts.MaterialPalette.black,
                              ),
                            ),
                          ),
                          primaryMeasureAxis: charts.NumericAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: charts.MaterialPalette.black,
                              ),
                            ),
                          ),
                          barRendererDecorator:
                              charts.BarLabelDecorator<String>(),
                          defaultRenderer: charts.BarRendererConfig(
                            cornerStrategy:
                                const charts.ConstCornerStrategy(30),
                            maxBarWidthPx: 20,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _statsData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final totalWater = snapshot.data?['totalWater'] ?? 0;
                      final totalTrainings =
                          snapshot.data?['totalTrainings'] ?? 0;
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              child: _buildStatCard('$totalWater',
                                  'assets/icons/waterglass.png', 20.0),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              child: _buildStatCard('$totalTrainings',
                                  'assets/icons/muscles.png', 20.0),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatCard('60 točk', 'assets/icons/xp.png', 24.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      selectedIndex: 3,
    );
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData(
      List<OrdinalSales> data) {
    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.day,
        measureFn: (OrdinalSales sales, _) => sales.calories,
        data: data,
      )
    ];
  }

  Widget _buildStatCard(String value, String iconPath, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 32,
          height: 32,
        ),
        SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}

class OrdinalSales {
  final String day;
  final int calories;

  OrdinalSales(this.day, this.calories);
}
