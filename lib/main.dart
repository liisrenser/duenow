import 'package:flutter/material.dart';
import 'package:duenow/screens/home.dart';

void main() {
  runApp(const DueNowApp());
}

class DueNowApp extends StatelessWidget {
  const DueNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}