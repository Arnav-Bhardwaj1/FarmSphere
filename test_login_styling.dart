// Test the login screen styling
// You can test this by running: dart run test_login_styling.dart

import 'package:flutter/material.dart';
import 'lib/screens/auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmSphere Login Test',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}


