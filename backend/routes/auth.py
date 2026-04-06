"""
Authentication Routes
Login, register, and token management
"""

from fastapi import APIRouter, HTTPException, status
from datetime import timedelta
import logging
from bson.objectid import ObjectId

from database.connection import get_db
from database.models import UserCreate, UserLogin, UserResponse, TokenResponse, UserInDB
from security import hash_password, verify_password, create_access_token, ACCESS_TOKEN_EXPIRE_MINUTES

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/auth", tags=["auth"])

@router.post("/register", response_model=TokenResponse, status_code=201)
async def register(user_data: UserCreate):
    """
    Register a new user
    
    Returns:
        - access_token: JWT token for authentication
        - user_id: New user's ID
    """
    try:
        db = get_db()
        
        # Check if email already exists
        existing_user = await db.users.find_one({"email": user_data.email})
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email already registered"
            )
        
        # Create new user
        from datetime import datetime, timezone
        hashed_password = hash_password(user_data.password)
        
        new_user = {
            "email": user_data.email,
            "first_name": user_data.first_name,
            "last_name": user_data.last_name,
            "password_hash": hashed_password,
            "age": user_data.age,
            "gender": user_data.gender,
            "interests": user_data.interests or [],
            "bio": user_data.bio,
            "location": user_data.location,
            "mbti": None,
            "mbti_confidence": None,
            "raw_assessment_text": None,
            "created_at": datetime.now(timezone.utc),
            "updated_at": datetime.now(timezone.utc)
        }
        
        result = await db.users.insert_one(new_user)
        user_id = str(result.inserted_id)
        
        # Create JWT token
        access_token = create_access_token(
            data={"user_id": user_id},
            expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        )
        
        logger.info(f"✓ New user registered: {user_data.email}")
        
        return TokenResponse(
            access_token=access_token,
            user_id=user_id
        )
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Registration error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to register user"
        )


@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin):
    """
    Login user with email and password
    
    Returns:
        - access_token: JWT token for authentication
        - user_id: User's ID
    """
    try:
        db = get_db()
        
        # Find user by email
        user = await db.users.find_one({"email": credentials.email})
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )
        
        # Verify password
        if not verify_password(credentials.password, user["password_hash"]):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )
        
        # Create JWT token
        user_id = str(user["_id"])
        access_token = create_access_token(
            data={"user_id": user_id},
            expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        )
        
        logger.info(f"✓ User logged in: {credentials.email}")
        
        return TokenResponse(
            access_token=access_token,
            user_id=user_id
        )
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Login error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Login failed"
        )
