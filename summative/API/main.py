from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import joblib
from schemas import SalaryInput
import numpy as np

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load trained model
model = joblib.load("model/model.pkl")

@app.get("/")
def read_root():
    return {"message": "Welcome to the Salary Predictor API"}

@app.post("/predict")
def predict_salary(input_data: SalaryInput):
    try:
        features = np.array([[input_data.years_of_experience]])
        prediction = model.predict(features)
        return {"predicted_salary": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
