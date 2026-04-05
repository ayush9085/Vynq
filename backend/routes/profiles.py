from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from database.connection import get_db
from database.models import User, TraitVector
from utils.schemas import UserProfile, UserProfileUpdate
from utils.security import decode_token
from typing import Optional

router = APIRouter(prefix="/profiles", tags=["profiles"])

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

@router.get("/me", response_model=UserProfile)
def get_own_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get current user's profile"""
    user = current_user
    
    traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    traits_data = None
    if traits:
        traits_data = {
            "id": str(traits.id),
            "user_id": str(traits.user_id),
            "introversion_extraversion": traits.introversion_extraversion,
            "intuition_sensing": traits.intuition_sensing,
            "thinking_feeling": traits.thinking_feeling,
            "judging_perceiving": traits.judging_perceiving,
            "communication_style": traits.communication_style,
            "confidence": traits.confidence
        }
    
    return {
        "id": str(user.id),
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "age": user.age,
        "bio": user.bio,
        "location": user.location,
        "created_at": user.created_at.isoformat() if user.created_at else None,
        "traits": traits_data
    }

@router.get("/{user_id}", response_model=UserProfile)
def get_user_profile(
    user_id: str,
    db: Session = Depends(get_db)
):
    """Get public profile of another user"""
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    traits_data = None
    if traits:
        traits_data = {
            "id": str(traits.id),
            "user_id": str(traits.user_id),
            "introversion_extraversion": traits.introversion_extraversion,
            "intuition_sensing": traits.intuition_sensing,
            "thinking_feeling": traits.thinking_feeling,
            "judging_perceiving": traits.judging_perceiving,
            "communication_style": traits.communication_style,
            "confidence": traits.confidence
        }
    
    return {
        "id": str(user.id),
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "age": user.age,
        "bio": user.bio,
        "location": user.location,
        "created_at": user.created_at.isoformat() if user.created_at else None,
        "traits": traits_data
    }

@router.put("/me", response_model=UserProfile)
def update_own_profile(
    profile_update: UserProfileUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update current user's profile"""
    user = current_user
    
    # Update fields
    if profile_update.first_name is not None:
        user.first_name = profile_update.first_name
    if profile_update.last_name is not None:
        user.last_name = profile_update.last_name
    if profile_update.age is not None:
        user.age = profile_update.age
    if profile_update.bio is not None:
        user.bio = profile_update.bio
    if profile_update.location is not None:
        user.location = profile_update.location
    
    db.commit()
    db.refresh(user)
    
    traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    traits_data = None
    if traits:
        traits_data = {
            "id": str(traits.id),
            "user_id": str(traits.user_id),
            "introversion_extraversion": traits.introversion_extraversion,
            "intuition_sensing": traits.intuition_sensing,
            "thinking_feeling": traits.thinking_feeling,
            "judging_perceiving": traits.judging_perceiving,
            "communication_style": traits.communication_style,
            "confidence": traits.confidence
        }
    
    return {
        "id": str(user.id),
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "age": user.age,
        "bio": user.bio,
        "location": user.location,
        "created_at": user.created_at.isoformat() if user.created_at else None,
        "traits": traits_data
    }
    
    traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    traits_data = None
    if traits:
        traits_data = {
            "id": str(traits.id),
            "user_id": str(traits.user_id),
            "introversion_extraversion": traits.introversion_extraversion,
            "intuition_sensing": traits.intuition_sensing,
            "thinking_feeling": traits.thinking_feeling,
            "judging_perceiving": traits.judging_perceiving,
            "communication_style": traits.communication_style,
            "confidence": traits.confidence
        }
    
    return {
        "id": str(user.id),
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "age": user.age,
        "bio": user.bio,
        "location": user.location,
        "created_at": user.created_at.isoformat() if user.created_at else None,
        "traits": traits_data
    }

@router.get("/{user_id}", response_model=UserProfile)
def get_user_profile(
    user_id: str,
    db: Session = Depends(get_db)
):
    """Get public profile of another user"""
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    traits_data = None
    if traits:
        traits_data = {
            "id": str(traits.id),
            "user_id": str(traits.user_id),
            "introversion_extraversion": traits.introversion_extraversion,
            "intuition_sensing": traits.intuition_sensing,
            "thinking_feeling": traits.thinking_feeling,
            "judging_perceiving": traits.judging_perceiving,
            "communication_style": traits.communication_style,
            "confidence": traits.confidence
        }
    
    return {
        "id": str(user.id),
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "age": user.age,
        "bio": user.bio,
        "location": user.location,
        "created_at": user.created_at.isoformat() if user.created_at else None,
        "traits": traits_data
    }

@router.put("/me", response_model=UserProfile)
def update_own_profile(
    profile_update: UserProfileUpdate,
    authorization: str = None,
    db: Session = Depends(get_db)
):
    """Update current user's profile"""
    user = get_current_user(authorization, db)
    
    # Update fields
    if profile_update.first_name is not None:
        user.first_name = profile_update.first_name
    if profile_update.last_name is not None:
        user.last_name = profile_update.last_name
    if profile_update.age is not None:
        user.age = profile_update.age
    if profile_update.bio is not None:
        user.bio = profile_update.bio
    if profile_update.location is not None:
        user.location = profile_update.location
    
    db.commit()
    db.refresh(user)
    
    traits = db.query(TraitVector).filter(TraitVector.user_id == user.id).first()
    traits_data = None
    if traits:
        traits_data = {
            "id": str(traits.id),
            "user_id": str(traits.user_id),
            "introversion_extraversion": traits.introversion_extraversion,
            "intuition_sensing": traits.intuition_sensing,
            "thinking_feeling": traits.thinking_feeling,
            "judging_perceiving": traits.judging_perceiving,
            "communication_style": traits.communication_style,
            "confidence": traits.confidence
        }
    
    return {
        "id": str(user.id),
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "age": user.age,
        "bio": user.bio,
        "location": user.location,
        "created_at": user.created_at.isoformat() if user.created_at else None,
        "traits": traits_data
    }
