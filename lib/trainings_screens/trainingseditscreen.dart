import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../trainings_screen.dart';

class Exercise {
  final String id;
  final String name;
  final int duration;
  final int calories;

  Exercise({
    required this.id,
    required this.name,
    required this.duration,
    required this.calories,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      name: json['name'],
      duration: json['duration'],
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'calories': calories,
    };
  }
}

class TrainingEditScreen extends StatefulWidget {
  final Map<String, dynamic> trainingDetails;

  TrainingEditScreen({required this.trainingDetails});

  @override
  _TrainingEditScreenState createState() => _TrainingEditScreenState();
}

class _TrainingEditScreenState extends State<TrainingEditScreen> {
  late TextEditingController _trainingNameController;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  String _selectedDifficulty = 'Easy';
  final List<String> _difficultyLevels = ['Easy', 'Medium', 'Hard'];
  late Future<List<Exercise>> futureExercises = Future.value([]);
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late String _token = '';
  late int _userId = 0;
  int _totalCalories = 0;
  int _totalDuration = 0;
  List<String> _selectedExerciseIds = [];

  @override
  void initState() {
    super.initState();
    _trainingNameController = TextEditingController();
    _durationController = TextEditingController();
    _caloriesController = TextEditingController();
    print('Training details: ${widget.trainingDetails}');
    _trainingNameController.text = widget.trainingDetails['name'];
    _selectedDifficulty = widget.trainingDetails['difficulty'];
    _durationController.text = widget.trainingDetails['duration'].toString();
    _caloriesController.text = widget.trainingDetails['calories'].toString();
    _totalDuration = widget.trainingDetails['duration'];
    _totalCalories = widget.trainingDetails['calories'];
    _selectedExerciseIds =
        List<String>.from(widget.trainingDetails['exerciseIds']);

    _loadTokenAndUserId().then((_) {
      setState(() {
        futureExercises = fetchExercises();
      });
    });
  }

  @override
  void dispose() {
    _trainingNameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _loadTokenAndUserId() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      final userIdString = await _secureStorage.read(key: 'userId');
      if (token != null && userIdString != null) {
        setState(() {
          _token = token;
          _userId = int.parse(userIdString);
        });
      } else {
        print('Failed to load token or userId');
      }
    } catch (e) {
      print('Error loading token or userId: $e');
    }
  }

  Future<List<Exercise>> fetchExercises() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://10.0.2.2:3000/',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse
            .map((exercise) => Exercise.fromJson(exercise))
            .toList();
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }

  void _handleExerciseSelection(
      String exerciseId, bool isSelected, int calories, int duration) {
    setState(() {
      if (isSelected) {
        _totalCalories += calories;
        _totalDuration += duration;
        _selectedExerciseIds.add(exerciseId);
      } else {
        _totalCalories -= calories;
        _totalDuration -= duration;
        _selectedExerciseIds.remove(exerciseId);
      }
      _caloriesController.text = _totalCalories.toString();
      _durationController.text = _totalDuration.toString();
    });
  }

  void _submitTrainingData(BuildContext context) async {
    final String trainingId = widget.trainingDetails['_id'];
    final String trainingName = _trainingNameController.text;
    final String duration = _durationController.text;
    final String calories = _caloriesController.text;
    final String difficulty = _selectedDifficulty;

    try {
      final dio = Dio();
      final response = await dio.put(
        'http://10.0.2.2:3001/$trainingId',
        data: {
          'name': trainingName,
          'duration': duration,
          'calories': calories,
          'difficulty': difficulty,
          'exerciseIds': _selectedExerciseIds,
          'userId': _userId.toString(),
        },
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        print('Training successfully updated');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uspešna posodobitev treninga'),
            duration: Duration(seconds: 2),
          ),
        );
        _trainingNameController.clear();
        _durationController.clear();
        _caloriesController.clear();
      } else {
        throw Exception('Napaka pri posodabljanju treninga');
      }
    } catch (e) {
      print('Error updating training: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Napaka pri posodabljanju treninga: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFED467),
        title: Text('Uredi trening'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ime'),
            SizedBox(height: 8.0),
            TextField(
              controller: _trainingNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Težavnost'),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _difficultyLevels.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDifficulty = newValue!;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Trajanje (minute)'),
            SizedBox(height: 8.0),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            SizedBox(height: 16.0),
            Text('Kalorije'),
            SizedBox(height: 8.0),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitTrainingData(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingsPage()),
                );
              },
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
            SizedBox(height: 16.0),
            Text('Vaje',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: futureExercises,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = snapshot.data![index];
                        bool isSelected =
                            _selectedExerciseIds.contains(exercise.id);
                        return ExerciseItem(
                          exercise: exercise,
                          isSelected: isSelected,
                          onExerciseSelected: _handleExerciseSelection,
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Exercise not found."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;
  final bool isSelected;
  final Function(String, bool, int, int) onExerciseSelected;

  ExerciseItem({
    required this.exercise,
    required this.isSelected,
    required this.onExerciseSelected,
  });

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          widget.exercise.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Duration: ${widget.exercise.duration} minutes\nCalories: ${widget.exercise.calories} kcal',
        ),
        trailing: Checkbox(
          value: widget.isSelected,
          activeColor: Color(0xFFFED467),
          onChanged: (bool? value) {
            setState(() {
              widget.onExerciseSelected(
                widget.exercise.id,
                value ?? false,
                widget.exercise.calories,
                widget.exercise.duration,
              );
            });
          },
        ),
      ),
    );
  }
}
