import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../exercise_screen.dart';

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

class TrainingInputPage extends StatefulWidget {
  @override
  _TrainingInputPageState createState() => _TrainingInputPageState();
}

class _TrainingInputPageState extends State<TrainingInputPage> {
  late TextEditingController _trainingNameController;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  String _selectedDifficulty = 'Easy';

  final List<String> _difficultyLevels = ['Easy', 'Medium', 'Hard'];
  late Future<List<Exercise>> futureExercises = Future.value([]);

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late String _token = '';
  late int _userId = 0;

  // spremenljivki za seštevanje trajanja in kalorij
  int _totalCalories = 0;
  int _totalDuration = 0;

  // tukaj shranim vse id odkljukanih vaj
  List<String> _selectedExerciseIds = [];

  @override
  void initState() {
    super.initState();
    _trainingNameController = TextEditingController();
    _durationController = TextEditingController();
    _caloriesController = TextEditingController();
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

  // za izbiro vaj (checkout)
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
        _selectedExerciseIds.remove(exerciseId); //seštevanje
      }
      _caloriesController.text = _totalCalories.toString();
      _durationController.text = _totalDuration.toString();
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
        print('Trening uspešno vstavljen');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training successfully inserted'),
            duration: Duration(seconds: 2),
          ),
        );
        // resetiranje obrazca
        _trainingNameController.clear();
        _durationController.clear();
        _caloriesController.clear();
      } else {
        throw Exception('Napaka pri vstavljanju treninga.');
      }
    } catch (e) {
      print('Napaka pri vstavljanju treninga: $e');
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
        title: Text('Dodaj trening'),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitTrainingData();
                String trainingName = _trainingNameController.text;
                String duration = _durationController.text;
                String calories = _caloriesController.text;
                String difficulty = _selectedDifficulty;
                print('Selected Exercise IDs: $_selectedExerciseIds'); //debug
                print('Training Name: $trainingName');
                print('Difficulty: $difficulty');
                print('Duration: $duration minutes');
                print('Calories: $calories');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExerciseScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFED467),
              ),
              child: Text('Vstavi trening',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
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
                        return ExerciseItem(
                          exercise: snapshot.data![index],
                          onExerciseSelected:
                              _handleExerciseSelection, //tukaj se vrši seštevanje kalorij in trajanja
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Vaja ne obstaja."));
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
  final Function(String, bool, int, int) onExerciseSelected;

  ExerciseItem({required this.exercise, required this.onExerciseSelected});

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  bool _isSelected = false;

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
            'Trajanje: ${widget.exercise.duration} minut\nCalories: ${widget.exercise.calories} kcal',
          ),
          trailing: Checkbox(
            value: _isSelected,
            activeColor: Color(0xFFFED467), // barva, ko je odkljukana vaja
            onChanged: (bool? value) {
              setState(() {
                _isSelected = value ?? false;
                widget.onExerciseSelected(
                    widget.exercise.id,
                    _isSelected, //tukaj shrani vrednost v seznam. V handle submition gre skozi seznam pridobi kalorije in trajanje posamezne vaje in jih sešteva
                    widget.exercise.calories,
                    widget.exercise.duration);
              });
            },
          ),
        ));
  }
}
