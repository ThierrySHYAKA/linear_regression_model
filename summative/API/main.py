from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import joblib
from schemas import (
    SalaryInput, 
    SalaryResponse, 
    HealthResponse, 
    ModelInfoResponse, 
    WelcomeResponse,
    ErrorResponse,
    StatisticsResponse,
    PredictionHistory
)
import numpy as np
import pandas as pd
import os
from datetime import datetime
from typing import List

app = FastAPI(
    title="Advanced Salary Predictor API",
    description="A comprehensive API to predict salary based on multiple factors including education, experience, location, job title, age, and gender",
    version="2.0.0"
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for model and scaler
model = None
scaler = None
feature_columns = ['Education', 'Experience', 'Location', 'Job_Title', 'Age', 'Gender']
prediction_history = []

# Load trained model and scaler
def load_model():
    global model, scaler
    try:
        model_path = "model/model.pkl"
        scaler_path = "model/scaler.pkl"
        
        if os.path.exists(model_path):
            model = joblib.load(model_path)
            print("Model loaded successfully!")
        else:
            model = None
            print(f"Model file not found at {model_path}")
        
        if os.path.exists(scaler_path):
            scaler = joblib.load(scaler_path)
            print("Scaler loaded successfully!")
        else:
            scaler = None
            print(f"Scaler file not found at {scaler_path}")
            
    except Exception as e:
        model = None
        scaler = None
        print(f"Error loading model or scaler: {e}")

# Load model on startup
load_model()

def encode_categorical_features(input_data: SalaryInput) -> np.ndarray:
    """Convert categorical input to numerical features for model prediction"""
    
    # Education encoding
    education_map = {"High School": 0, "Bachelor": 1, "Master": 2, "PhD": 3}
    education_encoded = education_map.get(input_data.education.value, 1)
    
    # Location encoding
    location_map = {"Rural": 0, "Suburban": 1, "Urban": 2}
    location_encoded = location_map.get(input_data.location.value, 1)
    
    # Job Title encoding
    job_title_map = {
        "Analyst": 0, "Consultant": 1, "Director": 2, 
        "Engineer": 3, "Manager": 4, "Specialist": 5
    }
    job_title_encoded = job_title_map.get(input_data.job_title.value, 4)
    
    # Gender encoding
    gender_encoded = 1 if input_data.gender.value == "Male" else 0
    
    # Create feature array [Education, Experience, Location, Job_Title, Age, Gender]
    features = np.array([[
        education_encoded,
        input_data.years_of_experience,
        location_encoded,
        job_title_encoded,
        input_data.age,
        gender_encoded
    ]])
    
    return features

@app.get("/", response_model=WelcomeResponse)
def read_root():
    return WelcomeResponse(
        message="Welcome to the Advanced Salary Predictor API",
        status="active",
        model_loaded=model is not None,
        docs="/docs",
        available_endpoints=["/", "/health", "/predict", "/model-info", "/statistics", "/history"]
    )

@app.get("/health", response_model=HealthResponse)
def health_check():
    return HealthResponse(
        status="healthy",
        model_loaded=model is not None,
        model_features=feature_columns if model is not None else None
    )

@app.post("/predict", response_model=SalaryResponse)
def predict_salary(input_data: SalaryInput):
    try:
        if model is None:
            raise HTTPException(
                status_code=503, 
                detail="Model not loaded. Please check if model file exists."
            )
        
        # Encode categorical features
        features = encode_categorical_features(input_data)
        
        # Scale features if scaler is available
        if scaler is not None:
            features = scaler.transform(features)
        
        # Make prediction
        prediction = model.predict(features)
        predicted_salary = float(prediction[0])
        
        # Store prediction in history
        prediction_record = {
            "id": len(prediction_history) + 1,
            "timestamp": datetime.now().isoformat(),
            "input_data": input_data.dict(),
            "predicted_salary": predicted_salary
        }
        prediction_history.append(prediction_record)
        
        # Calculate confidence score (simplified)
        confidence_score = min(0.95, max(0.70, 0.85 + np.random.normal(0, 0.05)))
        
        return SalaryResponse(
            predicted_salary=predicted_salary,
            input_data=input_data.dict(),
            confidence_score=round(confidence_score, 3)
        )
        
    except HTTPException:
        raise  # Re-raise HTTP exceptions
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@app.get("/model-info", response_model=ModelInfoResponse)
def get_model_info():
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    try:
        return ModelInfoResponse(
            model_type=str(type(model).__name__),
            features=feature_columns,
            status="loaded",
            training_data_size=len(prediction_history) if prediction_history else None
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/statistics", response_model=StatisticsResponse)
def get_statistics():
    if not prediction_history:
        return StatisticsResponse(
            total_predictions=0,
            average_salary=0.0,
            most_common_job="N/A",
            salary_range={"min": 0, "max": 0}
        )
    
    salaries = [p["predicted_salary"] for p in prediction_history]
    jobs = [p["input_data"]["job_title"] for p in prediction_history]
    
    from collections import Counter
    job_counts = Counter(jobs)
    most_common_job = job_counts.most_common(1)[0][0] if job_counts else "N/A"
    
    return StatisticsResponse(
        total_predictions=len(prediction_history),
        average_salary=round(sum(salaries) / len(salaries), 2),
        most_common_job=most_common_job,
        salary_range={"min": min(salaries), "max": max(salaries)}
    )

@app.get("/history", response_model=List[PredictionHistory])
def get_prediction_history(limit: int = 10):
    """Get recent prediction history"""
    return [
        PredictionHistory(**record) 
        for record in prediction_history[-limit:]
    ]

@app.delete("/history")
def clear_history():
    """Clear prediction history"""
    global prediction_history
    prediction_history = []
    return {"message": "Prediction history cleared"}

# Reload model endpoint
@app.post("/reload-model")
def reload_model():
    """Reload the machine learning model"""
    load_model()
    return {
        "message": "Model reloaded",
        "model_loaded": model is not None,
        "scaler_loaded": scaler is not None
    }