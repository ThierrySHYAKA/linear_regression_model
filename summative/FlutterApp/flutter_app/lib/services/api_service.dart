// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your actual API URL
  static const String baseUrl = 'http://localhost:8000';  // FastAPI default port
  // For Android emulator: 'http://10.0.2.2:8000'
  // For iOS simulator: 'http://localhost:8000'
  // For real device: 'http://YOUR_COMPUTER_IP:8000'
  
  static Future<Map<String, dynamic>> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to connect to API');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Health check failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<double> predictSalary({
    required double yearsOfExperience,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'years_of_experience': yearsOfExperience,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predicted_salary'].toDouble();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Prediction failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getModelInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/model-info'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to get model info');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}