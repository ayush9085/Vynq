from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    # MongoDB
    MONGODB_URL: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "vynk"
    
    # Security
    SECRET_KEY: str = "your-secret-key-here-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Model paths
    MODEL_PATH: Optional[str] = None  # Will be loaded from .env or set to None for now
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
