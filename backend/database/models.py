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
    axis_scores: dict[str, dict] = {}
    type_description: str = ""
    total_keywords_detected: int = 0
    tokens_analyzed: int = 0
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


# ── Chat ──

class ChatMessageRequest(BaseModel):
    receiver_id: str
    content: str = Field(min_length=1, max_length=2000)


class ChatMessageResponse(BaseModel):
    id: str
    sender_id: str
    receiver_id: str
    content: str
    timestamp: str
    sender_name: str = ""


# ── Icebreakers ──

class IcebreakerResponse(BaseModel):
    icebreakers: list[str]
    context: str = ""


# ── Analytics ──

class SwipeAction(BaseModel):
    target_user_id: str
    action: str = Field(pattern="^(like|pass|super)$")


class SwipeStats(BaseModel):
    total_swipes: int = 0
    likes: int = 0
    passes: int = 0
    super_likes: int = 0
    like_rate: float = 0.0
    top_match_type: str = ""
    avg_compatibility: float = 0.0
    swipe_history: list[dict] = Field(default_factory=list)


# ── Report ──

class ReportRequest(BaseModel):
    reported_user_id: str
    reason: str = Field(min_length=1, max_length=500)


class ReportResponse(BaseModel):
    message: str
    report_id: str


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
