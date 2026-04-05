from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from database.connection import get_db
from database.models import User, AssessmentQuestion, AssessmentResponse, TraitVector
from utils.schemas import TraitVectorResponse, QuestionResponse
from utils.questions import QUESTIONS
from models.personality_model import PersonalityModel
from utils.security import decode_token
import uuid
from typing import List, Optional

router = APIRouter(prefix="/onboarding", tags=["onboarding"])

def get_current_user(authorization: Optional[str] = Header(None), db: Session = Depends(get_db)):
    """Extract user from JWT token"""
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authorization header"
        )
    
    try:
        token = authorization.replace("Bearer ", "")
        payload = decode_token(token)
        user_id = payload.get("sub")
    except:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
    
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return user

@router.get("/questions", response_model=List[QuestionResponse])
def get_assessment_questions(db: Session = Depends(get_db)):
    """Get all assessment questions"""
    questions = []
    
    for q_id, question_data in QUESTIONS.items():
        questions.append({
            "id": q_id,
            "text": question_data["text"],
            "type": question_data["type"],
            "options": question_data.get("options", []),
            "trait": question_data["trait"]
        })
    
    return questions

@router.post("/submit-assessment", response_model=TraitVectorResponse)
def submit_assessment(
    responses: dict,  # {question_id: response_text}
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Submit assessment responses and compute personality traits"""
    user = current_user
    
    # Check if user already has trait vector
    existing_traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    if existing_traits:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User already completed assessment"
        )
    
    # Save assessment responses
    for question_id, response_text in responses.items():
        assessment_resp = AssessmentResponse(
            id=str(uuid.uuid4()),
            user_id=user.id,
            question_id=int(question_id),
            response_text=response_text
        )
        db.add(assessment_resp)
    
    db.commit()
    
    # Process responses to get trait vector
    personality_model = PersonalityModel()
    traits = personality_model.process_responses(responses)
    
    # Save trait vector
    trait_vector = TraitVector(
        id=str(uuid.uuid4()),
        user_id=user.id,
        introversion_extraversion=traits["introversion_extraversion"],
        intuition_sensing=traits["intuition_sensing"],
        thinking_feeling=traits["thinking_feeling"],
        judging_perceiving=traits["judging_perceiving"],
        communication_style=traits["communication_style"],
        confidence=0.8
    )
    db.add(trait_vector)
    db.commit()
    db.refresh(trait_vector)
    
    return {
        "id": str(trait_vector.id),
        "user_id": str(trait_vector.user_id),
        "introversion_extraversion": trait_vector.introversion_extraversion,
        "intuition_sensing": trait_vector.intuition_sensing,
        "thinking_feeling": trait_vector.thinking_feeling,
        "judging_perceiving": trait_vector.judging_perceiving,
        "communication_style": trait_vector.communication_style,
        "confidence": trait_vector.confidence
    }
