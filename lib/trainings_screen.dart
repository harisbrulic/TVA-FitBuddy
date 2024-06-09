import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './input/traininginputscreen.dart';
import './bottomnavbar.dart';
import './trainings_screens/trainingdetails.dart';

class TrainingsPage extends StatefulWidget {
  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  late Future<List<Training>> futureTrainings = Future.value([]);
  late String _token = '';
  late int _userId = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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

  @override
  Widget build(BuildContext context) {
    return BottomNavbar(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFED467),
          title: Text('Treningi'),
        ),
        body: FutureBuilder<List<Training>>(
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
                  return TreningiItem(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainingInputPage()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFFED467),
          shape: CircleBorder(),
          elevation: 6.0,
          highlightElevation: 12.0,
        ),
      ),
      selectedIndex: 1, // Assuming index 1 is for TrainingsPage
    );
  }
}

class Training {
  final String id; // Add ID field
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
