import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'exercise_screen.dart'; // Assuming you have a file named trainings.dart for TrainingsScreen
import 'package:dio/dio.dart';
import 'models/exercise.dart';

class TrainingsScreen extends StatefulWidget {
  @override
  _TrainingsScreenState createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  late Future<List<Exercise>> futureExercises;
  int _selectedIndex = 1;

  _TrainingsScreenState() {
    // Initialize _selectedIndex to 1 for "Vaje" button by default
    _selectedIndex = 1;
  }

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises();
  }

  Future<List<Exercise>> fetchExercises() async {
    try {
      // Fetch exercises based on the selected index
      final response = _selectedIndex == 1
          ? await Dio().get('http://localhost:3000/exercises')
          : await Dio().get('http://localhost:3000/exercises/favourites');

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
        title: Text('Treningi'),
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
                    _selectedIndex =
                        0; // Set _selectedIndex to 0 for "Treningi" button
                  });
                  // Redirect to TrainingsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExerciseScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: _selectedIndex == 0
                      ? MaterialStateProperty.all<Color>(Color(0xFFFED467))
                      : MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black), // Text color
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
                    _selectedIndex =
                        1; // Set _selectedIndex to 1 for "Vaje" button
                  });
                  // Fetch exercises for "Vaje" here
                  futureExercises = fetchExercises();
                },
                style: ButtonStyle(
                  backgroundColor: _selectedIndex == 1
                      ? MaterialStateProperty.all<Color>(Color(0xFFFED467))
                      : MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black), // Text color
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
                // Do nothing as we're already on the Exercises screen
                break;
              case 2:
              case 3:
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

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  ExerciseCard({required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.pink : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
      ),
    );
  }
}
