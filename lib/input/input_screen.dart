import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InputScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? existingEntry;

  InputScreen({required this.selectedDate, this.existingEntry});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  bool _isTrainingCompleted = false;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _waterController.text = widget.existingEntry!['water'].toString();
      _caloriesController.text = widget.existingEntry!['calories'].toString();
      _isTrainingCompleted = widget.existingEntry!['trainingFinished'] ?? false;
    }
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<int?> _getUserId() async {
    final userId = await _secureStorage.read(key: 'userId');
    return userId != null ? int.parse(userId) : null;
  }

  Future<void> _saveDailyInput() async {
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token is null!')),
      );
      return;
    }

    final data = {
      'water': _waterController.text,
      'calories': _caloriesController.text,
      'trainingFinished': _isTrainingCompleted,
      'date': widget.selectedDate.toIso8601String(),
      'userId': userId,
    };

    try {
      if (widget.existingEntry != null) {
        final response = await _dio.put(
          'http://10.0.2.2:3003/${widget.existingEntry!['_id']}',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          data: data,
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Prišlo je do napake.')),
          );
        }
      } else {
        // Create new entry
        final response = await _dio.post(
          'http://10.0.2.2:3003/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          data: data,
        );

        if (response.statusCode == 201) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Prišlo je do napake.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prišlo je do napake.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFFED467),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 50.0, bottom: 15.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.selectedDate.day}. ${DateFormat.MMMM('sl_SI').format(widget.selectedDate)}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveDailyInput();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffffc52e),
                    foregroundColor: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.existingEntry != null ? 'Uredi' : 'Dodaj',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Dnevni vnos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000),
                ),
              ),
              SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voda (v kozarcih)',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000),
                    ),
                  ),
                  TextFormField(
                    controller: _waterController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vnesite količino vode!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kalorije',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000),
                    ),
                  ),
                  TextFormField(
                    controller: _caloriesController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vnesite količino kalorij!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              ListTile(
                title: Text(
                  'Trening opravljen',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000),
                  ),
                ),
                trailing: Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    value: _isTrainingCompleted,
                    onChanged: (bool value) {
                      setState(() {
                        _isTrainingCompleted = value;
                      });
                    },
                    activeColor: Color(0xff79faad),
                    inactiveThumbColor: Color(0xffb3b2b4),
                    inactiveTrackColor: Color(0xfff2f2f2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
