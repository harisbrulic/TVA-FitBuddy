import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'register.dart';
import 'onboarding_1.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  void _checkSecureStorage() async {
    final token = await _secureStorage.read(key: 'token');
    final userId = await _secureStorage.read(key: 'userId');
    final username = await _secureStorage.read(key: 'username');

    print('Token: $token');
    print('User ID: $userId');
    print('Username: $username');
  }

  Future<int?> _extractUserId(String token) async {
    try {
      final response = await Dio().get(
        'http://localhost:3002/getId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Get ID response: $response');

      if (response.statusCode == 200) {
        // Return the user ID as an integer
        return response.data['id'];
      } else {
        print('Failed to extract user ID: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error extracting user ID: $e');
      return null;
    }
  }

  Future<String?> _extractUsername(String token) async {
    try {
      final response = await Dio().get(
        'http://localhost:3002/getUsername',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Get username response: $response');

      if (response.statusCode == 200) {
        return response.data['name'];
      } else {
        print('Failed to extract username: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error extracting username: $e');
      return null;
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text;
    final password = _passwordController.text;

    print('Logging in with email: $email');

    try {
      final response = await Dio().post(
        'http://localhost:3002/login', // Ensure this is the correct URL
        data: {'email': email, 'password': password},
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token == null) {
          throw Exception('Token is null');
        }

        // Store the token securely
        await _secureStorage.write(key: 'token', value: token);

        // Extract user ID and username
        final userId = await _extractUserId(token);
        final username = await _extractUsername(token);

        // Save user ID and username in secure storage
        await _secureStorage.write(
            key: 'userId', value: userId?.toString() ?? '0');
        await _secureStorage.write(key: 'username', value: username ?? '');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen1()),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid login credentials')),
        );
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unauthorized: Invalid email or password')),
        );
      } else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildLoginForm(context),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: const Color(0xFFFBFE),
              height: 120.0,
              width: 120.0,
              alignment: Alignment.center,
            ),
            Text(
              'Prijava',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'E-naslov',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/icons/email.png',
                        width: 25,
                        height: 25,
                        color: Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Geslo',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/icons/lock.png',
                        width: 25,
                        height: 25,
                        color: Colors.black,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Checkbox(value: false, onChanged: (bool? value) {}),
                Text(
                  'Zapomni si me',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: Container(
                width: 170,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await _login();
                            _checkSecureStorage();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: Color(0xFFFED467),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Prijavi se',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              'Še nimaš profila?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: Text(
                'Registriraj se tukaj.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
