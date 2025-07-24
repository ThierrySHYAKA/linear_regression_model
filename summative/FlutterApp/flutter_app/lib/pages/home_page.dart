import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController experienceController = TextEditingController();
  String? errorText;

  Future<void> predictSalary() async {
    final String apiUrl = "http://127.0.0.1:8000/predict"; // Replace with your API URL
    final experience = double.tryParse(experienceController.text);

    if (experience == null || experience < 0 || experience > 50) {
      setState(() {
        errorText = "Enter valid experience (0 - 50)";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"years_of_experience": experience}), // Fixed: changed from years_experience to years_of_experience
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody.containsKey("predicted_salary")) {
        final predictedSalary = responseBody["predicted_salary"];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPage(predictedSalary: predictedSalary),
          ),
        );
      } else {
        setState(() {
          errorText = "Error: ${responseBody['detail'] ?? 'Invalid response'}"; // Changed 'error' to 'detail' to match FastAPI error format
        });
      }
    } catch (e) {
      setState(() {
        errorText = "API not reachable or invalid input.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Salary Predictor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Enter Years of Experience:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: experienceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "e.g. 3.5",
                errorText: errorText,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictSalary,
              child: Text("Predict"),
            ),
          ],
        ),
      ),
    );
  }
}