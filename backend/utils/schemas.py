from pydantic import BaseModel, EmailStr
from typing import Optional, List, Dict, Any
from datetime import datetime

# ==================== Auth Schemas ====================

class UserSignUp(BaseModel):
    email: EmailStr
    password: str
    first_name: str
    last_name: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user_id: str

# ==================== Profile Schemas ====================

class UserProfileUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    age: Optional[int] = None
    bio: Optional[str] = None
    location: Optional[str] = None

class UserProfile(BaseModel):
    id: str
    email: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    age: Optional[int] = None
    bio: Optional[str] = None
    location: Optional[str] = None
    created_at: Optional[str] = None
    traits: Optional[Dict[str, Any]] = None

# ==================== Assessment Schemas ====================

class AssessmentResponseSchema(BaseModel):
    question_id: int
    response_text: str
    response_score: Optional[float] = None

class AssessmentSubmitResponse(BaseModel):
    question_id: Optional[int] = None
    response_text: Optional[str] = None

class QuestionResponse(BaseModel):
    id: str
    text: str
    trait: str
    type: str
    options: Optional[List[str]] = None

class AssessmentSubmitResponse(BaseModel):
    id: str
    user_id: str
    introversion_extraversion: float
    intuition_sensing: float
    thinking_feeling: float
    judging_perceiving: float
    communication_style: float
    confidence: float

# ==================== Trait Schemas ====================

class TraitVectorResponse(BaseModel):
    id: str
    user_id: str
    introversion_extraversion: float
    intuition_sensing: float
    thinking_feeling: float
    judging_perceiving: float
    communication_style: float
    confidence: float

# ==================== Match Schemas ====================

class MatchResponse(BaseModel):
    id: str
    match_user_id: str
    match_first_name: Optional[str] = None
    match_last_name: Optional[str] = None
    compatibility_score: float
    explanation: str
