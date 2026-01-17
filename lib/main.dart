import 'package:flutter/material.dart';
import 'ui/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APTKA Train App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primaryColor: const Color(0xFFFF6D00),
        cardColor: const Color(0xFF2C2C2C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6D00),
          secondary: Color(0xFFE65100),
          surface: Color(0xFF2C2C2C),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}