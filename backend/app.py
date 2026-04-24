import os
from contextlib import asynccontextmanager

from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

if __package__:
    from .database.connection import close_db, connect_to_db
    from .routes.auth import router as auth_router
    from .routes.match import router as match_router
    from .routes.user import router as user_router
else:
    from database.connection import close_db, connect_to_db
    from routes.auth import router as auth_router
    from routes.match import router as match_router
    from routes.user import router as user_router

load_dotenv()


@asynccontextmanager
async def lifespan(_: FastAPI):
    await connect_to_db()
    yield
    await close_db()


app = FastAPI(
    title="Vynk API",
    version="1.0.0",
    description="AI-powered personality matchmaking API",
    lifespan=lifespan,
)

cors_origins = os.getenv("CORS_ORIGINS", "*").split(",")
allow_credentials = cors_origins != ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=allow_credentials,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health() -> dict:
    return {"status": "healthy", "service": "vynk-api"}


@app.get("/")
async def root() -> dict:
    return {
        "message": "Welcome to Vynk API",
        "docs": "/docs",
    }


app.include_router(auth_router)
app.include_router(user_router)
app.include_router(match_router)
