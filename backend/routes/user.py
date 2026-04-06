"""
User Routes
User profile, onboarding, and MBTI prediction
"""

from fastapi import APIRouter, HTTPException, status, Depends, Header
from bson.objectid import ObjectId
import logging
from typing import Optional

from database.connection import get_db
from database.models import (
    UserOnboarding, UserResponse, AssessmentSubmit, MBTIResult, AssessmentQuestion
)
from security import decode_token
from services.mbti_model import get_model_service

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/users", tags=["users"])

# Predefined assessment questions
ASSESSMENT_QUESTIONS = [
    AssessmentQuestion(
        id=1,
        text="Describe your ideal weekend",
        category="lifestyle",
        weight=1.0
    ),
    AssessmentQuestion(
        id=2,
        text="How do you typically handle conflicts with people close to you?",
        category="relationships",
        weight=1.0
    ),
    AssessmentQuestion(
        id=3,
        text="What kind of people do you enjoy being around?",
        category="social",
        weight=1.0
    ),
    AssessmentQuestion(
        id=4,
        text="What are your long-term goals in life?",
        category="values",
        weight=1.0
    ),
    AssessmentQuestion(
        id=5,
        text="How do you prefer to learn new things?",
        category="learning",
        weight=1.0
    )
]

async def verify_token(authorization: Optional[str] = Header(None)) -> str:
    """Verify JWT token from Authorization header"""
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authorization token"
        )
    
    try:
        scheme, token = authorization.split()
        if scheme.lower() != "bearer":
            raise ValueError("Invalid auth scheme")
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authorization header"
        )
    
    payload = decode_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token"
        )
    
    return payload.get("user_id")

@router.get("/assessment-questions", response_model=list[AssessmentQuestion])
async def get_assessment_questions():
    """Get assessment questions for onboarding"""
    return ASSESSMENT_QUESTIONS

@router.post("/onboarding")
async def complete_onboarding(
    onboarding_data: UserOnboarding,
    user_id: str = Depends(verify_token)
):
    """
    Complete user onboarding and predict MBTI
    
    This is where ML inference happens - only once per user
    """
    try:
        db = get_db()
        
        # Verify user exists
        user = await db.users.find_one({"_id": ObjectId(user_id)})
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Combine responses into assessment text
        assessment_text = " ".join([
            f"{q.text} {onboarding_data.responses.get(str(q.id), '')}"
            for q in ASSESSMENT_QUESTIONS
        ])
        
        # Get MBTI prediction from model (ML inference happens here)
        model_service = get_model_service()
        mbti_result: MBTIResult = model_service.predict(assessment_text)
        
        logger.info(f"✓ MBTI predicted for user {user_id}: {mbti_result.mbti_type}")
        
        # Update user with MBTI and onboarding data
        update_data = {
            "age": onboarding_data.age,
            "gender": onboarding_data.gender,
            "interests": onboarding_data.interests,
            "mbti": mbti_result.mbti_type,
            "mbti_confidence": mbti_result.confidence,
            "raw_assessment_text": assessment_text,
            "updated_at": None  # Set by MongoDB
        }
        
        await db.users.update_one(
            {"_id": ObjectId(user_id)},
            {"$set": update_data}
        )
        
        # Fetch updated user
        updated_user = await db.users.find_one({"_id": ObjectId(user_id)})
        
        return {
            "status": "success",
            "mbti": mbti_result.mbti_type,
            "confidence": mbti_result.confidence,
            "message": f"Your vibe is {mbti_result.mbti_type}! 👀"
        }
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Onboarding error for user {user_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to complete onboarding"
        )

@router.get("/{user_id}", response_model=UserResponse)
async def get_user_profile(user_id: str, auth_user_id: str = Depends(verify_token)):
    """Get user profile by ID"""
    try:
        db = get_db()
        
        # Verify the requesting user exists
        requesting_user = await db.users.find_one({"_id": ObjectId(auth_user_id)})
        if not requesting_user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid user"
            )
        
        # Get requested user
        user = await db.users.find_one({"_id": ObjectId(user_id)})
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Build response, hiding sensitive data for other users
        return UserResponse(
            _id=str(user["_id"]),
            email=user["email"] if user_id == auth_user_id else "hidden",
            first_name=user["first_name"],
            last_name=user["last_name"],
            age=user.get("age"),
            gender=user.get("gender"),
            interests=user.get("interests", []),
            bio=user.get("bio"),
            location=user.get("location"),
            mbti=user.get("mbti"),
            mbti_confidence=user.get("mbti_confidence"),
            created_at=user.get("created_at").isoformat() if user.get("created_at") else None
        )
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching user profile: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch user profile"
        )

@router.get("/me/profile", response_model=UserResponse)
async def get_my_profile(user_id: str = Depends(verify_token)):
    """Get current user's profile"""
    return await get_user_profile(user_id, user_id)
