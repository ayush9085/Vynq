from fastapi import APIRouter, HTTPException, status
from pymongo.errors import DuplicateKeyError

if __package__ and __package__.startswith("backend"):
    from ..database.connection import get_db
    from ..database.models import AuthResponse, LoginRequest, RegisterRequest
    from ..security import create_access_token, hash_password, verify_password
else:
    from database.connection import get_db
    from database.models import AuthResponse, LoginRequest, RegisterRequest
    from security import create_access_token, hash_password, verify_password

router = APIRouter(prefix="/api/auth", tags=["auth"])


@router.post("/register", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
async def register(payload: RegisterRequest):
    db = get_db()
    doc = {
        "email": payload.email.lower(),
        "first_name": payload.first_name,
        "last_name": payload.last_name,
        "password_hash": hash_password(payload.password),
        "interests": [],
        "responses": {},
        "mbti": None,
        "mbti_confidence": None,
        "keyword_counts": {},
    }

    try:
        result = await db.users.insert_one(doc)
    except DuplicateKeyError:
        raise HTTPException(status_code=409, detail="Email already registered")

    user_id = str(result.inserted_id)
    return AuthResponse(access_token=create_access_token(user_id), user_id=user_id)


@router.post("/login", response_model=AuthResponse)
async def login(payload: LoginRequest):
    db = get_db()
    user = await db.users.find_one({"email": payload.email.lower()})

    if not user or not verify_password(payload.password, user["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid email or password")

    user_id = str(user["_id"])
    return AuthResponse(access_token=create_access_token(user_id), user_id=user_id)
