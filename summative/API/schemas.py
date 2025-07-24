from pydantic import BaseModel, Field

class SalaryInput(BaseModel):
    years_of_experience: float = Field(..., gt=0, lt=50, description="Years of experience must be between 0 and 50")
