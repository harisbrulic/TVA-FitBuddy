import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/bottomnavbar.dart';
import 'input_screen.dart';
import 'package:flutter_application_1/header.dart';
import 'package:intl/intl.dart';

class DailyInputScreen extends StatefulWidget {
  @override
  _DailyInputScreenState createState() => _DailyInputScreenState();
}

class _DailyInputScreenState extends State<DailyInputScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
                  SizedBox(height: 20),
                  Container(
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
                            VnosItem(
                              color: Color(0xffffc52e),
                              value: '1500',
                              label: 'kcal',
                              iconPath: 'assets/icons/fire.png',
                            ),
                            VnosItem(
                              color: Color(0xff99c5ed),
                              value: '3',
                              label: 'kozarca',
                              iconPath: 'assets/icons/waterglass.png',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputScreen(selectedDate: _selectedDay)),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFFFED467),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ),
      ),
    );
  }
}

class VnosItem extends StatelessWidget {
  final Color color;
  final String value;
  final String label;
  final String iconPath;

  VnosItem({
    required this.color,
    required this.value,
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 8),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: 50,
              height: 50,
            ),
          ),
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
      ],
    );
  }
}