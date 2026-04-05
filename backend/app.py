from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os
from routes import auth, onboarding, matches, profiles
from database.connection import init_db

# Load environment variables
load_dotenv()

# Initialize database
init_db()

# Initialize FastAPI
app = FastAPI(
    title="Vynq API",
    description="Personality-based dating application",
    version="0.1.0"
)

# CORS middleware
origins = [
    "http://localhost:3000",
    "http://localhost:8000",
    "http://localhost:8501",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:8000",
    "http://127.0.0.1:8501",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include route modules
app.include_router(auth.router, prefix="/api")
app.include_router(onboarding.router, prefix="/api")
app.include_router(matches.router, prefix="/api")
app.include_router(profiles.router, prefix="/api")

# Health check endpoint
@app.get("/health")
def health_check():
    return {"status": "healthy", "version": "0.1.0"}

# Root endpoint
@app.get("/")
def read_root():
    return {
        "message": "Welcome to Vynq API",
        "description": "Personality-based dating application",
        "endpoints": {
            "health": "/health",
            "auth": "/api/auth",
            "onboarding": "/api/onboarding",
            "matches": "/api/matches",
            "profiles": "/api/profiles"
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
