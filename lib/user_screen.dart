import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'bottomnavbar.dart';
import './user_screens/userWidgets/points_widget.dart';
import './user_screens/rules.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _secureStorage = FlutterSecureStorage();
  String? _token;
  late int _userId = 0;
  late String _username = '';
  late Map<String, dynamic> userData = {};
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadUsername();
    _loadUserId();
  }

  Future<void> _loadToken() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token != null) {
        setState(() {
          _token = token;
          print('Loaded token: $_token'); //debug
          fetchUserData();
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
          print('Loaded userId: $_userId'); //debug
          fetchUserData();
          fetchFavoriteExercises();
          fetchFavoriteTrainings();
        });
      } else {
        print('Failed to load userId: Key not found');
      }
    } catch (e) {
      print('Error loading userId: $e');
    }
  }

  Future<void> _loadUsername() async {
    try {
      final username = await _secureStorage.read(key: 'username');
      if (username != null) {
        setState(() {
          _username = username;
          print('Loaded username: $_username');
        });
      } else {
        print('Failed to load username: Key not found');
      }
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  Future<void> fetchUserData() async {
    if (_token == null) {
      print('Token is not loaded yet');
      return;
    }
    try {
      final response = await Dio().get(
        'http://localhost:3002/$_userId',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          userData = response.data;
        });
      } else {
        print('Failed to fetch user data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchFavoriteExercises() async {
    if (_token == null) {
      print('Token is not loaded yet');
      return;
    }
    try {
      final response = await Dio().get(
        'http://localhost:3000/favorites/$_userId',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          userData['favoriteExercises'] = response.data;
        });
      } else {
        print('Failed to fetch favorite exercises');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchFavoriteTrainings() async {
    if (_token == null) {
      print('Token is not loaded yet');
      return;
    }
    try {
      final response = await Dio().get(
        'http://localhost:3001/favorites/$_userId',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          userData['favoriteTrainings'] = response.data;
        });
      } else {
        print('Failed to fetch favorite exercises');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavbar(
      selectedIndex: _selectedIndex,
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(400),
          child: AppBar(
            //to je del z ikono avatarja, številom točk in ikonama za informacije in urejanje
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFFED467),
            flexibleSpace: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('images/avatar_2.png'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _username.isNotEmpty ? _username : 'User Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 12, 12, 12),
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Add your edit functionality here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RulesPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PointsWidget(points: userData['points'] ?? 0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // leva poravnava
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //leva poravnava
                  children: [
                    Text(
                      'Moje vaje', //del za vaje
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (userData.containsKey('favoriteExercises'))
                      ...List<Widget>.generate(
                        userData['favoriteExercises'].length,
                        (index) {
                          var exercise = userData['favoriteExercises'][index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ListTile(
                              title: Text(
                                exercise['name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // levo poravnano
                                children: [
                                  Text(
                                    "Duration: ${exercise['duration']} minutes",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    "Calories: ${exercise['calories']} kcal",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 10),
                    Text(
                      'Moji treningi', //del za treninge
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (userData.containsKey('favoriteTrainings'))
                      ...List<Widget>.generate(
                        userData['favoriteTrainings'].length,
                        (index) {
                          var training = userData['favoriteTrainings'][index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ListTile(
                              title: Text(
                                training['name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // vse je levo poravnano
                                children: [
                                  Text(
                                    "Duration: ${training['duration']} minutes",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    "Calories: ${training['calories']} kcal",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    "Difficulty: ${training['difficulty']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
