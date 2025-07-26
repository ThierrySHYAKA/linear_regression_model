import 'package:flutter/material.dart';
import 'pages/salary_prediction_page.dart';

void main() {
  runApp(SalaryPredictorApp());
}

class SalaryPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Salary Predictor',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: SalaryPredictionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}