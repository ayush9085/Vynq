from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from database.connection import get_db
from database.models import User, TraitVector, CompatibilityMatch
from utils.schemas import MatchResponse
from models.personality_model import MatchingEngine
from utils.security import decode_token
from typing import List, Optional
import uuid

router = APIRouter(prefix="/matches", tags=["matches"])

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

@router.get("/compute", response_model=dict)
def compute_matches(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Compute compatibility matches for current user"""
    user = current_user
    
    # Get user's trait vector
    user_traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    if not user_traits:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User must complete assessment first"
        )
    
    # Get all other users with trait vectors
    other_users = db.query(TraitVector).filter(TraitVector.user_id != user.id).all()
    
    if not other_users:
        return {"matches_computed": 0, "message": "No other users to match with"}
    
    # Compute compatibility for each user
    matching_engine = MatchingEngine()
    matches_created = 0
    
    for other_traits in other_users:
        # Check if match already exists
        existing_match = db.query(CompatibilityMatch).filter(
            ((CompatibilityMatch.user_id_1 == user.id) & (CompatibilityMatch.user_id_2 == other_traits.user_id)) |
            ((CompatibilityMatch.user_id_1 == other_traits.user_id) & (CompatibilityMatch.user_id_2 == user.id))
        ).first()
        
        if existing_match:
            continue
        
        # Compute compatibility
        score, explanation = matching_engine.compute_compatibility(
            {
                "introversion_extraversion": user_traits.introversion_extraversion,
                "intuition_sensing": user_traits.intuition_sensing,
                "thinking_feeling": user_traits.thinking_feeling,
                "judging_perceiving": user_traits.judging_perceiving,
                "communication_style": user_traits.communication_style
            },
            {
                "introversion_extraversion": other_traits.introversion_extraversion,
                "intuition_sensing": other_traits.intuition_sensing,
                "thinking_feeling": other_traits.thinking_feeling,
                "judging_perceiving": other_traits.judging_perceiving,
                "communication_style": other_traits.communication_style
            }
        )
        
        # Save compatibility match
        match = CompatibilityMatch(
            id=str(uuid.uuid4()),
            user_id_1=user.id,
            user_id_2=other_traits.user_id,
            compatibility_score=score,
            explanation=explanation
        )
        db.add(match)
        matches_created += 1
    
    db.commit()
    
    return {
        "matches_computed": matches_created,
        "message": f"Computed compatibility for {matches_created} potential matches"
    }

@router.get("/", response_model=List[MatchResponse])
def get_user_matches(
    limit: int = 10,
    min_score: float = 0.0,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get user's top compatibility matches"""
    user = current_user
    
    # Get matches for this user, sorted by score
    matches = db.query(CompatibilityMatch).filter(
        (CompatibilityMatch.user_id_1 == user.id) |
        (CompatibilityMatch.user_id_2 == user.id)
    ).filter(
        CompatibilityMatch.compatibility_score >= min_score
    ).order_by(
        CompatibilityMatch.compatibility_score.desc()
    ).limit(limit).all()
    
    if not matches:
        return []
    
    result = []
    for match in matches:
        # Determine which user is the match
        match_user_id = match.user_id_2 if match.user_id_1 == user.id else match.user_id_1
        match_user = db.query(User).filter(User.id == match_user_id).first()
        
        result.append({
            "id": str(match.id),
            "match_user_id": str(match_user_id),
            "match_first_name": match_user.first_name if match_user else "Unknown",
            "match_last_name": match_user.last_name if match_user else "",
            "compatibility_score": match.compatibility_score,
            "explanation": match.explanation
        })
    
    return result

@router.get("/{match_user_id}", response_model=MatchResponse)
def get_match_details(
    match_user_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get details of a specific match"""
    user = current_user
    
    # Find the match record
    match = db.query(CompatibilityMatch).filter(
        ((CompatibilityMatch.user_id_1 == user.id) & (CompatibilityMatch.user_id_2 == match_user_id)) |
        ((CompatibilityMatch.user_id_1 == match_user_id) & (CompatibilityMatch.user_id_2 == user.id))
    ).first()
    
    if not match:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    match_user = db.query(User).filter(User.id == match_user_id).first()
    
    return {
        "id": str(match.id),
        "match_user_id": str(match_user_id),
        "match_first_name": match_user.first_name if match_user else "Unknown",
        "match_last_name": match_user.last_name if match_user else "",
        "compatibility_score": match.compatibility_score,
        "explanation": match.explanation
    }
    
    # Get user's trait vector
    user_traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    if not user_traits:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User must complete assessment first"
        )
    
    # Get all other users with trait vectors
    other_users = db.query(TraitVector).filter(TraitVector.user_id != user.id).all()
    
    if not other_users:
        return {"matches_computed": 0, "message": "No other users to match with"}
    
    # Compute compatibility for each user
    matching_engine = MatchingEngine()
    matches_created = 0
    
    for other_traits in other_users:
        # Check if match already exists
        existing_match = db.query(CompatibilityMatch).filter(
            ((CompatibilityMatch.user_id_1 == user.id) & (CompatibilityMatch.user_id_2 == other_traits.user_id)) |
            ((CompatibilityMatch.user_id_1 == other_traits.user_id) & (CompatibilityMatch.user_id_2 == user.id))
        ).first()
        
        if existing_match:
            continue
        
        # Compute compatibility
        score, explanation = matching_engine.compute_compatibility(
            {
                "introversion_extraversion": user_traits.introversion_extraversion,
                "intuition_sensing": user_traits.intuition_sensing,
                "thinking_feeling": user_traits.thinking_feeling,
                "judging_perceiving": user_traits.judging_perceiving,
                "communication_style": user_traits.communication_style
            },
            {
                "introversion_extraversion": other_traits.introversion_extraversion,
                "intuition_sensing": other_traits.intuition_sensing,
                "thinking_feeling": other_traits.thinking_feeling,
                "judging_perceiving": other_traits.judging_perceiving,
                "communication_style": other_traits.communication_style
            }
        )
        
        # Save compatibility match
        match = CompatibilityMatch(
            id=str(uuid.uuid4()),
            user_id_1=user.id,
            user_id_2=other_traits.user_id,
            compatibility_score=score,
            explanation=explanation
        )
        db.add(match)
        matches_created += 1
    
    db.commit()
    
    return {
        "matches_computed": matches_created,
        "message": f"Computed compatibility for {matches_created} potential matches"
    }

@router.get("/", response_model=List[MatchResponse])
def get_user_matches(
    limit: int = 10,
    min_score: float = 0.0,
    authorization: str = None,
    db: Session = Depends(get_db)
):
    """Get user's top compatibility matches"""
    user = get_current_user(authorization, db)
    
    # Get matches for this user, sorted by score
    matches = db.query(CompatibilityMatch).filter(
        (CompatibilityMatch.user_id_1 == user.id) |
        (CompatibilityMatch.user_id_2 == user.id)
    ).filter(
        CompatibilityMatch.compatibility_score >= min_score
    ).order_by(
        CompatibilityMatch.compatibility_score.desc()
    ).limit(limit).all()
    
    if not matches:
        return []
    
    result = []
    for match in matches:
        # Determine which user is the match
        match_user_id = match.user_id_2 if match.user_id_1 == user.id else match.user_id_1
        match_user = db.query(User).filter(User.id == match_user_id).first()
        
        result.append({
            "id": str(match.id),
            "match_user_id": str(match_user_id),
            "match_first_name": match_user.first_name if match_user else "Unknown",
            "match_last_name": match_user.last_name if match_user else "",
            "compatibility_score": match.compatibility_score,
            "explanation": match.explanation
        })
    
    return result

@router.get("/{match_user_id}", response_model=MatchResponse)
def get_match_details(
    match_user_id: str,
    authorization: str = None,
    db: Session = Depends(get_db)
):
    """Get details of a specific match"""
    user = get_current_user(authorization, db)
    
    # Find the match record
    match = db.query(CompatibilityMatch).filter(
        ((CompatibilityMatch.user_id_1 == user.id) & (CompatibilityMatch.user_id_2 == match_user_id)) |
        ((CompatibilityMatch.user_id_1 == match_user_id) & (CompatibilityMatch.user_id_2 == user.id))
    ).first()
    
    if not match:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    match_user = db.query(User).filter(User.id == match_user_id).first()
    
    return {
        "id": str(match.id),
        "match_user_id": str(match_user_id),
        "match_first_name": match_user.first_name if match_user else "Unknown",
        "match_last_name": match_user.last_name if match_user else "",
        "compatibility_score": match.compatibility_score,
        "explanation": match.explanation
    }
