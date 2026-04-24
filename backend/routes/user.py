from bson import ObjectId
from fastapi import APIRouter, Depends, Header, HTTPException, status

if __package__ and __package__.startswith("backend"):
    from ..database.connection import get_db
    from ..database.models import (
        AssessmentQuestion,
        MBTIResult,
        OnboardingRequest,
        UserPublic,
        serialize_user,
    )
    from ..security import decode_token
    from ..services.mbti_engine import analyze_personality
else:
    from database.connection import get_db
    from database.models import AssessmentQuestion, MBTIResult, OnboardingRequest, UserPublic, serialize_user
    from security import decode_token
    from services.mbti_engine import analyze_personality

router = APIRouter(prefix="/api/users", tags=["users"])

QUESTIONS = [
    AssessmentQuestion(id=1, text="Describe your ideal weekend."),
    AssessmentQuestion(id=2, text="How do you make decisions under pressure?"),
    AssessmentQuestion(id=3, text="What kind of people energize you most?"),
    AssessmentQuestion(id=4, text="How do you usually plan your week?"),
]


def get_current_user_id(authorization: str | None = Header(default=None)) -> str:
    if not authorization:
        raise HTTPException(status_code=401, detail="Missing authorization token")

    parts = authorization.split(" ", 1)
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise HTTPException(status_code=401, detail="Invalid authorization header")

    payload = decode_token(parts[1])
    if not payload or "user_id" not in payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

    return str(payload["user_id"])


@router.get("/assessment-questions", response_model=list[AssessmentQuestion])
async def assessment_questions():
    return QUESTIONS


@router.post("/onboarding", response_model=MBTIResult)
async def onboarding(payload: OnboardingRequest, user_id: str = Depends(get_current_user_id)):
    db = get_db()

    analysis = analyze_personality(payload.responses)

    update = {
        "$set": {
            "age": payload.age,
            "gender": payload.gender,
            "interests": payload.interests,
            "responses": payload.responses,
            "mbti": analysis["mbti"],
            "mbti_confidence": analysis["confidence"],
            "keyword_counts": analysis["keyword_counts"],
        }
    }

    result = await db.users.update_one({"_id": ObjectId(user_id)}, update)
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="User not found")

    return MBTIResult(
        mbti=analysis["mbti"],
        confidence=analysis["confidence"],
        keyword_counts=analysis["keyword_counts"],
        message=f"AI Personality Analysis Complete: You are {analysis['mbti']}",
    )


@router.get("/me", response_model=UserPublic)
async def my_profile(user_id: str = Depends(get_current_user_id)):
    db = get_db()
    user = await db.users.find_one({"_id": ObjectId(user_id)})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserPublic(**serialize_user(user))
