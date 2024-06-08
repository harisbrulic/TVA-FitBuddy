import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/bottomnavbar.dart';
import 'input_screen.dart';
import 'package:flutter_application_1/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class DailyInputScreen extends StatefulWidget {
  @override
  _DailyInputScreenState createState() => _DailyInputScreenState();
}

class _DailyInputScreenState extends State<DailyInputScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List _dailyInputs = [];
  Map<DateTime, List> _events = {};
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Dio _dio = Dio();
  Map<DateTime, dynamic> _dailyInputsMap = {};

  @override
  void initState() {
    super.initState();
    _loadDailyInputs();
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<int?> _getUserId() async {
    final userId = await _secureStorage.read(key: 'userId');
    return userId != null ? int.parse(userId) : null;
  }

  Future<void> _loadDailyInputs() async {
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token or User ID is null!')),
      );
      return;
    }

    try {
      final response = await _dio.get(
        'http://localhost:3003/',
        queryParameters: {'userId': userId.toString()},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List dailyInputs = response.data;
        Map<DateTime, dynamic> inputsMap = {
          for (var input in dailyInputs) DateTime.parse(input['date']): input
        };
        setState(() {
          _dailyInputs = dailyInputs;
          _dailyInputsMap = inputsMap;
          _events = {
            for (var input in dailyInputs)
              DateTime.parse(input['date']): ['Event']
          };
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prišlo je do napake.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prišlo je do napake.')),
      );
    }
  }

  int _getCaloriesForSelectedDay() {
    final input = _dailyInputsMap[_selectedDay];
    return input != null ? int.parse(input['calories'].toString()) : 0;
  }

  int _getWaterForSelectedDay() {
    final input = _dailyInputsMap[_selectedDay];
    return input != null ? int.parse(input['water'].toString()) : 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavbar(
      selectedIndex: 2,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          appBar: Header(title: 'Dnevni vnos'),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onDoubleTap: () async {
                        final existingEntry = _dailyInputsMap[_selectedDay];
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputScreen(
                              selectedDate: _selectedDay,
                              existingEntry: existingEntry,
                            ),
                          ),
                        );
                        if (result == true) {
                          _loadDailyInputs();
                        }
                      },
                      child: TableCalendar(
                        locale: 'sl_SI',
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        eventLoader: (day) {
                          return _events[day] ?? [];
                        },
                        calendarStyle: CalendarStyle(
                          selectedTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            color: Color(0xff000000),
                          ),
                          defaultTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff000000),
                          ),
                          weekendTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff000000),
                          ),
                          outsideTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xffb3b2b4),
                          ),
                          disabledTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xffb3b2b4),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFFFED467),
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Color(0xffb3b2b4),
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: Color(0xFFFED467),
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildProgressSection(),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputScreen(
                    selectedDate: _selectedDay,
                  ),
                ),
              );
              if (result == true) {
                _loadDailyInputs();
              }
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFFFED467),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final int dailyCalories = _getCaloriesForSelectedDay();
    final int dailyWater = _getWaterForSelectedDay();
    final int maxCalories = 2500;
    final int maxWater = 8;
    final double caloriesProgress = dailyCalories / maxCalories;
    final double waterProgress = dailyWater / maxWater;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff2f2f2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vnos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem(
                color: Color(0xffffc52e),
                value: dailyCalories.toString(),
                label: 'kcal',
                iconPath: 'assets/icons/fire.png',
                progress: caloriesProgress,
                max: maxCalories,
              ),
              _buildProgressItem(
                color: Color(0xff99c5ed),
                value: dailyWater.toString(),
                label: 'kozarca',
                iconPath: 'assets/icons/waterglass.png',
                progress: waterProgress,
                max: maxWater,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem({
    required Color color,
    required String value,
    required String label,
    required String iconPath,
    required double progress,
    required int max,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80.0,
              height: 80.0,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 8,
              ),
            ),
            Center(
              child: Image.asset(
                iconPath,
                width: 48.0,
                height: 48.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xff000000),
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff000000),
          ),
        ),
        Text(
          'od $max',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff000000),
          ),
        ),
      ],
    );
  }
}
