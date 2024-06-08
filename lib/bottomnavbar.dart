import 'package:flutter/material.dart';
import 'package:flutter_application_1/input/dailyinput_screen.dart';
import './home_screen.dart';
import './exercise_screen.dart';
import './analytics_screen.dart';
import './user_screen.dart';

class BottomNavbar extends StatefulWidget {
  final Widget body;
  final int selectedIndex;

  BottomNavbar({required this.body, required this.selectedIndex});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ExerciseScreen()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DailyInputScreen()),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AnalyticsScreen()),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserScreen()),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            label: 'Domov',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/exercisesgray.png')),
            label: 'Vaje',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/vnos.png')),
            label: 'Vnos',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/analyticsgray.png')),
            label: 'Analitika',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/name.png')),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFED467),
        unselectedItemColor: Color(0xffb3b2b4),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
