import 'package:flutter/material.dart';
import 'exercises_screens/ExerciseDetails.dart';
import 'home_screen.dart';
import 'package:dio/dio.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late Future<List<Exercise>> futureExercises;
  bool _isVajeSelected = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises();
  }

  Future<List<Exercise>> fetchExercises() async {
    try {
      final response = _isVajeSelected
          ? await Dio().get('http://localhost:3000/')
          : await Dio().get('http://localhost:3000/favourites');

      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse
            .map((exercise) => Exercise.fromJson(exercise))
            .toList();
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Failed to load exercises');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivnosti'),
        backgroundColor: Color(0xFFFED467),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isVajeSelected = false;
                    futureExercises = fetchExercises();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: _isVajeSelected
                      ? MaterialStateProperty.all<Color>(Colors.white)
                      : MaterialStateProperty.all<Color>(Color(0xFFFED467)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 16, horizontal: 52)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Color(0xFFFED467)),
                    ),
                  ),
                ),
                child: Text(
                  'Treningi',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isVajeSelected = true;
                    futureExercises = fetchExercises();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: _isVajeSelected
                      ? MaterialStateProperty.all<Color>(Color(0xFFFED467))
                      : MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 16, horizontal: 52)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Color(0xFFFED467)),
                    ),
                  ),
                ),
                child: Text(
                  'Vaje',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Exercise>>(
              future: futureExercises,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ExerciseCard(exercise: snapshot.data![index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFED467),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseScreen(),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
            }
          });
        },
      ),
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final int duration; // Add duration field
  final int calories;

  Exercise(
      {required this.id,
      required this.name,
      required this.duration,
      required this.calories});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      name: json['name'],
      duration: json['duration'], // Assuming duration is an integer field
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'duration': duration, 'calories': calories};
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  ExerciseCard({required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isFavorite = false;

  Future<void> toggleFavorite() async {
    try {
      final response = await Dio().post(
        'http://localhost:3000/favorite',
        data: {'favourite': !_isFavorite},
      );

      if (response.statusCode == 201) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      print('Failed to toggle favorite exercise: $e');
    }
  }

  Future<void> postExercise() async {
    try {
      final response = await Dio().post(
        'http://localhost:3000/favorite', // Replace with your endpoint
        data: widget.exercise.toJson(),
      );

      if (response.statusCode == 201) {
        print('Exercise posted successfully');
      } else {
        throw Exception('Failed to post exercise');
      }
    } catch (e) {
      print('Error posting exercise: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailsScreen(
              exerciseId: widget.exercise.id,
              exerciseName: widget.exercise.name,
            ),
          ),
        );
      },
      child: Card(
        color: Color.fromRGBO(242, 242, 242, 1),
        margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: ListTile(
          title: Text(
            widget.exercise.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          subtitle: Text(
            "Duration: ${widget.exercise.duration} minutes",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Montserrat',
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null, // Adjusted color
            ),
            onPressed: () {
              if (_isFavorite) {
                toggleFavorite();
              } else {
                postExercise();
              }
            },
          ),
        ),
      ),
    );
  }
}
