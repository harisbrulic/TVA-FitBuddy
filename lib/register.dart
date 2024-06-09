import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'login_page.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isPolicyAccepted = false;
  bool _isPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _selectedGender;

  Future<void> _registerUser() async {
    try {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty ||
          _weightController.text.isEmpty ||
          _heightController.text.isEmpty ||
          _selectedGender == null) {
        throw Exception('Izpolnite vsa polja.');
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        throw Exception('Gesli se ne ujemata.');
      }

      if (_passwordController.text.length <= 4) {
        throw Exception('Geslo mora imeti vsaj 5 znakov.');
      }

      final dio = Dio();
      final response = await dio.post(
        'http://localhost:3002/register',
        data: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'gender': _selectedGender,
          'weight': _weightController.text,
          'height': _heightController.text,
        },
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        throw Exception('Napaka pri registraciji: ${response.data}');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Napaka'),
            content: Text('$e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _registerForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Registracija',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 32.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 24.0),
          _buildTextField('Ime', Icons.person, _nameController),
          SizedBox(height: 16.0),
          _buildTextField('E-naslov', Icons.email, _emailController),
          SizedBox(height: 16.0),
          _buildPasswordField('Geslo', Icons.lock, _passwordController),
          SizedBox(height: 16.0),
          _buildPasswordField(
              'Potrditev gesla', Icons.lock, _confirmPasswordController),
          SizedBox(height: 16.0),
          _buildGenderDropdownField('Spol', Icons.person),
          SizedBox(height: 16.0),
          _buildTextField('Teža (kg)', Icons.height, _weightController),
          SizedBox(height: 16.0),
          _buildTextField('Višina (cm)', Icons.line_weight, _heightController),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Checkbox(
                value: _isPolicyAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    _isPolicyAccepted = value!;
                  });
                },
              ),
              Text(
                'Seznanjen sem s pogoji uporabe.',
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
                onPressed: () {
                  if (_isPolicyAccepted) {
                    _registerUser();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Napaka'),
                          content:
                              Text('Strinjati se morate s pogoji uporabe.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Color(0xFFFED467),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Registriraj se',
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
            'Že imate profil?',
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
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Prijavite se tukaj.',
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
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdownField(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          icon: Icon(icon),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: (String? value) {
            setState(() {
              _selectedGender = value!;
            });
          },
          items: ['Moški', 'Ženska'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _registerForm(),
      ),
    );
  }
}
