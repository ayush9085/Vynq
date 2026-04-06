"""Export schemas from database models for backward compatibility."""

from database.models import (
    # User schemas
    UserBase,
    UserCreate,
    UserLogin,
    UserOnboarding,
    UserInDB,
    UserResponse,
    # MBTI result
    MBTIResult,
    # Match schemas
    MatchScore,
    MatchReason,
    MatchResult,
    MatchInDB,
    # Assessment schemas
    AssessmentQuestion,
    AssessmentResponse,
    AssessmentSubmit,
    # Token schemas
    TokenData,
    TokenResponse,
    # Error schema
    ErrorResponse,
)

__all__ = [
    "UserBase",
    "UserCreate",
    "UserLogin",
    "UserOnboarding",
    "UserInDB",
    "UserResponse",
    "MBTIResult",
    "MatchScore",
    "MatchReason",
    "MatchResult",  
    "MatchInDB",
    "AssessmentQuestion",
    "AssessmentResponse",
    "AssessmentSubmit",
    "TokenData",
    "TokenResponse",
    "ErrorResponse",
]

