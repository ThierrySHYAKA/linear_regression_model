import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double predictedSalary;

  const ResultPage({super.key, required this.predictedSalary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediction Result")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Predicted Salary:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "USD ${predictedSalary.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 30, color: Colors.green[700]),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text("Predict Again"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}