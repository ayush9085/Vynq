from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

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
    "http://127.0.0.1:3000",
    "http://127.0.0.1:8000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

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
