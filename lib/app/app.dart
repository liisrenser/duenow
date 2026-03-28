import 'package:flutter/material.dart';
import 'package:duenow/features/todo/presentation/screens/home.dart';

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