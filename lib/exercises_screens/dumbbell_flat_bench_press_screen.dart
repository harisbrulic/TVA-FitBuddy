import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'exercise_widget/exercise_details_widget.dart'; // Import ExerciseDetailsWidget
import 'exercise_widget/exercise_details_widget2.dart'; // Import ExerciseDetailsWidget2

class DumbellBenchScreen extends StatefulWidget {
  final String exerciseId;

  DumbellBenchScreen({required this.exerciseId});

  @override
  _DumbellBenchScreenState createState() => _DumbellBenchScreenState();
}

class _DumbellBenchScreenState extends State<DumbellBenchScreen> {
  Map<String, dynamic> exerciseDetails = {};

  @override
  void initState() {
    super.initState();
    fetchExerciseDetails();
  }

  Future<void> fetchExerciseDetails() async {
    try {
      // Fetch exercise details using Dio with the exerciseId
      final response =
          await Dio().get('http://localhost:3000/${widget.exerciseId}');
      if (response.statusCode == 200) {
        setState(() {
          exerciseDetails = response.data;
        });
      } else {
        // Handle error
        print('Failed to fetch exercise details');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dumbbell flat bench press'),
        backgroundColor: Color(0xFFFED467),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            children: [
              Column(
                children: [
                  ExerciseDetailsWidget(
                    series: exerciseDetails['series'] ?? 3,
                    repetitions: exerciseDetails['repetitions'] ?? '3-6',
                    duration: exerciseDetails['duration'] ?? 0,
                  ),
                  SizedBox(height: 20),
                ],
              ),
              ExerciseDetailsWidget2(
                calories: exerciseDetails['calories'] ?? 100,
                type: exerciseDetails['type'] ?? 'Strength',
                difficulty: exerciseDetails['difficulty'] ?? 'Intermediate',
              ),
              SizedBox(height: 20),
              // Container for the GIF
              Container(
                padding: EdgeInsets.all(26.0), // Padding around the GIF
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Gray background color
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // White background color for GIF
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Image.asset(
                    '/exercise_gifs/buterfly.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Container for the procedure text
              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Gray background color
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Postopek izvedbe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '''- Lezite na ravno klop in v vsako roko vzemite utež z ročajem, pri čemer je ročaj usmerjen naprej. 
- Postavite stopala na tla in jih poravnajte s koleni (stopala so lahko tudi za njimi). Naredite lok v spodnjem delu hrbta in potisnite prsni koš navzgor. 
- Dlan naj bo obrnjena naprej. Počasi spustite uteži ven in navzdol do ravni prsi, pri čemer so komolci usmerjeni pod kotom 45 stopinj.
- Pazite na pravilen kot komolcev (do 45 stopinj).''',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
