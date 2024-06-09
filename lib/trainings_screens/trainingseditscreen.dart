import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  // Variables for calculating total duration and calories
  int _totalCalories = 0;
  int _totalDuration = 0;

  // List to store selected exercise IDs
  List<String> _selectedExerciseIds = [];

  @override
  void initState() {
    super.initState();
    _trainingNameController = TextEditingController();
    _durationController = TextEditingController();
    _caloriesController = TextEditingController();

    // Pre-fill fields with training details
    _trainingNameController.text = widget.trainingDetails['name'];
    _selectedDifficulty = widget.trainingDetails['difficulty'];
    _durationController.text = widget.trainingDetails['duration'].toString();
    _caloriesController.text = widget.trainingDetails['calories'].toString();

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
        'http://localhost:3000/',
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
        Exercise? removedExercise;
        futureExercises.then((exercises) {
          removedExercise = exercises.firstWhere(
            (exercise) => exercise.id == exerciseId,
          );
          if (removedExercise != null) {
            _totalCalories -= removedExercise!.calories;
            _totalDuration -= removedExercise!.duration;
            _selectedExerciseIds.remove(exerciseId);
          }
          _caloriesController.text = _totalCalories.toString();
          _durationController.text = _totalDuration.toString();
        });
      }
    });
  }

  Future<void> _submitTrainingData() async {
    final String trainingName = _trainingNameController.text;
    final String duration = _durationController.text;
    final String calories = _caloriesController.text;
    final String difficulty = _selectedDifficulty;

    try {
      final dio = Dio();
      List<String> selectedExerciseIds = [];
      for (Exercise exercise in await futureExercises) {
        if (_selectedExerciseIds.contains(exercise.id)) {
          selectedExerciseIds.add(exercise.id);
        }
      }
      final response = await dio.post(
        'http://localhost:3001/',
        data: {
          'name': trainingName,
          'duration': duration,
          'calories': calories,
          'difficulty': difficulty,
          'exerciseIds': selectedExerciseIds,
          'userId': _userId.toString(),
        },
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 201) {
        print('Training successfully inserted');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training successfully inserted'),
            duration: Duration(seconds: 2),
          ),
        );
        // Reset form
        _trainingNameController.clear();
        _durationController.clear();
        _caloriesController.clear();
      } else {
        throw Exception('Error inserting training');
      }
    } catch (e) {
      print('Error inserting training: $e');
      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inserting training: $e'),
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
        title: Text('Edit Training'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Name'),
            SizedBox(height: 8.0),
            TextField(
              controller: _trainingNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Difficulty'),
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
            Text('Duration (minutes)'),
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
            Text('Calories'),
            SizedBox(height: 8.0),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitTrainingData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFED467),
              ),
              child: Text('Update Training',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            Text('Exercises',
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
                        bool isSelected = widget.trainingDetails['exerciseIds']
                            .contains(exercise.id);
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
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

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
            value: _isSelected,
            activeColor: Color(0xFFFED467), // Color when exercise is checked
            onChanged: (bool? value) {
              setState(() {
                _isSelected = value ?? false;
                widget.onExerciseSelected(
                    widget.exercise.id,
                    _isSelected, // Saves value to list. Calculation of calories and duration of each exercise happens during submission
                    widget.exercise.calories,
                    widget.exercise.duration);
              });
            },
          ),
        ));
  }
}
