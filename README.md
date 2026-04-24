# Vynk

Vynk (pronounced "wink") is a full-stack mobile-first personality matchmaking app built with Flutter + FastAPI + MongoDB.

It appears AI-powered in UX, while internally using deterministic rules for consistency and explainability.

## What Is Implemented

- JWT auth (register/login)
- 3-step onboarding
- AI-like personality analysis experience
- Deterministic MBTI engine (keyword scoring)
- Deterministic compatibility scoring (mathematical formula)
- Dynamic explanation generation for each match
- Match discovery and match detail screens
- Profile screen

## Deterministic Personality Engine

Implemented in [backend/services/mbti_engine.py](backend/services/mbti_engine.py)

Rules:

- E/I keywords
  - E: party, social, friends, talk, outgoing
  - I: alone, quiet, books, thinking, calm
- N/S keywords
  - N: ideas, future, imagination, creative
  - S: facts, practical, real, details
- T/F keywords
  - T: logic, objective, analyze, reason
  - F: feelings, emotions, care, empathy
- J/P keywords
  - J: plan, organized, schedule, structure
  - P: spontaneous, flexible, explore, adapt

Output:

- `mbti` (dominant trait per axis)
- `confidence` (deterministic weighted dominance, non-random)
- `keyword_counts` (explainability)

## Deterministic Match Scoring

Implemented in [backend/services/matching.py](backend/services/matching.py)

Formula:

- E/I opposite = +25
- N/S same = +25
- T/F opposite = +25
- J/P same = +25
- Shared interests = +5 per overlap
- Final score = `min(100, base + interest_bonus)`

No randomness is used.

## AI-like Explanation Layer

Implemented in [backend/services/explanation.py](backend/services/explanation.py)

Dynamic templates generate reasons based on:

- axis compatibility outcomes
- shared interests

The frontend presents this as an AI explanation experience.

## Backend Structure

```
backend/
  app.py
  requirements.txt
  security.py
  database/
    connection.py
    models.py
  services/
    mbti_engine.py
    matching.py
    explanation.py
  routes/
    auth.py
    user.py
    match.py
```

## Frontend Structure

```
frontend/lib/
  main.dart
  router.dart
  theme.dart
  models/api_models.dart
  services/api_service.dart
  screens/
    splash_screen.dart
    auth/
      login_screen.dart
      register_screen.dart
    onboarding/
      onboarding_screen.dart
      analysis_screen.dart
    home/
      home_screen.dart
    matches/
      matches_screen.dart
      match_detail_screen.dart
    profile/
      profile_screen.dart
```

## API Endpoints

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/users/assessment-questions`
- `POST /api/users/onboarding`
- `GET /api/users/me`
- `GET /api/matches/find?limit=20`
- `GET /api/matches/{match_user_id}`

Docs: `http://localhost:8000/docs`

## Local Setup

### 1) Start MongoDB

Use local MongoDB or MongoDB Atlas URL.

Optional env vars:

- `MONGODB_URL` (default: `mongodb://localhost:27017`)
- `MONGODB_DB` (default: `vynk`)
- `JWT_SECRET` (default fallback in dev only)

### 2) Backend

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r backend/requirements.txt

# From project root:
python -m uvicorn backend.app:app --reload

# Or from backend/:
cd backend
python -m uvicorn app:app --reload
```

### 3) Frontend

```bash
cd frontend
flutter pub get
flutter run -d web-server --web-port 8080
```

Frontend URL: `http://localhost:8080`

## Notes

- MBTI is computed once during onboarding.
- Matching reuses stored MBTI and interests.
- UX messaging remains AI-like while logic stays deterministic and explainable.

## Future Upgrade Path

The backend service boundaries make it easy to replace `mbti_engine.py` with an actual ML model later, without changing API contracts or frontend flow.
