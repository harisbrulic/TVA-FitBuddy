import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'exercise_widget/exercise_details_widget.dart';
import 'exercise_widget/exercise_details_widget2.dart';
import 'exercise_widget/exercise_details_widget3.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;

  ExerciseDetailsScreen({required this.exerciseId, required this.exerciseName});

  @override
  _ExerciseDetailsScreenState createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  final _secureStorage = FlutterSecureStorage();
  String? _token;
  Map<String, dynamic> exerciseDetails = {};

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token != null) {
        setState(() {
          _token = token;
          print('Loaded token: $_token'); //debug
          fetchExerciseDetails();
        });
      } else {
        print('Failed to load token: Key not found');
      }
    } catch (e) {
      print('Error loading token: $e');
    }
  }

  Future<void> fetchExerciseDetails() async {
    if (_token == null) {
      print('Token is not loaded yet');
      return;
    }
    try {
      final response = await Dio().get(
        'http://10.0.2.2:3000/${widget.exerciseId}',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          exerciseDetails = response.data;
        });
      } else {
        print('Failed to fetch exercise details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
        backgroundColor: Color(0xFFFED467),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            children: [
              Column(
                children: [
                  ExerciseDetailsWidget(
                    series: exerciseDetails['series'] ?? 0,
                    repetitions: exerciseDetails['repetitions'] ?? '0',
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
              Container(
                padding: EdgeInsets.all(26.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Image.asset(
                    'assets/exercise_gifs/${widget.exerciseName.toLowerCase().replaceAll(' ', '_')}.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    ExerciseDetailsWidget3(
                      description: exerciseDetails['description'] ?? '',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
