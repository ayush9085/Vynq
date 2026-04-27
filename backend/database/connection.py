import os

from dotenv import load_dotenv
from motor.motor_asyncio import AsyncIOMotorClient, AsyncIOMotorDatabase

load_dotenv()

MONGODB_URL = os.getenv("MONGODB_URL", "mongodb://localhost:27017")
MONGODB_DB = os.getenv("MONGODB_DB", "vynk")

_client: AsyncIOMotorClient | None = None
_db: AsyncIOMotorDatabase | None = None


async def connect_to_db() -> None:
    global _client, _db
    try:
        _client = AsyncIOMotorClient(MONGODB_URL, serverSelectionTimeoutMS=5000)
        _db = _client[MONGODB_DB]
        
        # Verify connection
        await _db.admin.command('ping')
        
        # Create indexes
        await _db.users.create_index("email", unique=True)
        await _db.users.create_index("mbti")
        print("✓ Database connected successfully")
    except Exception as e:
        print(f"✗ Database connection failed: {e}")
        print("  Set MONGODB_URL environment variable in Railway")
        raise


async def close_db() -> None:
    global _client, _db
    if _client is not None:
        _client.close()
    _client = None
    _db = None


def get_db() -> AsyncIOMotorDatabase:
    if _db is None:
        raise RuntimeError("Database is not connected")
    return _db
