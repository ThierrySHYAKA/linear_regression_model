# Salary Prediction App

A full-stack application that predicts salaries based on personal and professional factors using machine learning. The app consists of a FastAPI backend with a trained Linear Regression model and a Flutter mobile frontend. This guide will help you set up and run both the backend (FastAPI) and frontend (Flutter) for the Prediction App.

## Prerequisites

Before you begin, make sure you have the following installed on your machine:

- Python 3.11+
- pip (Python package manager)
- Flutter SDK 3.0+
- Android Studio or any preferred IDE for Flutter development (e.g., Visual Studio Code
- Git 

---

### 1. Clone the repository

Clone the repository to your local machine:
git clone https://github.com/ThierrySHYAKA/linear_regression_model.git
cd linear_regression_model


### 2. Set up a Python virtual environment
Create a virtual environment to isolate your project dependencies:
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

### 3. Install dependencies
pip install -r requirements.txt

### 4. Flutter App Setup
Navigate to the Flutter directory
cd Flutter_app

### 5. Install dependencies
flutter pub get

### 6. Run the app
flutter run


### Common Flutter Issues
Build Errors:
flutter clean
flutter pub get
flutter run

### Activate the virtual environment:

## Windows:
venv\Scripts\activate
## Mac/Linux:
source venv/bin/activate

### 7. Install backend dependencies
Install the required dependencies for the FastAPI backend:
pip install -r requirements.txt

### 8. Run the FastAPI server
Start the FastAPI server by running the following command:
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

### 9. Install Flutter
Follow the official installation guide for Flutter: Flutter Installation.

### 10. Clone the repository
If you haven't already, clone the repository for the Flutter frontend:
git clone https://github.com/ThierrySHYAKA/linear_regression_model.git

$cd linear_regression_model/summative/API
$cd linear_regression_model/summative/FlutterApp/flutter_app
$cd linear_regression_model/summative/linear_regression

### 11. Install Flutter dependencies
Install the required dependencies for the Flutter app:
flutter pub get

### 12. Update the API URL in main.dart
Make sure the API URL is in the main.dart file points to the correct address of your FastAPI backend

### 13. Run the Flutter app
Run the Flutter app on an emulator or connected device:
flutter run

### 14. Contributing

Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

### 15. Author
Thierry SHYAKA

GitHub: @ThierrySHYAKA
Repository: https://github.com/ThierrySHYAKA/linear_regression_model

# Video Demo
https://youtu.be/1p_D4wBAWgo


# Deployed API
https://linear-regression-model-7h10.onrender.com

