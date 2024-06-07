import 'package:flutter/material.dart';
import 'onboarding_2.dart';
import '../home_screen.dart';

class OnboardingScreen1 extends StatefulWidget {
  @override
  _OnboardingScreen1State createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Preskoči'),
          content: Text('Ali ste prepričani, da želite preskočiti uvod?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ne'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Da'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                        onTap: _showSkipDialog,
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
                      height: 273.0,
                      width: 295.0,
                      child: Image.asset('assets/images/onboarding1.png'),
                    ),
                    SizedBox(height: 28),
                    Text(
                      'Dobrodošli na FitBuddy!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Čestitamo, naredil/a si prvi korak pri izboljševanju zdravja i počutja. Prvi koraki so najtežji, zato smo mi tukaj, da ti olajšamo začetek i podamo motivacijo za bolj aktivno življenje.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(child: Container()),
                    Center(
                      child: Container(
                        width: 120,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OnboardingScreen2()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                        Icon(Icons.circle, size: 8, color: Color(0xffb3b2b4)),
                        SizedBox(width: 8),
                        Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
                        SizedBox(width: 8),
                        Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
                        SizedBox(width: 8),
                        Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
