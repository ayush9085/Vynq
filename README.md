# Vynq 👀

**A personality-based dating application that moves beyond swipes.**

> Pronounced "wink"—where meaningful connections begin.

> Meaningful connections through psychological compatibility—not superficial swipes.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Installation & Setup](#installation--setup)
- [Getting Started](#getting-started)
- [Architecture Overview](#architecture-overview)
- [Personality Model](#personality-model)
- [API Reference](#api-reference)
- [Database Schema](#database-schema)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [License](#license)

---

## Overview

Vynq is a modern, psychology-driven dating platform designed to create meaningful connections through behavioral and psychological compatibility matching. Instead of superficial swiping, users answer thoughtfully designed conversational questions during onboarding, which are processed using an MBTI-inspired personality model to generate continuous trait vectors. These vectors are then used to compute compatibility scores with other users, providing matches ranked by genuine psychological alignment.

### The Problem

Traditional dating apps rely on:
- Superficial visual judgments
- Limited profile information
- Endless swiping with poor match quality
- No understanding of communication style or emotional compatibility

### The Solution

Vynq solves this by:
- Capturing deep personality insights through intelligent questioning
- Computing true psychological compatibility
- Surfacing matches with explainable confidence scores
- Building trust through transparency and privacy

---

## Key Features

- **🧠 Personality Assessment**: ~15–20 conversational-style onboarding questions that capture preferences, communication style, and emotional tendencies
- **📊 Trait Vectors**: Pre-trained MBTI-inspired model generating continuous personality trait scores (0–1 scale) for efficient, database-native matching
- **🎯 Intelligent Matching**: Distance-based compatibility scoring algorithm ranking users by psychological similarity
- **💡 Compatibility Insights**: Human-readable explanations alongside compatibility percentages (e.g., "Shared communication style," "Emotional alignment," "Similar values")
- **🔒 Privacy-First Design**: User-consented data only, minimal raw text storage, modular architecture for future extensions
- **⚡ Scalable Full-Stack**: FastAPI/Flask backend, PostgreSQL/MongoDB database, React frontend with optimized performance

---

## Project Structure

```
vynq/
├── backend/
│   ├── app.py                 # Main FastAPI/Flask application
│   ├── models/
│   │   ├── personality_model.py    # MBTI-inspired trait inference
│   │   └── matching_engine.py      # Compatibility scoring algorithm
│   ├── routes/
│   │   ├── auth.py                 # Authentication endpoints
│   │   ├── onboarding.py           # Personality questions & responses
│   │   ├── matches.py              # Match retrieval & recommendations
│   │   └── profiles.py             # User profile management
│   ├── database/
│   │   ├── models.py               # SQLAlchemy/PyMongo models
│   │   └── connection.py           # DB connection management
│   ├── utils/
│   │   ├── constants.py            # Questions, trait definitions
│   │   └── validators.py           # Data validation
│   └── requirements.txt             # Python dependencies
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Onboarding/         # Multi-step personality quiz
│   │   │   ├── Matches/            # Match cards & recommendations
│   │   │   ├── Profile/            # User profile view/edit
│   │   │   └── Common/             # Shared UI components
│   │   ├── pages/
│   │   ├── services/
│   │   │   └── api.js              # Backend API client
│   │   ├── styles/
│   │   └── App.js
│   ├── package.json
│   └── .env.example
│
├── database/
│   ├── schema.sql                  # PostgreSQL schema (if using SQL)
│   ├── migrations/                 # Database migrations
│   └── seed.json                   # Sample data for testing
│
├── docs/
│   ├── ARCHITECTURE.md             # System design & flow diagrams
│   ├── PERSONALITY_MODEL.md        # Model details & trait definitions
│   ├── API.md                      # Complete API documentation
│   ├── DATABASE.md                 # Schema & relationships
│   └── DEPLOYMENT.md               # Production setup guide
│
└── README.md                       # This file
```

---

## Tech Stack

| Layer | Technology | Choice |
|-------|-----------|--------|
| **Backend** | FastAPI or Flask | FastAPI recommended for async performance |
| **Database** | PostgreSQL or MongoDB | PostgreSQL recommended for structured data & ACID compliance |
| **Frontend** | React | With TypeScript for type safety |
| **ML/AI** | MBTI-inspired model | Pre-trained model stored as JSON/pickle |
| **Authentication** | JWT | Secure token-based auth |
| **Deployment** | Docker + AWS/Heroku | Containerized for scalability |

---

## Installation & Setup

### Prerequisites

- **Python 3.9+** (backend)
- **Node.js 16+** (frontend)
- **PostgreSQL 12+** or **MongoDB 4.4+** (database)
- **Git**

### Backend Setup

```bash
cd backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment variables
cp .env.example .env
# Edit .env with your database URL, secret keys, etc.

# Run migrations
alembic upgrade head

# Start the server
uvicorn app:app --reload
# Server runs on http://localhost:8000
```

### Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your backend API URL (e.g., http://localhost:8000)

# Start dev server
npm start
# App runs on http://localhost:3000
```

### Database Setup

```bash
# PostgreSQL
createdb vynq
psql vynq < database/schema.sql

# Or MongoDB (if using NoSQL)
# Launch MongoDB and initialize via backend migrations
```

---

## Getting Started

### For Users

1. **Sign Up** → Create account with email/phone
2. **Answer Questions** → Complete ~15–20 personality assessment questions
3. **View Personality Profile** → See your generated trait vector breakdown
4. **Discover Matches** → Browse recommendations sorted by compatibility
5. **Connect** → Message matches with high compatibility scores

### For Developers

1. Clone the repository
2. Follow [Installation & Setup](#installation--setup)
3. Read [ARCHITECTURE.md](docs/ARCHITECTURE.md) for system design
4. Check out the [API Reference](#api-reference) below
5. Start contributing! (See [Contributing](#contributing))

### Quick Test

```bash
# Terminal 1: Start backend
cd backend && uvicorn app:app --reload

# Terminal 2: Start frontend
cd frontend && npm start

# Terminal 3: Test API
curl http://localhost:8000/health
```

---

## Architecture Overview

### System Flow

```
User Sign Up
    ↓
Onboarding Questions (15-20 questions)
    ↓
MBTI-Inspired Model Processing
    ↓
Generate Trait Vector (5 dimensions, 0-1 scale)
    ↓
Store in Database
    ↓
"Find Matches" Request
    ↓
Retrieve User's Trait Vector
    ↓
Compare Against All Other Users (distance-based algorithm)
    ↓
Rank & Score Matches
    ↓
Generate Human-Readable Explanations
    ↓
Return Top 10-20 Matches with Scores & Insights
```

### Core Components

- **Personality Model**: Pre-trained neural network or statistical model that processes question responses → trait vectors
- **Matching Engine**: Vector similarity algorithm (cosine distance, Euclidean distance, or custom metric)
- **Backend API**: RESTful endpoints for authentication, onboarding, matches, profiles
- **Frontend UI**: React components for guided onboarding, match discovery, chat (future)

---

## Personality Model

### MBTI-Inspired Trait System

The model generates **5 continuous personality dimensions** (each scored 0–1):

1. **Introversion (I) ↔ Extraversion (E)** — Social energy & preference for interaction
2. **Intuition (N) ↔ Sensing (S)** — How you perceive information (abstract vs. concrete)
3. **Thinking (T) ↔ Feeling (F)** — Decision-making style (logic vs. emotion)
4. **Judging (J) ↔ Perceiving (P)** — Approach to structure (planned vs. spontaneous)
5. **Communication Style (custom)** — Direct vs. diplomatic, formal vs. casual

### Example Trait Vector

```json
{
  "user_id": "12345",
  "traits": {
    "introversion_extraversion": 0.65,    // More extroverted
    "intuition_sensing": 0.42,             // Balanced, slight sensing
    "thinking_feeling": 0.78,              // Strong feeling preference
    "judging_perceiving": 0.55,            // Balanced
    "communication_style": 0.60            // Moderately direct
  },
  "confidence": 0.87,                      // Model confidence score
  "generated_at": "2026-04-05T10:30:00Z"
}
```

### Compatibility Scoring

**Distance Formula**: Normalized Euclidean distance between trait vectors

```
compatibility_score = 1 - (distance / max_distance)
```

**Result**: 0–100% compatibility with explanations like:
- "High emotional alignment (F trait match)"
- "Similar communication style"
- "Complementary decision-making approaches"

---

## API Reference

### Base URL: `http://localhost:8000/api`

### Authentication

All endpoints (except `/auth/signup`, `/auth/login`) require JWT token in header:

```
Authorization: Bearer <token>
```

### Endpoints Overview

| Method | Endpoint | Description |
|--------|----------|-------------|
| **POST** | `/auth/signup` | Create new account |
| **POST** | `/auth/login` | Get JWT token |
| **POST** | `/auth/logout` | Invalidate token |
| **GET** | `/onboarding/questions` | Get personality assessment questions |
| **POST** | `/onboarding/submit` | Submit responses & generate traits |
| **GET** | `/profiles/me` | Get own personality profile |
| **GET** | `/profiles/{user_id}` | Get another user's profile (public) |
| **PUT** | `/profiles/me` | Update profile info |
| **GET** | `/matches` | Get recommended matches (paginated) |
| **GET** | `/matches/{match_id}` | Get match details & compatibility explanation |
| **POST** | `/messages` | Send message to match (future) |
| **GET** | `/messages/{match_id}` | Get conversation history (future) |

### Example: Get Matches

**Request**:
```bash
GET /api/matches?limit=10&offset=0
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "matches": [
    {
      "user_id": "67890",
      "name": "Alex",
      "age": 26,
      "compatibility_score": 87,
      "explanation": "Strong emotional alignment and similar communication preferences",
      "traits_summary": {
        "introversion_extraversion": 0.62,
        "thinking_feeling": 0.81
      }
    },
    {
      "user_id": "11111",
      "name": "Jordan",
      "age": 24,
      "compatibility_score": 79,
      "explanation": "Complementary decision-making styles, shared values",
      "traits_summary": {
        "introversion_extraversion": 0.68,
        "thinking_feeling": 0.45
      }
    }
  ],
  "total_count": 45,
  "has_more": true
}
```

### Error Responses

```json
{
  "error": "Unauthorized",
  "status": 401,
  "message": "Invalid or expired token"
}
```

---

## Database Schema

### User Table

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  age INT,
  bio TEXT,
  photos JSONB[],
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Trait Vectors Table

```sql
CREATE TABLE trait_vectors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  introversion_extraversion FLOAT NOT NULL,
  intuition_sensing FLOAT NOT NULL,
  thinking_feeling FLOAT NOT NULL,
  judging_perceiving FLOAT NOT NULL,
  communication_style FLOAT NOT NULL,
  confidence FLOAT NOT NULL,
  generated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);
```

### Assessment Responses Table

```sql
CREATE TABLE assessment_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question_id INT NOT NULL,
  response TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Matches Table (optional—can be computed on-demand)

```sql
CREATE TABLE matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id_1 UUID NOT NULL REFERENCES users(id),
  user_id_2 UUID NOT NULL REFERENCES users(id),
  compatibility_score FLOAT NOT NULL,
  computed_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id_1, user_id_2)
);
```

---

## Contributing

### Guidelines

1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/my-feature`
3. **Write tests** for new functionality
4. **Follow PEP 8** (Python) & **Prettier** (JavaScript) formatting
5. **Submit a pull request** with clear description
6. **Code review** by maintainers before merge

### Development Workflow

```bash
# Install pre-commit hooks
pre-commit install

# Run tests
pytest backend/tests
npm test --prefix frontend

# Lint & format
black backend
eslint frontend/src

# Commit & push
git add .
git commit -m "feat: add personality model v2"
git push origin feature/my-feature
```

### Reporting Issues

- Use GitHub Issues with clear title and description
- Include reproduction steps for bugs
- Suggest solutions when possible

---

## Roadmap

### Phase 1: MVP (Q2 2026)
- [x] Project structure & setup
- [ ] Backend API with personality model
- [ ] User authentication (JWT)
- [ ] Database schema & migrations
- [ ] Onboarding flow (frontend)
- [ ] Basic match recommendation engine
- [ ] User profiles & match discovery UI

### Phase 2: Polish & Scale (Q3 2026)
- [ ] Advanced matching algorithm (hybrid recommendation)
- [ ] User feedback loop & trait updates
- [ ] Match explanation AI (generate conversational insights)
- [ ] Performance optimization & caching
- [ ] Comprehensive testing & documentation
- [ ] Deployment & monitoring setup

### Phase 3: Social Features (Q4 2026)
- [ ] Real-time messaging (WebSocket)
- [ ] Match notifications
- [ ] User preferences & filtering
- [ ] Premium features (advanced analytics)
- [ ] Social graphs & compatibility groups

### Phase 4: Intelligence & Analytics (Q1 2027)
- [ ] Chat-based personality updates
- [ ] Hybrid recommendation system (traits + interests)
- [ ] Advanced matching metrics & A/B testing
- [ ] User analytics dashboard
- [ ] Predictive compatibility scoring

### Future Considerations
- AI-powered conversation starters based on trait compatibility
- Video profile integration
- Event-based matching (shared interests, activities)
- Privacy-preserving differential matching
- Mobile app (React Native)
- Integration with social profiles (LinkedIn, Instagram traits)

---

## License

TBD

---

## Status

**🚀 Under Development** — Active development on MVP (Phase 1)

**Last Updated**: April 5, 2026

---

**Questions or ideas?** Open an issue or reach out to the team!
