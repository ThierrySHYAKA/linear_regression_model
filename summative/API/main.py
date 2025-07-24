from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import joblib
from schemas import (
    SalaryInput, 
    SalaryResponse, 
    HealthResponse, 
    ModelInfoResponse, 
    WelcomeResponse,
    ErrorResponse
)
import numpy as np
import os

app = FastAPI(
    title="Salary Predictor API",
    description="A simple API to predict salary based on years of experience",
    version="1.0.0"
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load trained model and scaler
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

@app.get("/", response_model=WelcomeResponse)
def read_root():
    return WelcomeResponse(
        message="Welcome to the Salary Predictor API",
        status="active",
        model_loaded=model is not None,
        docs="/docs"
    )

@app.get("/health", response_model=HealthResponse)
def health_check():
    return HealthResponse(
        status="healthy",
        model_loaded=model is not None
    )

@app.post("/predict", response_model=SalaryResponse)
def predict_salary(input_data: SalaryInput):
    try:
        if model is None:
            raise HTTPException(
                status_code=503, 
                detail="Model not loaded. Please check if model file exists."
            )
        
        # Prepare features
        features = np.array([[input_data.years_of_experience]])
        
        # Scale features if scaler is available
        if scaler is not None:
            features = scaler.transform(features)
        
        # Make prediction
        prediction = model.predict(features)
        
        return SalaryResponse(
            predicted_salary=float(prediction[0]),
            years_of_experience=input_data.years_of_experience
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
            features=["years_of_experience"],
            status="loaded"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))