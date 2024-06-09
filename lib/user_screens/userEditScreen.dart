import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../user_screen.dart';
import '../login_page.dart';
import 'package:intl/intl.dart';

class EditUserScreen extends StatefulWidget {
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _secureStorage = FlutterSecureStorage();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  late String _token;
  late String _userId;
  String _selectedGender = 'Moški';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      final userId = await _secureStorage.read(key: 'userId');
      if (token != null && userId != null) {
        setState(() {
          _token = token;
          _userId = userId;
          print('Loaded token: $_token');
          print('Loaded userId: $_userId');
          fetchUserDetails();
        });
      } else {
        print('Token or userId not found');
      }
    } catch (e) {
      print('Error loading token or userId: $e');
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await Dio().get(
        'http://localhost:3002/$_userId',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        final userData = response.data;
        setState(() {
          _nameController.text = userData['name'];
          _emailController.text = userData['email'];
          _genderController.text = userData['gender'];
          _heightController.text = userData['height'].toString();
          _weightController.text = userData['weight'].toString();
        });
      } else {
        print('Napaka pri pridobivanju podatkov');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveUserToDatabase() async {
    try {
      final response = await Dio().put(
        'http://localhost:3002/$_userId',
        data: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'gender': _selectedGender,
          'height': double.parse(_heightController.text),
          'weight': double.parse(_weightController.text),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        print('Uspešna posodobitev profila.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserScreen()),
        );
      } else {
        print('Napaka pri posodabljanju.');
      }
    } catch (e) {
      print('Napaka pri posodabljanju: $e');
    }
  }

  void _checkUserDetails() {
    // validacija pdoatkov
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prosim, izpolnite vsa polja')),
      );
      return;
    }
    // gesla preverim samo, če nista prazni polji
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gesli se ne ujemata')),
      );
      return;
    }

    _saveUserToDatabase();
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await Dio().delete(
        'http://localhost:3002/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uporabnik uspešno izbrisan'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Neuspeh pri brisanju uporabnika'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Napaka: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFED467),
        title: Text('Nastavitve profila'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _checkUserDetails,
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 199, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              child: Text(
                'Shrani',
                style: TextStyle(
                  color: const Color.fromARGB(255, 29, 29, 29),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                'Osnovni podatki',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              _buildLabeledBoxedTextFormField(
                label: 'Ime',
                controller: _nameController,
              ),
              SizedBox(height: 20.0),
              _buildLabeledBoxedTextFormField(
                label: 'E-naslov',
                controller: _emailController,
              ),
              SizedBox(height: 20.0),
              _buildLabeledBoxedTextFormField(
                label: 'Geslo',
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              _buildLabeledBoxedTextFormField(
                label: 'Potrdi geslo',
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              Text(
                'Dodatno',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              _buildGenderDropdown(), // Insert the gender dropdown here
              SizedBox(height: 20.0),
              _buildLabeledBoxedTextFormField(
                label: 'Višina',
                controller: _heightController,
              ),
              SizedBox(height: 20.0),
              _buildLabeledBoxedTextFormField(
                label: 'Teža',
                controller: _weightController,
              ),
              SizedBox(height: 20.0),
              _buildConfirmationSection(), // Add the confirmation section
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledBoxedTextFormField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    bool readOnly = false, // datum rojstva se lahko samo bere
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spol',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            value: _selectedGender,
            items: ['Moški', 'Ženska'].map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedGender = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Napredno',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 20),
            Icon(Icons.error_outline, color: Colors.red, size: 32.0),
          ],
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 32.0),
              SizedBox(width: 20),
              Flexible(
                child: Text(
                  'Brisanje profila je akcija, kjer se bodo zbrisali vsi podatki, ki so navezani na ta profil iz našega sistema. Prosimo za previdnost pri tej akciji. Ali ste prepričani da želite izgubiti celotni napredek?',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
            onPressed: () {
              // varnost (vpraša, če res želi uporabnik izbrisati račun)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Potrditev brisanja profila"),
                    content: Text(
                        "Ali ste prepričani, da želite izbrisati svoj profil?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Prekliči"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          deleteUser(_userId);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          "Zbriši profil",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            ),
            child: Text(
              'Zbriši profil',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
