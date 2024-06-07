import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'header.dart';
import 'bottomnavbar.dart';

class AnalyticsScreen extends StatelessWidget {
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
                  Container(
                    height: 200,
                    child: charts.BarChart(
                      _createSampleData(),
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
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('15L', 'assets/icons/waterglass.png', 16.0),
                        Container(
                          height: 40,
                          child: VerticalDivider(
                            color: Color(0xffb3b2b4),
                            thickness: 1,
                          ),
                        ),
                        _buildStatCard('6', 'assets/icons/muscles.png', 16.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatCard('60 točk', 'assets/icons/xp.png', 16.0),
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

  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('9.4.', 1000),
      OrdinalSales('10.4.', 1500),
      OrdinalSales('11.4.', 2000),
      OrdinalSales('12.4.', 1200),
      OrdinalSales('13.4.', 800),
    ];

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
        SizedBox(width: 8),
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
