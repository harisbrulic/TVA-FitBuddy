import 'package:flutter/material.dart';
import 'package:flutter_application_1/exercises_screens/tek_screen.dart';
import 'home_screen.dart';
import 'exercises_screens/bench_press_screen.dart';
import 'exercises_screens/deadlift_screen.dart';
import 'exercises_screens/počep_screen.dart';
//import 'exercises_screens/tek_screen.dart';
import 'exercises_screens/kolesarjenje_screen.dart';
import 'exercises_screens/jumping_jacks_screen.dart';
import 'exercises_screens/overhead_press_screen.dart';
import 'exercises_screens/pull-up_screen.dart';
import 'exercises_screens/biceps_curl_screen.dart';
import 'exercises_screens/cable_rope_pushdown_screen.dart';
import 'exercises_screens/bent_over_barbell_row_screen.dart';
import 'exercises_screens/incline_barbell_bench_press_screen.dart';
import 'exercises_screens/dumbbell_flat_bench_press_screen.dart';
import 'exercises_screens/incline_dumbbell_fly_screen.dart';
import 'exercises_screens/dips_screen.dart';
import 'exercises_screens/trap_bar_deadlift_screen.dart';
import 'exercises_screens/dumbbell_row_screen.dart';
import 'package:dio/dio.dart';
import 'models/exercise.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late Future<List<Exercise>> futureExercises;
  bool _isVajeSelected = true; // State to toggle between "Vaje" and "Treningi"
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises();
  }

  Future<List<Exercise>> fetchExercises() async {
    try {
      // Fetch exercises for "Vaje" or "Treningi" based on the state
      final response = _isVajeSelected
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
                    _isVajeSelected = false; // Show "Treningi" content
                    futureExercises = fetchExercises();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: _isVajeSelected
                      ? MaterialStateProperty.all<Color>(Colors.white)
                      : MaterialStateProperty.all<Color>(Color(0xFFFED467)),
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
                    _isVajeSelected = true; // Show "Vaje" content
                    futureExercises = fetchExercises();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: _isVajeSelected
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                // Do nothing as we're already on the Exercises screen
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
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
        onTap: () {
          // Check if the exercise name is "Bench Press"
          if (widget.exercise.name.toLowerCase() == "bench press") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BenchPressScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "deadlift") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DeadliftScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "počep") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SquatScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "tek") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RunScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "kolesarjenje") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CyclingScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "jumping jacks") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JacksScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "overhead press") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OverheadScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "pull-up") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PullupScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "biceps curl") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BicepsScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() ==
              "cable rope pushdown") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CableRopeScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() ==
              "bent over barbell row") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RowingScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() ==
              "incline barbell bench press") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InclineBenchScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() ==
              "dumbbell flat bench press") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DumbellBenchScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() ==
              "incline dumbbell fly") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlyScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "dips") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DipsScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() ==
              "trap bar deadlift") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TrapDeadliftScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else if (widget.exercise.name.toLowerCase() == "dumbbell row") {
            // Navigate to BenchPressScreen with exerciseId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DumbbelRowScreen(exerciseId: widget.exercise.id),
              ),
            );
          } else {
            // Dynamically create the screen route based on the exercise name
            String exerciseRoute =
                '${widget.exercise.name.toLowerCase().replaceAll(' ', '_')}_screen';
            Navigator.pushNamed(context, exerciseRoute);
          }
        },
      ),
    );
  }
}
