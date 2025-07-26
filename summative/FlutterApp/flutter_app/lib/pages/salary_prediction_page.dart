// lib/pages/salary_prediction_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_page.dart';

class SalaryPredictionPage extends StatefulWidget {
  @override
  _SalaryPredictionPageState createState() => _SalaryPredictionPageState();
}

class _SalaryPredictionPageState extends State<SalaryPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _ageController = TextEditingController();
  
  String? _selectedEducation;
  String? _selectedLocation;
  String? _selectedJobTitle;
  String? _selectedGender;
  
  bool _isLoading = false;
  String? _error;
  bool _isConnected = false;
  Map<String, dynamic>? _modelInfo;

  final List<String> _educationLevels = ['High School', 'Bachelor', 'Master', 'PhD'];
  final List<String> _locations = ['Urban', 'Suburban', 'Rural'];
  final List<String> _jobTitles = ['Manager', 'Director', 'Analyst', 'Engineer', 'Consultant', 'Specialist'];
  final List<String> _genders = ['Male', 'Female'];

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
    });

    try {
      final request = SalaryPredictionRequest(
        name: _nameController.text.trim(),
        education: _selectedEducation!,
        yearsOfExperience: double.parse(_experienceController.text),
        location: _selectedLocation!,
        jobTitle: _selectedJobTitle!,
        age: int.parse(_ageController.text),
        gender: _selectedGender!,
      );

      final response = await ApiService.predictSalary(request);

      setState(() {
        _isLoading = false;
      });

      // Navigate to enhanced result page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnhancedResultPage(
            response: response,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(),
                  SizedBox(height: 30),
                  
                  // Connection Status
                  _buildConnectionStatus(),
                  SizedBox(height: 25),
                  
                  // Personal Information Section
                  _buildSectionCard(
                    title: "Personal Information",
                    icon: Icons.person,
                    children: [
                      _buildNameField(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildAgeField()),
                          SizedBox(width: 15),
                          Expanded(child: _buildGenderDropdown()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Professional Information Section
                  _buildSectionCard(
                    title: "Professional Details",
                    icon: Icons.work,
                    children: [
                      _buildEducationDropdown(),
                      SizedBox(height: 20),
                      _buildExperienceField(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildJobTitleDropdown()),
                          SizedBox(width: 15),
                          Expanded(child: _buildLocationDropdown()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  
                  // Predict Button
                  _buildPredictButton(),
                  SizedBox(height: 20),
                  
                  // Error Display
                  if (_error != null) _buildErrorCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(
            Icons.psychology,
            size: 60,
            color: Colors.indigo.shade600,
          ),
          SizedBox(height: 15),
          Text(
            'AI Salary Predictor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Discover your earning potential with AI',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: _isConnected ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: _isConnected ? Colors.green.shade200 : Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isConnected ? Icons.check_circle : Icons.error_outline,
            color: _isConnected ? Colors.green.shade600 : Colors.red.shade600,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isConnected ? 'AI Model Ready' : 'Connection Issue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
                if (_modelInfo != null)
                  Text(
                    'Model: ${_modelInfo!['model_type']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _checkConnection,
            color: Colors.indigo.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.indigo.shade600, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _buildInputDecoration(
        label: 'Full Name',
        hint: 'Enter your full name',
        icon: Icons.person_outline,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      decoration: _buildInputDecoration(
        label: 'Age',
        hint: '25',
        icon: Icons.cake_outlined,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter age';
        }
        final age = int.tryParse(value);
        if (age == null || age < 18 || age > 80) {
          return 'Age: 18-80';
        }
        return null;
      },
    );
  }

  Widget _buildExperienceField() {
    return TextFormField(
      controller: _experienceController,
      decoration: _buildInputDecoration(
        label: 'Years of Experience',
        hint: '5.5',
        icon: Icons.work_outline,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter years of experience';
        }
        final exp = double.tryParse(value);
        if (exp == null || exp < 0 || exp > 50) {
          return 'Experience must be between 0-50 years';
        }
        return null;
      },
    );
  }

  Widget _buildEducationDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedEducation,
      decoration: _buildInputDecoration(
        label: 'Education Level',
        hint: 'Select education',
        icon: Icons.school_outlined,
      ),
      items: _educationLevels.map((education) {
        return DropdownMenuItem(
          value: education,
          child: Text(education),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEducation = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select education level';
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: _buildInputDecoration(
        label: 'Gender',
        hint: 'Select',
        icon: Icons.people_outline,
      ),
      items: _genders.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Select gender';
        }
        return null;
      },
    );
  }

  Widget _buildJobTitleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedJobTitle,
      decoration: _buildInputDecoration(
        label: 'Job Title',
        hint: 'Select job',
        icon: Icons.badge_outlined,
      ),
      items: _jobTitles.map((job) {
        return DropdownMenuItem(
          value: job,
          child: Text(job),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedJobTitle = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Select job title';
        }
        return null;
      },
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      decoration: _buildInputDecoration(
        label: 'Location',
        hint: 'Select',
        icon: Icons.location_on_outlined,
      ),
      items: _locations.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(location),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLocation = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Select location';
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.indigo.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  Widget _buildPredictButton() {
    return Container(
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading || !_isConnected ? null : _predictSalary,
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Analyzing...', style: TextStyle(fontSize: 16)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Predict My Salary',
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
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                ),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}