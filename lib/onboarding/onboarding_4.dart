import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';

class OnboardingScreen4 extends StatefulWidget {
  @override
  _OnboardingScreen4State createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4> {
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
                  Container(
                    height: 30.0,
                    color: Colors.white,
                  ),
                  Container(
                    height: 252.0,
                    width: 332.0,
                    child: Image.asset('assets/images/onboarding4.png'),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Sledenje po zemljevidu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Na zavihku Zemljevid boš našel/la izris poti, po kateri si hodil/a, kolesaril/a, tekel/la. Tvoje je da se aktiviraš in vse ostalo poskrbimo mi.',
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
                            MaterialPageRoute(builder: (context) => HomeScreen()),
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
                            Icons.check,
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
                      Icon(Icons.circle, size: 8, color: Color(0xfff2f2f2)),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 8, color: Color(0xffb3b2b4)),
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
