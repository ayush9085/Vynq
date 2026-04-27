"""Icebreakers, Analytics, Report, and Compatibility routes."""

import uuid
from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException

if __package__ and __package__.startswith("backend"):
    from ..database.connection import get_db
    from ..database.models import (
        IcebreakerResponse,
        ReportRequest,
        ReportResponse,
        SwipeAction,
        SwipeStats,
        now_utc,
    )
    from .user import get_current_user_id
    from ..services.compatibility import get_mbti_compatibility, get_top_matches_for_type, get_full_matrix
else:
    from database.connection import get_db
    from database.models import (
        IcebreakerResponse,
        ReportRequest,
        ReportResponse,
        SwipeAction,
        SwipeStats,
        now_utc,
    )
    from routes.user import get_current_user_id
    from services.compatibility import get_mbti_compatibility, get_top_matches_for_type, get_full_matrix

router = APIRouter(prefix="/api/extras", tags=["extras"])


# ── Dynamic Icebreakers ──

@router.get("/icebreakers/{match_user_id}", response_model=IcebreakerResponse)
async def generate_icebreakers(
    match_user_id: str,
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()
    me = await db.users.find_one({"_id": ObjectId(user_id)})
    other = await db.users.find_one({"_id": ObjectId(match_user_id)})

    if not me or not other:
        raise HTTPException(status_code=404, detail="User not found")

    my_mbti = me.get("mbti", "ENFP")
    their_mbti = other.get("mbti", "ENFP")
    my_interests = set(i.lower() for i in me.get("interests", []))
    their_interests = set(i.lower() for i in other.get("interests", []))
    shared = sorted(my_interests & their_interests)
    other_name = f"{other.get('first_name', '')}".strip() or "them"

    icebreakers = []

    # Interest-based
    if shared:
        icebreakers.append(
            f"You both love {shared[0]} — what's your go-to {shared[0]} recommendation?"
        )
        if len(shared) > 1:
            icebreakers.append(
                f"Would you rather: a perfect {shared[0]} day or a perfect {shared[1]} day?"
            )

    # MBTI-based
    compat = get_mbti_compatibility(my_mbti, their_mbti)
    if compat >= 85:
        icebreakers.append(
            f"Fun fact: {my_mbti} and {their_mbti} are one of the top cognitive function matches! What's the most {their_mbti} thing you've done lately?"
        )
    elif compat >= 70:
        icebreakers.append(
            f"As a {their_mbti}, do you think you're more {their_mbti[2]} (the {_axis_name(their_mbti[2])}) or is there a secret other side?"
        )

    # Personality prompts
    icebreakers.extend([
        f"If we went on a date right now, would you plan it or wing it? (asking because {their_mbti}s are known for {'planning' if their_mbti[3] == 'J' else 'spontaneity'})",
        f"What's the most {_energy_word(their_mbti)} thing about your week so far?",
        f"Hot take: {my_mbti}s and {their_mbti}s {'balance each other out perfectly' if my_mbti[0] != their_mbti[0] else 'get each other on a deep level'}. Agree?",
    ])

    context = f"Generated for {my_mbti} → {their_mbti} (compatibility: {compat}%)"
    if shared:
        context += f", shared interests: {', '.join(shared)}"

    return IcebreakerResponse(
        icebreakers=icebreakers[:5],
        context=context,
    )


def _axis_name(letter: str) -> str:
    return {
        "E": "Extravert", "I": "Introvert",
        "N": "Intuitive", "S": "Sensor",
        "T": "Thinker", "F": "Feeler",
        "J": "Judger", "P": "Perceiver",
    }.get(letter, letter)


def _energy_word(mbti: str) -> str:
    if mbti[0] == "E":
        return "exciting"
    return "meaningful"


# ── Swipe Analytics ──

@router.post("/swipe")
async def record_swipe(
    payload: SwipeAction,
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()
    doc = {
        "user_id": user_id,
        "target_user_id": payload.target_user_id,
        "action": payload.action,
        "timestamp": now_utc().isoformat(),
    }
    await db.swipe_actions.insert_one(doc)
    return {"status": "recorded"}


@router.get("/analytics", response_model=SwipeStats)
async def swipe_analytics(user_id: str = Depends(get_current_user_id)):
    db = get_db()

    cursor = db.swipe_actions.find({"user_id": user_id}).sort("timestamp", -1)
    actions = await cursor.to_list(length=1000)

    likes = sum(1 for a in actions if a["action"] == "like")
    passes = sum(1 for a in actions if a["action"] == "pass")
    supers = sum(1 for a in actions if a["action"] == "super")
    total = len(actions)

    # Find top matched MBTI type
    target_ids = [a["target_user_id"] for a in actions if a["action"] in ("like", "super")]
    mbti_counts: dict[str, int] = {}
    for tid in target_ids[:50]:
        try:
            user = await db.users.find_one({"_id": ObjectId(tid)})
            if user and user.get("mbti"):
                mbti_counts[user["mbti"]] = mbti_counts.get(user["mbti"], 0) + 1
        except Exception:
            pass

    top_type = max(mbti_counts, key=mbti_counts.get) if mbti_counts else ""

    # Build recent history
    history = []
    for a in actions[:20]:
        try:
            target = await db.users.find_one({"_id": ObjectId(a["target_user_id"])})
            name = "Unknown"
            if target:
                name = f"{target.get('first_name', '')} {target.get('last_name', '')}".strip()
            history.append({
                "name": name,
                "action": a["action"],
                "timestamp": a["timestamp"],
            })
        except Exception:
            pass

    return SwipeStats(
        total_swipes=total,
        likes=likes,
        passes=passes,
        super_likes=supers,
        like_rate=round(likes / max(total, 1) * 100, 1),
        top_match_type=top_type,
        avg_compatibility=0,
        swipe_history=history,
    )


# ── Report / Block ──

@router.post("/report", response_model=ReportResponse)
async def report_user(
    payload: ReportRequest,
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()
    doc = {
        "reporter_id": user_id,
        "reported_user_id": payload.reported_user_id,
        "reason": payload.reason,
        "timestamp": now_utc().isoformat(),
        "status": "pending",
    }
    result = await db.reports.insert_one(doc)

    return ReportResponse(
        message="Report submitted. Our team will review it within 24 hours.",
        report_id=str(result.inserted_id),
    )


@router.post("/block/{target_user_id}")
async def block_user(
    target_user_id: str,
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()
    await db.users.update_one(
        {"_id": ObjectId(user_id)},
        {"$addToSet": {"blocked_users": target_user_id}},
    )
    return {"message": "User blocked successfully"}


# ── Compatibility Matrix API ──

@router.get("/compatibility-matrix")
async def compatibility_matrix():
    """Return the full 16×16 MBTI compatibility matrix."""
    return get_full_matrix()


@router.get("/compatibility/{type_a}/{type_b}")
async def compatibility_score(type_a: str, type_b: str):
    """Get compatibility between two MBTI types."""
    score = get_mbti_compatibility(type_a, type_b)
    return {
        "type_a": type_a.upper(),
        "type_b": type_b.upper(),
        "score": score,
    }


@router.get("/top-matches/{mbti_type}")
async def top_matches(mbti_type: str, top_n: int = 5):
    """Get top N most compatible types for a given MBTI type."""
    matches = get_top_matches_for_type(mbti_type, top_n)
    return [{"type": t, "score": s} for t, s in matches]
