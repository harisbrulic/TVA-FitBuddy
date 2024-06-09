import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './trainingseditscreen.dart';

class TrainingDetailsScreen extends StatefulWidget {
  final String trainingId;

  TrainingDetailsScreen({required this.trainingId});

  @override
  _TrainingDetailsScreenState createState() => _TrainingDetailsScreenState();
}

class _TrainingDetailsScreenState extends State<TrainingDetailsScreen> {
  final _secureStorage = FlutterSecureStorage();
  String? _token;
  Map<String, dynamic> trainingDetails = {};

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
          fetchTrainingDetails();
        });
      } else {
        print('Failed to load token: Key not found');
      }
    } catch (e) {
      print('Error loading token: $e');
    }
  }

  Future<void> fetchTrainingDetails() async {
    if (_token == null) {
      print('Token is not loaded yet');
      return;
    }
    try {
      final response = await Dio().get(
        'http://localhost:3001/${widget.trainingId}',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          trainingDetails = response.data;
        });
      } else {
        print('Failed to fetch training details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _editTraining() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingEditScreen(
          trainingDetails: trainingDetails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Details'),
        backgroundColor: Color(0xFFFED467),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Training Name: ${trainingDetails['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Duration: ${trainingDetails['duration']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Calories: ${trainingDetails['calories']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Difficulty: ${trainingDetails['difficulty']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editTraining,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFED467),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Uredi trening',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
