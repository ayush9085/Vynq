"""MongoDB connection and initialization."""

from motor.motor_asyncio import AsyncIOMotorClient
from pymongo import MongoClient
from contextlib import asynccontextmanager
import os
from dotenv import load_dotenv
import logging

load_dotenv()

logger = logging.getLogger(__name__)

# Support both DATABASE_URL (docker-compose) and MONGODB_URL (local dev)
MONGODB_URL = os.getenv("DATABASE_URL") or os.getenv("MONGODB_URL", "mongodb://localhost:27017")
DATABASE_NAME = os.getenv("DATABASE_NAME", "vynk")

# Global database instance
db = None
sync_client: MongoClient = None


async def connect_to_db():
    """Create MongoDB connection."""
    global db
    try:
        client = AsyncIOMotorClient(MONGODB_URL)
        # Verify connection
        await client.admin.command("ping")
        db = client[DATABASE_NAME]
        logger.info(f"✓ Connected to MongoDB database: {DATABASE_NAME}")
        # Create indexes
        await create_indexes()
        return db
    except Exception as e:
        logger.error(f"✗ Failed to connect to MongoDB: {e}")
        raise


async def close_db():
    """Close MongoDB connection."""
    global db
    if db is not None:
        # Get client from database instance
        client = db.client
        client.close()
        logger.info("✓ Closed MongoDB connection")


async def create_indexes():
    """Create database indexes for performance."""
    global db
    if db is not None:
        try:
            # Users collection indexes
            users_collection = db["users"]
            await users_collection.create_index("email", unique=True)
            await users_collection.create_index("created_at")
            
            # Matches collection indexes
            matches_collection = db["matches"]
            await matches_collection.create_index("user_id")
            await matches_collection.create_index([("user_id", 1), ("match_user_id", 1)], unique=True)
            
            logger.info("✓ Database indexes created")
        except Exception as e:
            logger.error(f"✗ Failed to create indexes: {e}")


def get_db():
    """Get database instance."""
    if db is None:
        raise RuntimeError("Database not connected. Call connect_to_db() first.")
    return db


def get_sync_db():
    """Get synchronous database connection."""
    global sync_client
    if sync_client is None:
        sync_client = MongoClient(MONGODB_URL)
    return sync_client[DATABASE_NAME]
