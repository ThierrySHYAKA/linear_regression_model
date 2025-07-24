// lib/pages/salary_prediction_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SalaryPredictionPage extends StatefulWidget {
  @override
  _SalaryPredictionPageState createState() => _SalaryPredictionPageState();
}

class _SalaryPredictionPageState extends State<SalaryPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final _experienceController = TextEditingController();
  
  bool _isLoading = false;
  double? _predictedSalary;
  String? _error;
  bool _isConnected = false;
  Map<String, dynamic>? _modelInfo;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    try {
      final health = await ApiService.checkHealth();
      final info = await ApiService.getModelInfo();
      
      setState(() {
        _isConnected = health['status'] == 'healthy' && health['model_loaded'] == true;
        _modelInfo = info;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _error = e.toString();
        _modelInfo = null;
      });
    }
  }

  Future<void> _predictSalary() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _predictedSalary = null;
    });

    try {
      final salary = await ApiService.predictSalary(
        yearsOfExperience: double.parse(_experienceController.text),
      );

      setState(() {
        _predictedSalary = salary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatSalary(double salary) {
    return '\$${salary.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salary Predictor'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Connection Status Card
                Card(
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _isConnected ? Colors.green[50] : Colors.red[50],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isConnected ? Icons.check_circle : Icons.error,
                              color: _isConnected ? Colors.green : Colors.red,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isConnected ? 'API Connected' : 'API Disconnected',
                                    style: TextStyle(
                                      color: _isConnected ? Colors.green[800] : Colors.red[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (_modelInfo != null)
                                    Text(
                                      'Model: ${_modelInfo!['model_type']}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: _checkConnection,
                              color: Colors.indigo,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Input Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Your Experience',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _experienceController,
                          decoration: InputDecoration(
                            labelText: 'Years of Experience',
                            hintText: 'e.g., 5.5',
                            prefixIcon: Icon(Icons.work, color: Colors.indigo),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.indigo, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter years of experience';
                            }
                            final number = double.tryParse(value);
                            if (number == null) {
                              return 'Please enter a valid number';
                            }
                            if (number < 0) {
                              return 'Experience cannot be negative';
                            }
                            if (number > 50) {
                              return 'Please enter a realistic value';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Predict Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading || !_isConnected ? null : _predictSalary,
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Predicting...'),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.psychology),
                              SizedBox(width: 8),
                              Text('Predict Salary'),
                            ],
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Results
                if (_predictedSalary != null)
                  Card(
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.green[100]!, Colors.green[50]!],
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 48,
                            color: Colors.green[700],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Predicted Salary',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _formatSalary(_predictedSalary!),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Based on ${_experienceController.text} years of experience',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Error Display
                if (_error != null)
                  Card(
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red[50],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Error',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _error!,
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }
}