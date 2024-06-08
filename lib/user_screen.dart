import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadUserId();
    _loadUsername();
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
        'http://localhost:3002/userData', // Adjust the endpoint to your API route
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(500), // Set the height of the orange header
        child: AppBar(
          automaticallyImplyLeading: false, // Remove the back arrow
          backgroundColor: Color(0xFFFED467),
          flexibleSpace: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80, // Increase the radius for a bigger avatar
                  backgroundImage: NetworkImage(
                      'https://example.com/profile-image.jpg'), // Replace with actual URL
                ),
                SizedBox(height: 10),
                Text(
                  _username.isNotEmpty ? _username : 'User Name',
                  style: TextStyle(
                    fontSize: 24, // Increase font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Točke',
                  style: TextStyle(
                    fontSize: 16, // Adjust font size as needed
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Other widgets can go here...
          ],
        ),
      ),
    );
  }
}
