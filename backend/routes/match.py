"""
Matching Routes
Find and retrieve matches
"""

from fastapi import APIRouter, HTTPException, status, Depends, Header, Query
from bson.objectid import ObjectId
import logging
from typing import Optional, List

from database.connection import get_db
from database.models import MatchResult
from security import decode_token
from services.matching import find_matches

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/matches", tags=["matches"])

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

@router.get("/find", response_model=List[MatchResult])
async def find_user_matches(
    limit: int = Query(10, ge=1, le=50),
    user_id: str = Depends(verify_token)
):
    """
    Find matches for current user
    
    Uses stored MBTI + interests (no ML inference here)
    """
    try:
        db = get_db()
        
        # Get current user
        current_user = await db.users.find_one({"_id": ObjectId(user_id)})
        if not current_user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Check if user has completed onboarding
        if not current_user.get("mbti"):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Please complete onboarding first to get matches"
            )
        
        # Get all other users with MBTI
        all_users = await db.users.find(
            {"mbti": {"$exists": True, "$ne": None}}
        ).to_list(None)
        
        if not all_users:
            logger.warning(f"No users with MBTI found for matching")
            return []
        
        # Find matches using matching engine
        matches = find_matches(current_user, all_users, limit=limit)
        
        logger.info(f"✓ Found {len(matches)} matches for user {user_id}")
        
        return matches
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error finding matches: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to find matches"
        )

@router.get("/{match_user_id}", response_model=MatchResult)
async def get_match_details(
    match_user_id: str,
    user_id: str = Depends(verify_token)
):
    """
    Get detailed match information
    """
    try:
        db = get_db()
        
        # Verify current user exists
        current_user = await db.users.find_one({"_id": ObjectId(user_id)})
        if not current_user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Get match user
        match_user = await db.users.find_one({"_id": ObjectId(match_user_id)})
        if not match_user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Match user not found"
            )
        
        # Check if match user has completed onboarding
        if not match_user.get("mbti"):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Match user hasn't completed onboarding yet"
            )
        
        # Calculate compatibility (using matching engine)
        from services.matching import MatchingEngine
        
        score, reasons = MatchingEngine.calculate_total_compatibility(
            current_user["mbti"],
            current_user.get("interests", []),
            match_user["mbti"],
            match_user.get("interests", [])
        )
        
        return MatchResult(
            match_user_id=str(match_user["_id"]),
            name=f"{match_user['first_name']} {match_user['last_name']}",
            age=match_user.get("age"),
            gender=match_user.get("gender"),
            mbti=match_user["mbti"],
            interests=match_user.get("interests", []),
            compatibility_score=round(score, 1),
            match_reasons=reasons[:3],
            user_bio=match_user.get("bio")
        )
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting match details: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to get match details"
        )

@router.post("/record-match/{match_user_id}")
async def record_match(
    match_user_id: str,
    user_id: str = Depends(verify_token)
):
    """
    Record that user showed interest in a match
    (Useful for analytics/future AI improvements)
    """
    try:
        db = get_db()
        
        # Verify users exist
        current_user = await db.users.find_one({"_id": ObjectId(user_id)})
        match_user = await db.users.find_one({"_id": ObjectId(match_user_id)})
        
        if not current_user or not match_user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Record in matches collection (for analytics)
        from services.matching import MatchingEngine
        score, reasons = MatchingEngine.calculate_total_compatibility(
            current_user["mbti"],
            current_user.get("interests", []),
            match_user["mbti"],
            match_user.get("interests", [])
        )
        
        match_record = {
            "user_id": user_id,
            "match_user_id": match_user_id,
            "compatibility_score": score,
            "match_reasons": reasons,
            "created_at": None  # Set by MongoDB
        }
        
        await db.matches.insert_one(match_record)
        
        logger.info(f"✓ Match recorded: {user_id} → {match_user_id}")
        
        return {
            "status": "success",
            "message": "Match recorded"
        }
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error recording match: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to record match"
        )
