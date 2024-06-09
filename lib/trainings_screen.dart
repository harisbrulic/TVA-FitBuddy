import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/exercise_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './input/traininginputscreen.dart';
import './bottomnavbar.dart';
import './trainings_screens/trainingdetails.dart';
import 'dart:convert';

class TrainingsPage extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  late Future<List<Training>> futureTrainings = Future.value([]);
  late String _token = '';
  late int _userId = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isDeleting = false;
  List<Training> _selectedTrainings = [];
  List<String> _selectedTrainingIds = [];

  @override
  void initState() {
    super.initState();
    _loadTokenAndUserId();
  }

  Future<void> _loadTokenAndUserId() async {
    try {
      await _loadToken();
      await _loadUserId();
      setState(() {
        futureTrainings = fetchTrainings();
        _selectedTrainingIds.clear();
      });
    } catch (e) {
      print('Error loading token, userId, or trainings: $e');
    }
  }

  Future<void> _loadToken() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token != null) {
        setState(() {
          _token = token;
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

  Future<List<Training>> fetchTrainings() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:3001/user/$_userId',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse
            .map((training) => Training.fromJson(training))
            .toList();
      } else {
        throw Exception('Failed to load trainings');
      }
    } catch (e) {
      throw Exception('Error fetching trainings: $e');
    }
  }

  Future<void> toggleFavoriteStatus(Training training) async {
    try {
      final dio = Dio();
      final response = await dio.put(
        'http://localhost:3001/favourites/${training.id}',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          training.isFavorite = !training.isFavorite;
        });
        print('Favorite status toggled successfully');
      } else {
        throw Exception('Failed to toggle favorite status');
      }
    } catch (e) {
      throw Exception('Error toggling favorite status: $e');
    }
  }

  Future<void> deleteSelectedTrainings() async {
    try {
      final dio = Dio();

      // pretvorim v json seznam
      String selectedTrainingIdsJson = jsonEncode(_selectedTrainingIds);

      // pošljem kot parameter
      final response = await dio.delete(
        'http://localhost:3001/delete-selected',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
        queryParameters: {'selectedTrainingIds': selectedTrainingIdsJson},
      );

      if (response.statusCode == 200) {
        setState(() {
          _selectedTrainings.clear();
          _selectedTrainingIds.clear();
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Izbrani treninngi uspešno izbrisani'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Napaka pri brisanju treningov');
      }
    } catch (e) {
      print('Napaka pri brisanju treningov: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Napaka pri brisanju treningov: $e\nSelected training IDs: ${_selectedTrainingIds.toString()}',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavbar(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFED467),
          title: Text('Treningi'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Izberi več',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Switch(
                    value: _isDeleting,
                    onChanged: (value) {
                      setState(() {
                        _isDeleting = value;
                        if (!_isDeleting) {
                          _selectedTrainings.clear();
                          _selectedTrainingIds.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Training>>(
                future: futureTrainings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _isDeleting
                            ? CheckboxListTile(
                                title: Text(snapshot.data![index].name),
                                value: _selectedTrainings
                                    .contains(snapshot.data![index]),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _selectedTrainings
                                          .add(snapshot.data![index]);
                                      _selectedTrainingIds
                                          .add(snapshot.data![index].id);
                                    } else {
                                      _selectedTrainings
                                          .remove(snapshot.data![index]);
                                      _selectedTrainingIds
                                          .remove(snapshot.data![index].id);
                                    }
                                  });
                                },
                              )
                            : TreningiItem(
                                training: snapshot.data![index],
                                onFavoriteToggled: () {
                                  toggleFavoriteStatus(snapshot.data![index]);
                                },
                              );
                      },
                    );
                  } else {
                    return Center(child: Text("No data found"));
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _isDeleting
            ? FloatingActionButton(
                onPressed: () {
                  deleteSelectedTrainings();
                  setState(() {
                    _selectedTrainings.clear();
                    _selectedTrainingIds.clear();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExerciseScreen()),
                  );
                },
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                elevation: 6.0,
                highlightElevation: 12.0,
              )
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrainingInputPage()),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Color(0xFFFED467),
                shape: CircleBorder(),
                elevation: 6.0,
                highlightElevation: 12.0,
              ),
      ),
      selectedIndex: 1,
    );
  }
}

class Training {
  final String id;
  final String name;
  final String duration;
  final int calories;
  bool isFavorite;

  Training({
    required this.id,
    required this.name,
    required this.duration,
    required this.calories,
    this.isFavorite = false,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['_id'],
      name: json['name'],
      duration: json['duration'].toString(),
      calories: json['calories'],
      isFavorite: json['favourite'] ?? false,
    );
  }
}

class TreningiItem extends StatelessWidget {
  final Training training;
  final VoidCallback onFavoriteToggled;

  TreningiItem({required this.training, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainingDetailsScreen(
              trainingId: training.id,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(
            training.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              'Duration: ${training.duration}\nCalories: ${training.calories} kcal'),
          trailing: IconButton(
            icon: Icon(
              training.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: training.isFavorite ? Colors.red : null,
            ),
            onPressed: onFavoriteToggled,
          ),
        ),
      ),
    );
  }
}
