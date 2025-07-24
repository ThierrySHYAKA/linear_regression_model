from pydantic import BaseModel, Field
from typing import Optional

class SalaryInput(BaseModel):
    years_of_experience: float = Field(..., gt=0, lt=50, description="Years of experience must be between 0 and 50")
    
    class Config:
        schema_extra = {
            "example": {
                "years_of_experience": 5.0
            }
        }

class SalaryResponse(BaseModel):
    predicted_salary: float = Field(..., description="Predicted salary in USD")
    years_of_experience: float = Field(..., description="Input years of experience")
    
    class Config:
        schema_extra = {
            "example": {
                "predicted_salary": 75000.0,
                "years_of_experience": 5.0
            }
        }

class HealthResponse(BaseModel):
    status: str = Field(..., description="API health status")
    model_loaded: bool = Field(..., description="Whether the ML model is loaded")

class ModelInfoResponse(BaseModel):
    model_type: str = Field(..., description="Type of ML model")
    features: list[str] = Field(..., description="List of model features")
    status: str = Field(..., description="Model loading status")

class ErrorResponse(BaseModel):
    detail: str = Field(..., description="Error message")
    
class WelcomeResponse(BaseModel):
    message: str = Field(..., description="Welcome message")
    status: str = Field(..., description="API status")
    model_loaded: bool = Field(..., description="Whether the ML model is loaded")
    docs: str = Field(..., description="API documentation URL")