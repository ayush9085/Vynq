from datetime import datetime, timezone
from typing import Any

from pydantic import BaseModel, EmailStr, Field


class RegisterRequest(BaseModel):
    email: EmailStr
    first_name: str = Field(min_length=1, max_length=60)
    last_name: str = Field(min_length=1, max_length=60)
    password: str = Field(min_length=6, max_length=128)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str


class AssessmentQuestion(BaseModel):
    id: int
    text: str


class OnboardingRequest(BaseModel):
    age: int = Field(ge=18, le=99)
    gender: str = Field(min_length=1, max_length=40)
    interests: list[str] = Field(default_factory=list)
    responses: dict[str, str]


class MBTIResult(BaseModel):
    mbti: str
    confidence: float
    keyword_counts: dict[str, int]
    message: str


class UserPublic(BaseModel):
    id: str
    first_name: str
    last_name: str
    age: int | None = None
    gender: str | None = None
    interests: list[str] = Field(default_factory=list)
    mbti: str | None = None
    mbti_confidence: float | None = None


class MatchResult(BaseModel):
    match_user_id: str
    name: str
    mbti: str
    compatibility_score: float
    shared_interests: list[str]
    explanation: str
    reasons: list[str]


def now_utc() -> datetime:
    return datetime.now(timezone.utc)


def serialize_user(doc: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": str(doc["_id"]),
        "first_name": doc.get("first_name", ""),
        "last_name": doc.get("last_name", ""),
        "age": doc.get("age"),
        "gender": doc.get("gender"),
        "interests": doc.get("interests", []),
        "mbti": doc.get("mbti"),
        "mbti_confidence": doc.get("mbti_confidence"),
    }
