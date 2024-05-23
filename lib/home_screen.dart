import 'package:flutter/material.dart';
import 'exercise_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFED467),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zdravo Nina',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text(
                      'Domov',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Container(), // Empty container as body
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons
                .directions_run), // Use the DirectionsRun icon for exercises
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            Color(0xFFFED467), // Change selected item color to yellow
        unselectedItemColor: Colors.grey, // Set unselected item color to gray
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            switch (index) {
              case 0:
                // Navigate to home_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // Replace HomeScreen() with your home screen widget
                );
                break;
              case 1:
                // Navigate to exercises_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseScreen()), // Replace ExerciseScreen() with your exercise screen widget
                );
                break;
              case 2:
                // Navigate to input_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // Replace InputScreen() with your input screen widget
                );
                break;
              case 3:
                // Navigate to analytics_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // Replace AnalyticsScreen() with your analytics screen widget
                );
                break;
              case 4:
                // Navigate to profile_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // Replace ProfileScreen() with your profile screen widget
                );
                break;
            }
          });
        },
      ),
    );
  }
}
