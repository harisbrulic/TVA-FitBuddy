import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bottomnavbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String _username = '';
  final FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUsername();
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

  Future<void> _showDialog(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ali želite odpreti članek?'),
          actions: <Widget>[
            TextButton(
              child: Text('Ne'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Da'),
              onPressed: () async {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  await launchUrl(uri);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              padding: const EdgeInsets.only(left: 16.0, top: 40.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Zdravo, $_username!',
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 150.0,
                  width: 360.0,
                  child: InkWell(
                    onTap: () => _showDialog(context, 'https://www.tek.si'),
                    child: Center(
                      child: Image.asset(
                        'assets/images/tekdanes.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 150.0,
                  width: 360.0,
                  child: InkWell(
                    onTap: () => _showDialog(context, 'https://www.okusno.je'),
                    child: Center(
                      child: Image.asset(
                        'assets/images/kajzakosilo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 150.0,
                  width: 360.0,
                  child: InkWell(
                    onTap: () => _showDialog(context, 'https://www.jogaline.si/blog/kaj-je-joga'),
                    child: Center(
                      child: Image.asset(
                        'assets/images/jogazazacetnike.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
