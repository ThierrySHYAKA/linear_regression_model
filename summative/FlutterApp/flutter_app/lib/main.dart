import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(flutterapp());
}

class flutterapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Predictor',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
