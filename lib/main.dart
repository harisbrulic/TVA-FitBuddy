import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('sl_SI', null);

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'token');
  final rememberMe = await secureStorage.read(key: 'rememberMe') ?? 'false';

  Widget defaultHome =
      SplashScreen(); //ko user prvič odpre app, se mu pokaze splash screen

  if (token != null && rememberMe == 'true') {
    defaultHome = HomeScreen();
  } //ko user odpre app in je ze prijavljen, se mu pokaze home screen

  runApp(MyApp(defaultHome: defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  MyApp({required this.defaultHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: defaultHome,
    );
  }
}
