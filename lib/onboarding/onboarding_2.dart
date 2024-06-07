import 'package:flutter/material.dart';
import 'onboarding_3.dart';
import '../home_screen.dart';

class OnboardingScreen2 extends StatefulWidget {
  @override
  _OnboardingScreen2State createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
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
      body: SingleChildScrollView(
        child: ConstrainedBox( 
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
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
                    width: 114.0,
                    child: Image.asset('assets/images/onboarding2.png'),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Ustvarjanje in nadzor nad vajami',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Vaja je osnovni del treninga. V zavihku Vaje na voljo imaš pregled nad tvojimi najljubšimi vajami. Če katero ne najdeš, jo lahko enostano ustvariš.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat'
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
                            MaterialPageRoute(builder: (context) => OnboardingScreen3()),
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
                      Icon(Icons.circle, size: 8, color: Color(0xffb3b2b4)),
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
    );
  }
}
