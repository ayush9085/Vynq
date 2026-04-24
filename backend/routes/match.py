from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, Query

if __package__ and __package__.startswith("backend"):
    from ..database.connection import get_db
    from ..database.models import MatchResult
    from .user import get_current_user_id
    from ..services.matching import compute_match
else:
    from database.connection import get_db
    from database.models import MatchResult
    from routes.user import get_current_user_id
    from services.matching import compute_match

router = APIRouter(prefix="/api/matches", tags=["matches"])


@router.get("/find", response_model=list[MatchResult])
async def find_matches(
    limit: int = Query(default=10, ge=1, le=50),
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()
    current_user = await db.users.find_one({"_id": ObjectId(user_id)})
    if not current_user:
        raise HTTPException(status_code=404, detail="User not found")
    if not current_user.get("mbti"):
        raise HTTPException(status_code=400, detail="Complete onboarding first")

    cursor = db.users.find({"_id": {"$ne": ObjectId(user_id)}, "mbti": {"$ne": None}}).limit(limit)
    users = await cursor.to_list(length=limit)

    matches: list[MatchResult] = []
    for user in users:
        result = compute_match(current_user, user)
        matches.append(
            MatchResult(
                match_user_id=str(user["_id"]),
                name=f"{user.get('first_name', '')} {user.get('last_name', '')}".strip(),
                mbti=user.get("mbti", "----"),
                compatibility_score=result["compatibility_score"],
                shared_interests=result["shared_interests"],
                explanation=result["explanation"],
                reasons=result["reasons"],
            )
        )

    matches.sort(key=lambda m: m.compatibility_score, reverse=True)
    return matches


@router.get("/{match_user_id}", response_model=MatchResult)
async def match_detail(match_user_id: str, user_id: str = Depends(get_current_user_id)):
    db = get_db()
    current_user = await db.users.find_one({"_id": ObjectId(user_id)})
    other_user = await db.users.find_one({"_id": ObjectId(match_user_id)})

    if not current_user or not other_user:
        raise HTTPException(status_code=404, detail="User not found")

    result = compute_match(current_user, other_user)
    return MatchResult(
        match_user_id=str(other_user["_id"]),
        name=f"{other_user.get('first_name', '')} {other_user.get('last_name', '')}".strip(),
        mbti=other_user.get("mbti", "----"),
        compatibility_score=result["compatibility_score"],
        shared_interests=result["shared_interests"],
        explanation=result["explanation"],
        reasons=result["reasons"],
    )
