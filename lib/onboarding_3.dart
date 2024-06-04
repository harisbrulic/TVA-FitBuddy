import 'package:flutter/material.dart';
import 'onboarding_4.dart';

class OnboardingScreen3 extends StatefulWidget {
  @override
  _OnboardingScreen3State createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: _buildOnboardingContent(context),
      ),
    );
  }

  Widget _buildOnboardingContent(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 24,
          alignment: Alignment.center,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // dodaj home screen
            },
            child: Text(
              'Preskoči',
              style: TextStyle(
                color: Color(0xffb3b2b4),
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 30.0,
          color: Colors.white,
        ),
        Container(
          height: 252.0,
          width: 332.0,
          child: Image.asset('assets/images/onboarding3.png'),
        ),
        SizedBox(height: 28),
        Text(
          'Sestavljanje treningov',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Treninge lahko najdeš na zavihku Treningi. Poleg vrivzetih, lahko ustvariš tudi svoje s pomočjo vaj. Tako si lahko sebi prilagodiš vsak trening. Ustvari jih glede na počutje in energijo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat'
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Container(
            width: 120,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OnboardingScreen4()),
                            );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 0),
                backgroundColor: Color(0xFFFED467),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF7F6A34),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 8, color: Color(0xffb3b2b4)),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
          ],
        ),
      ],
    ),
  );
}
}
