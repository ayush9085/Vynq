"""MongoDB document models (Pydantic + PyMongo compatible)."""

from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List, Dict, Any
from datetime import datetime, timezone
from bson import ObjectId


# ==================== Base Models ====================

class PyObjectId(ObjectId):
    """Custom Pydantic type for ObjectId."""
    @classmethod
    def __get_validators__(cls):
        yield cls.validate

    @classmethod
    def validate(cls, v):
        if not ObjectId.is_valid(v):
            raise ValueError(f"Invalid ObjectId: {v}")
        return ObjectId(v)

    def __repr__(self):
        return f"ObjectId('{self}')"


# ==================== User Models ====================

class UserBase(BaseModel):
    """Base user schema."""
    email: EmailStr
    first_name: str
    last_name: str
    age: Optional[int] = None
    gender: Optional[str] = None  # male, female, other, prefer_not_to_say
    interests: List[str] = []
    bio: Optional[str] = None
    location: Optional[str] = None


class UserCreate(UserBase):
    """User creation schema with password."""
    password: str


class UserLogin(BaseModel):
    """User login schema."""
    email: EmailStr
    password: str


class UserOnboarding(BaseModel):
    """User onboarding schema with assessment responses."""
    age: int
    gender: str
    interests: List[str]
    responses: Dict[str, str]  # {question_id: response_text}


class MBTIResult(BaseModel):
    """MBTI prediction result."""
    mbti_type: str  # e.g., "ENFP"
    confidence: float  # 0-1
    trait_scores: Dict[str, float]  # Individual trait scores


class UserInDB(UserBase):
    """User document in database."""
    id: PyObjectId = Field(alias="_id")
    password_hash: str
    mbti: Optional[str] = None
    mbti_confidence: Optional[float] = None
    raw_assessment_text: Optional[str] = None
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    updated_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    
    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True


class UserResponse(BaseModel):
    """User data for API response."""
    id: str = Field(alias="_id")
    email: str
    first_name: str
    last_name: str
    age: Optional[int] = None
    gender: Optional[str] = None
    interests: List[str] = []
    bio: Optional[str] = None
    location: Optional[str] = None
    mbti: Optional[str] = None
    mbti_confidence: Optional[float] = None
    created_at: str

    class Config:
        populate_by_name = True


# ==================== Match Models ====================

class MatchScore(BaseModel):
    """Compatibility score breakdown."""
    ei_compatibility: float  # E/I trait match
    ns_compatibility: float  # N/S trait match
    tf_compatibility: float  # T/F trait match
    jp_compatibility: float  # J/P trait match
    interest_compatibility: float  # Shared interests
    total_score: float  # 0-100


class MatchReason(BaseModel):
    """Why users match."""
    reasons: List[str]  # e.g., ["Complementary personalities", "Shared interests in music"]


class MatchResult(BaseModel):
    """Match result for API response."""
    match_user_id: str
    name: str
    age: Optional[int] = None
    gender: Optional[str] = None
    mbti: str
    interests: List[str]
    compatibility_score: float  # 0-100
    match_reasons: List[str]
    user_bio: Optional[str] = None


class MatchInDB(BaseModel):
    """Match document in database."""
    id: PyObjectId = Field(alias="_id")
    user_id: str
    match_user_id: str
    compatibility_score: float
    match_reasons: List[str]
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    
    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True


# ==================== Assessment Models ====================

class AssessmentQuestion(BaseModel):
    """Assessment question."""
    id: int
    text: str
    category: str  # e.g., "lifestyle", "values", "relationships"
    weight: float = 1.0  # Question weight in MBTI calculation


class AssessmentResponse(BaseModel):
    """User's assessment response."""
    question_id: int
    response_text: str


class AssessmentSubmit(BaseModel):
    """Submit multiple assessment responses."""
    responses: List[AssessmentResponse]


# ==================== Token Models ====================

class TokenData(BaseModel):
    """JWT token payload."""
    user_id: str


class TokenResponse(BaseModel):
    """Token response."""
    access_token: str
    token_type: str = "bearer"
    user_id: str


# ==================== Error Models ====================

class ErrorResponse(BaseModel):
    """Error response."""
    error: str
    detail: Optional[str] = None
    status_code: int
