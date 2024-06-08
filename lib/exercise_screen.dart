import 'package:flutter/material.dart';
import 'exercises_screens/ExerciseDetails.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './bottomnavbar.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late Future<List<Exercise>> futureExercises;
  bool _isVajeSelected = true;
  int _selectedIndex = 1;
  late String _token = '';
  late int _userId = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadUserId();
    futureExercises = fetchExercises();
  }

  Future<void> _loadToken() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token != null) {
        setState(() {
          _token = token;
          futureExercises = fetchExercises();
        });
      } else {
        print('Failed to load token: Key not found');
      }
    } catch (e) {
      print('Error loading token: $e');
    }
  }

  Future<void> _loadUserId() async {
    try {
      final userIdString = await _secureStorage.read(key: 'userId');
      if (userIdString != null) {
        final userId = int.parse(userIdString);
        setState(() {
          _userId = userId;
        });
      } else {
        print('Failed to load userId: Key not found');
      }
    } catch (e) {
      print('Error loading userId: $e');
    }
  }

  Future<List<Exercise>> fetchExercises() async {
    try {
      final dio = Dio();
      final response = _isVajeSelected
          ? await dio.get(
              'http://localhost:3000/',
              options: Options(headers: {'Authorization': 'Bearer $_token'}),
            )
          : await dio.get(
              'http://localhost:3000/favourites',
              options: Options(headers: {'Authorization': 'Bearer $_token'}),
            );
      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse
            .map((exercise) => Exercise.fromJson(exercise))
            .toList();
      } else {
        throw Exception('Napaka pri nalaganju vaj');
      }
    } catch (e) {
      throw Exception('Napaka pri nalaganju vaj');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavbar(
      selectedIndex: _selectedIndex,
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFFED467),
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 40.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Aktivnosti',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                        return ExerciseCard(
                          exercise: snapshot.data![index],
                          userId: _userId,
                          token: _token,
                        );
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
      ),
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final int duration;
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
      duration: json['duration'],
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'duration': duration, 'calories': calories};
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final int userId;
  final String token;

  ExerciseCard(
      {required this.exercise, required this.userId, required this.token});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isFavorite = false;

  Future<void> postExercise() async {
    try {
      final response = await Dio().post(
        'http://localhost:3000/favorite',
        data: {
          ...widget.exercise.toJson(),
          'userId': widget.userId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vaja uspešno dodana med všečkane vaje'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Neuspeh pri dodajanju vaje'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vaja je že dodana med všečkane vaje'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> deleteExercise() async {
    try {
      final response = await Dio().delete(
        'http://localhost:3000/favorite',
        data: {
          'name': widget.exercise.name,
          'userId': widget.userId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vaja uspešno odstranjena iz všečkanih vaj'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Neuspeh pri odstranjevanju vaje'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vaja ni bila všečkana'),
          duration: Duration(seconds: 3),
        ),
      );
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Duration: ${widget.exercise.duration} minutes",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                "Calories: ${widget.exercise.calories} kcal",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  postExercise();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                onPressed: () {
                  deleteExercise();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
