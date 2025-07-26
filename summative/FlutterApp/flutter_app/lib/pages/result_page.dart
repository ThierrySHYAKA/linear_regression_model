// lib/pages/result_page.dart (Enhanced Version)
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EnhancedResultPage extends StatelessWidget {
  final SalaryPredictionResponse response;

  const EnhancedResultPage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.blue.shade50,
              Colors.indigo.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                SizedBox(height: 30),
                
                // Main Salary Card
                _buildSalaryCard(),
                SizedBox(height: 25),
                
                // Details Card
                _buildDetailsCard(),
                SizedBox(height: 25),
                
                // Confidence Score
                _buildConfidenceCard(),
                SizedBox(height: 30),
                
                // Action Buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, color: Colors.indigo.shade600),
              ),
              Expanded(
                child: Text(
                  'Salary Prediction Result',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ),
              SizedBox(width: 48), // Balance the back button
            ],
          ),
          SizedBox(height: 10),
          Text(
            'AI-powered analysis complete',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.attach_money,
            size: 60,
            color: Colors.white,
          ),
          SizedBox(height: 15),
          Text(
            'Predicted Salary',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$${_formatSalary(response.predictedSalary)}',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'per year',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    final inputData = response.inputData;
    
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.indigo.shade600, size: 24),
              SizedBox(width: 12),
              Text(
                'Profile Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildDetailRow('Name', inputData['name'], Icons.badge_outlined),
          _buildDetailRow('Education', inputData['education'], Icons.school_outlined),
          _buildDetailRow('Experience', '${inputData['years_of_experience']} years', Icons.work_outline),
          _buildDetailRow('Job Title', inputData['job_title'], Icons.business_center_outlined),
          _buildDetailRow('Location', inputData['location'], Icons.location_on_outlined),
          _buildDetailRow('Age', '${inputData['age']} years', Icons.cake_outlined),
          _buildDetailRow('Gender', inputData['gender'], Icons.people_outline),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: Colors.indigo.shade600),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceCard() {
    final confidence = response.confidenceScore ?? 0.0;
    final confidencePercentage = (confidence * 100).round();
    
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.purple.shade600, size: 24),
              SizedBox(width: 12),
              Text(
                'AI Confidence Level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$confidencePercentage%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getConfidenceColor(confidence),
                      ),
                    ),
                    Text(
                      _getConfidenceText(confidence),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: confidence,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(confidence),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Predict Again Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 24),
                SizedBox(width: 12),
                Text(
                  'Make Another Prediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              shadowColor: Colors.indigo.withOpacity(0.3),
            ),
          ),
        ),
        SizedBox(height: 15),
        
        // Share Results Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () {
              _shareResults(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 24),
                SizedBox(width: 12),
                Text(
                  'Share Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.indigo.shade600,
              side: BorderSide(color: Colors.indigo.shade600, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green.shade600;
    if (confidence >= 0.6) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  String _getConfidenceText(double confidence) {
    if (confidence >= 0.8) return 'High confidence prediction';
    if (confidence >= 0.6) return 'Moderate confidence prediction';
    return 'Lower confidence prediction';
  }

  String _formatSalary(double salary) {
    if (salary >= 1000000) {
      return '${(salary / 1000000).toStringAsFixed(1)}M';
    } else if (salary >= 1000) {
      return '${(salary / 1000).toStringAsFixed(0)}K';
    }
    return salary.toStringAsFixed(0);
  }

  void _shareResults(BuildContext context) {
    final inputData = response.inputData;
    final shareText = '''
🎯 AI Salary Prediction Results

💰 Predicted Salary: \${_formatSalary(response.predictedSalary)}/year
👤 Profile: ${inputData['name']}
🎓 Education: ${inputData['education']}
💼 Job: ${inputData['job_title']}
📍 Location: ${inputData['location']}
⏱️ Experience: ${inputData['years_of_experience']} years
🎂 Age: ${inputData['age']}
🤖 AI Confidence: ${((response.confidenceScore ?? 0) * 100).round()}%

Generated by AI Salary Predictor
    ''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Results'),
        content: SingleChildScrollView(
          child: Text(shareText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Here you would implement actual sharing functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Results copied to clipboard!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Copy'),
          ),
        ],
      ),
    );
  }
}

// Keep the original simple ResultPage for backward compatibility
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