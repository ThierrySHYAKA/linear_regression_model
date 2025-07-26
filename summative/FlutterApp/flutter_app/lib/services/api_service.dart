// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalaryPredictionRequest {
  final String name;
  final String education;
  final double yearsOfExperience;
  final String location;
  final String jobTitle;
  final int age;
  final String gender;

  SalaryPredictionRequest({
    required this.name,
    required this.education,
    required this.yearsOfExperience,
    required this.location,
    required this.jobTitle,
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'education': education,
      'years_of_experience': yearsOfExperience,
      'location': location,
      'job_title': jobTitle,
      'age': age,
      'gender': gender,
    };
  }
}

class SalaryPredictionResponse {
  final double predictedSalary;
  final Map<String, dynamic> inputData;
  final double? confidenceScore;

  SalaryPredictionResponse({
    required this.predictedSalary,
    required this.inputData,
    this.confidenceScore,
  });

  factory SalaryPredictionResponse.fromJson(Map<String, dynamic> json) {
    return SalaryPredictionResponse(
      predictedSalary: json['predicted_salary'].toDouble(),
      inputData: json['input_data'],
      confidenceScore: json['confidence_score']?.toDouble(),
    );
  }
}

class ApiService {
  // For Android emulator, use 10.0.2.2 instead of localhost
  // For iOS simulator, use localhost or 127.0.0.1
  // For physical device, use your computer's IP address
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  static Future<Map<String, dynamic>> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
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
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Health check failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<SalaryPredictionResponse> predictSalary(SalaryPredictionRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      ).timeout(Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SalaryPredictionResponse.fromJson(data);
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
      ).timeout(Duration(seconds: 10));
      
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

  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/statistics'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to get statistics');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPredictionHistory({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history?limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to get history');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}