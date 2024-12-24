import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/screens/BmiCalculatorScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BmiCalculatorScreen(),
    );
  }
}