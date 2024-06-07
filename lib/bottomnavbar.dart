import 'package:flutter/material.dart';
import 'home_screen.dart';

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
