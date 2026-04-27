"""Chat routes — simple message store in MongoDB."""

from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException

if __package__ and __package__.startswith("backend"):
    from ..database.connection import get_db
    from ..database.models import (
        ChatMessageRequest,
        ChatMessageResponse,
        now_utc,
    )
    from .user import get_current_user_id
else:
    from database.connection import get_db
    from database.models import ChatMessageRequest, ChatMessageResponse, now_utc
    from routes.user import get_current_user_id

router = APIRouter(prefix="/api/chat", tags=["chat"])


@router.post("/send", response_model=ChatMessageResponse)
async def send_message(
    payload: ChatMessageRequest,
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()

    sender = await db.users.find_one({"_id": ObjectId(user_id)})
    if not sender:
        raise HTTPException(status_code=404, detail="Sender not found")

    receiver = await db.users.find_one({"_id": ObjectId(payload.receiver_id)})
    if not receiver:
        raise HTTPException(status_code=404, detail="Receiver not found")

    now = now_utc()
    doc = {
        "sender_id": user_id,
        "receiver_id": payload.receiver_id,
        "content": payload.content,
        "timestamp": now.isoformat(),
    }
    result = await db.messages.insert_one(doc)

    sender_name = f"{sender.get('first_name', '')} {sender.get('last_name', '')}".strip()

    return ChatMessageResponse(
        id=str(result.inserted_id),
        sender_id=user_id,
        receiver_id=payload.receiver_id,
        content=payload.content,
        timestamp=now.isoformat(),
        sender_name=sender_name,
    )


@router.get("/conversation/{other_user_id}", response_model=list[ChatMessageResponse])
async def get_conversation(
    other_user_id: str,
    user_id: str = Depends(get_current_user_id),
):
    db = get_db()

    cursor = db.messages.find(
        {
            "$or": [
                {"sender_id": user_id, "receiver_id": other_user_id},
                {"sender_id": other_user_id, "receiver_id": user_id},
            ]
        }
    ).sort("timestamp", 1)

    messages = await cursor.to_list(length=200)

    results = []
    for msg in messages:
        sender = await db.users.find_one({"_id": ObjectId(msg["sender_id"])})
        sender_name = ""
        if sender:
            sender_name = f"{sender.get('first_name', '')} {sender.get('last_name', '')}".strip()

        results.append(
            ChatMessageResponse(
                id=str(msg["_id"]),
                sender_id=msg["sender_id"],
                receiver_id=msg["receiver_id"],
                content=msg["content"],
                timestamp=msg["timestamp"],
                sender_name=sender_name,
            )
        )

    return results


@router.get("/conversations", response_model=list[dict])
async def list_conversations(user_id: str = Depends(get_current_user_id)):
    """List unique conversations with last message preview."""
    db = get_db()

    # Get all messages involving this user
    cursor = db.messages.find(
        {"$or": [{"sender_id": user_id}, {"receiver_id": user_id}]}
    ).sort("timestamp", -1)

    messages = await cursor.to_list(length=500)

    seen_users: dict[str, dict] = {}
    for msg in messages:
        other_id = msg["receiver_id"] if msg["sender_id"] == user_id else msg["sender_id"]
        if other_id not in seen_users:
            other = await db.users.find_one({"_id": ObjectId(other_id)})
            name = "Unknown"
            mbti = ""
            if other:
                name = f"{other.get('first_name', '')} {other.get('last_name', '')}".strip()
                mbti = other.get("mbti", "")

            seen_users[other_id] = {
                "user_id": other_id,
                "name": name,
                "mbti": mbti,
                "last_message": msg["content"],
                "timestamp": msg["timestamp"],
                "is_sender": msg["sender_id"] == user_id,
            }

    return list(seen_users.values())
