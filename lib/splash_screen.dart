import 'package:flutter/material.dart';
import 'package:flutter_application_1/onboarding/onboarding_1.dart';
import 'dart:async';
import 'login_page.dart';
import 'home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _purpleAnimation;
  late Animation<double> _pinkAnimation;
  late Animation<double> _yellowAnimation;
  late Animation<double> _whiteAnimation;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _purpleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.3, curve: Curves.easeInOut)),
    );

    _pinkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.5, curve: Curves.easeInOut)),
    );

    _yellowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.4, 0.7, curve: Curves.easeInOut)),
    );

    _whiteAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();
    _navigateToNext();
  }

    Future<void> _navigateToNext() async {
    final token = await _secureStorage.read(key: 'token');
    final isFirstLogin = await _secureStorage.read(key: 'isFirstLogin') ?? 'true';

    Timer(Duration(seconds: 4), () {
      if (token != null) {
        if (isFirstLogin == 'true') {
           Navigator.pushReplacement(
            context,
        MaterialPageRoute(builder: (context) => OnboardingScreen1()),
           );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.white,
              ),
              Transform.scale(
                scale: _purpleAnimation.value * 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffa985e0),
                  ),
                ),
              ),
              Transform.scale(
                scale: _pinkAnimation.value * 4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffec8cc0),
                  ),
                ),
              ),
              Transform.scale(
                scale: _yellowAnimation.value * 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfffed467),
                  ),
                ),
              ),
              Transform.scale(
                scale: _whiteAnimation.value * 2,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/image.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
