"""VYNK Backend API - Main Application"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import logging
import os
from dotenv import load_dotenv

# Import database connection
from database.connection import connect_to_db, close_db

# Import route handlers
from routes import auth, user, match

# Import model service
from services.mbti_model import init_model_service

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Environment variables
DEBUG = os.getenv("DEBUG", "False").lower() == "true"
MODEL_PATH = os.getenv("MODEL_PATH", None)

# CORS Configuration - Allow all localhost origins for development
if DEBUG or os.getenv("ENVIRONMENT") == "development":
    # Development: Allow all localhost origins with any port
    CORS_ORIGINS = ["*"]
else:
    # Production: Specific allowed origins
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "").split(",") if os.getenv("CORS_ORIGINS") else [
        "http://localhost",
        "http://127.0.0.1",
        "http://localhost:3000",
        "http://localhost:3001",
        "http://localhost:5173",
        "http://localhost:8000",
        "http://localhost:8080",
        "http://localhost:8081",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:3001",
        "http://127.0.0.1:5173",
        "http://127.0.0.1:8000",
        "http://127.0.0.1:8080",
        "http://127.0.0.1:8081",
    ]


# Lifespan context manager for startup/shutdown
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Handle startup and shutdown events."""
    # Startup
    logger.info("🚀 Starting VYNK API...")
    
    # Initialize ML model service (loaded once at startup)
    try:
        init_model_service(model_path=MODEL_PATH)
        if MODEL_PATH:
            logger.info("✓ MBTI model loaded from disk")
        else:
            logger.warning("⚠️  No model path provided - using placeholder mode")
    except Exception as e:
        logger.error(f"✗ Failed to initialize model: {e}")
        # Don't raise - allow app to start with placeholder
    
    # Connect to database
    try:
        await connect_to_db()
        logger.info("✓ Database connected")
    except Exception as e:
        logger.error(f"✗ Failed to connect to database: {e}")
        raise
    
    yield
    
    # Shutdown
    logger.info("🔴 Shutting down VYNK API...")
    await close_db()
    logger.info("✓ Database disconnected")


# Initialize FastAPI app
app = FastAPI(
    title="VYNK API",
    description="Personality-based dating application powered by MBTI classification",
    version="1.0.0",
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=(CORS_ORIGINS != ["*"]),  # Only allow credentials for specific origins
    allow_methods=["*"],
    allow_headers=["*"],
)


# Health check endpoint
@app.get("/health", tags=["health"])
async def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy",
        "version": "1.0.0",
        "service": "VYNK API"
    }


# Root endpoint
@app.get("/", tags=["root"])
async def root():
    """Root endpoint."""
    return {
        "message": "Welcome to VYNK API 👀",
        "docs": "/docs",
        "version": "1.0.0",
        "endpoints": {
            "health": "/health",
            "auth": "/api/auth",
            "users": "/api/users",
            "matches": "/api/matches"
        }
    }


# Include route modules
app.include_router(auth.router)
app.include_router(user.router)
app.include_router(match.router)

logger.info("✓ VYNK API initialized with all routes")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
