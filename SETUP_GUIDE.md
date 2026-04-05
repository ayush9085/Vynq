# Vynq - Personality-Based Dating App

**Where Personality Meets Connection** — Skip the endless swiping and find people who truly understand you.

## 🎯 Project Vision

Vynq is a personality-based dating application that uses MBTI-inspired psychological traits for matching instead of superficial swiping. Users complete a 20-question assessment that captures their personality across 5 trait dimensions, then get matched with compatible people based on genuine psychological compatibility scoring.

## 🏗️ Architecture

### Technology Stack
- **Backend**: FastAPI (Python) with async support
- **Frontend**: Streamlit (pure Python UI)
- **Database**: SQLAlchemy ORM with SQLite (dev) / PostgreSQL (production)
- **Authentication**: JWT tokens with HS256 algorithm
- **Password Security**: bcrypt hashing with passlib

### Project Structure

```
Vync/
├── backend/
│   ├── app.py                      # FastAPI main application
│   ├── requirements.txt            # Python dependencies
│   ├── database/
│   │   ├── models.py              # SQLAlchemy ORM models
│   │   └── connection.py           # Database initialization & session management
│   ├── models/
│   │   └── personality_model.py    # Personality inference & matching engine
│   ├── routes/
│   │   ├── auth.py                # Authentication endpoints (signup, login)
│   │   ├── onboarding.py          # Assessment & personality endpoints
│   │   ├── matches.py             # Compatibility matching endpoints
│   │   └── profiles.py            # User profile management endpoints
│   └── utils/
│       ├── schemas.py             # Pydantic validation models
│       ├── questions.py           # Assessment questions & trait definitions
│       ├── security.py            # JWT & password utilities
│       └── constants.py           # Configuration constants
│
├── frontend/
│   ├── app.py                     # Streamlit main application
│   ├── requirements.txt           # Frontend dependencies
│   └── .streamlit/
│       └── config.toml            # Streamlit theme configuration
│
├── .env.example                   # Environment variables template
├── .gitignore                     # Git ignore patterns
└── README.md                      # This file
```

## 📊 Personality System

### 5 Trait Dimensions

The assessment measures personality across 5 continuous dimensions (0-1 scale):

1. **Introversion ↔ Extraversion** - Social energy level
2. **Intuition ↔ Sensing** - Information processing style
3. **Thinking ↔ Feeling** - Decision-making approach
4. **Judging ↔ Perceiving** - Life organization preference
5. **Communication Style** - Direct vs. indirect communication

### Assessment Questions

- **20 questions** targeting the 5 trait dimensions (4 questions per dimension)
- **Multiple formats**: Multiple choice, Likert scale (1-5), and open-ended text responses
- **Result**: 5-dimensional trait vector representing user's personality profile

### Compatibility Matching

- **Algorithm**: Normalized Euclidean distance-based scoring
- **Scoring**: Calculates distance between two trait vectors and converts to 0-100% compatibility
- **Explanation**: Generates human-readable explanations for why two users are compatible

Example: *"You both tend toward feeling-based decisions and prefer structured approaches to life. You're likely to understand each other's emotional needs and appreciate similar planning styles."*

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- pip or conda package manager

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/vynq.git
   cd Vync
   ```

2. **Copy environment variables**
   ```bash
   cp .env.example .env
   ```

3. **Set up backend**
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. **Set up frontend**
   ```bash
   cd ../frontend
   pip install -r requirements.txt
   cd ..
   ```

### Running the Application

**Terminal 1 - Start Backend (FastAPI)**
```bash
cd backend
python3 -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at: `http://localhost:8000`
API documentation: `http://localhost:8000/docs` (Swagger UI)

**Terminal 2 - Start Frontend (Streamlit)**
```bash
cd frontend
streamlit run app.py --server.port 8501
```

Frontend will be available at: `http://localhost:8501`

## 📚 API Endpoints

### Authentication (`/api/auth`)

- **POST /auth/signup** - Create new user account
  ```json
  {
    "email": "user@example.com",
    "password": "securepass123",
    "first_name": "Alex",
    "last_name": "Chen"
  }
  ```

- **POST /auth/login** - Login and get JWT token
  ```json
  {
    "email": "user@example.com",
    "password": "securepass123"
  }
  ```

### Onboarding (`/api/onboarding`)

- **GET /onboarding/questions** - Retrieve all 20 assessment questions
- **POST /onboarding/submit-assessment** - Submit assessment responses and compute personality traits
  ```json
  {
    "1": "Option A",
    "2": "4",
    "3": "I like meeting new people"
  }
  ```

### Matches (`/api/matches`)

- **GET /matches/compute** - Compute compatibility against all other users
- **GET /matches/** - Get user's top 10 compatible matches (sorted by score)
- **GET /matches/{match_user_id}** - Get details of a specific match

### Profiles (`/api/profiles`)

- **GET /profiles/me** - Get current user's profile with traits
- **GET /profiles/{user_id}** - Get public profile of another user
- **PUT /profiles/me** - Update user's profile information

All protected endpoints require JWT token in Authorization header:
```
Authorization: Bearer {token}
```

## 🎨 Design System

### Color Palette

- **Primary: Golden** - `#fbb040` - Warmth, connection, positivity
- **Secondary: Lavender** - `#9555ff` - Spirituality, personality, depth
- **Tertiary: White** - `#ffffff` - Clarity, simplicity, space

### Theme

- Modern gradient design combining golden and lavender
- Clean, intuitive navigation emphasizing personality discovery
- Focus on matching quality over quantity

## 📖 User Flow

1. **Signup/Login** - User creates account or logs in with credentials
2. **Personality Assessment** - User answers 20 questions about themselves
3. **Trait Calculation** - System processes responses into 5-dimensional trait vector
4. **Match Discovery** - System computes compatibility with all other users
5. **Browse Matches** - User views ranked matches with compatibility scores and explanations
6. **Profile Management** - User can view/edit their profile and traits

## 🔐 Security

- **Password Security**: Bcrypt hashing with salt (passlib)
- **Authentication**: JWT tokens with HS256 algorithm
- **Token Expiration**: 24-hour expiration for security
- **CORS**: Configured for localhost development (update for production)
- **Database**: SQL injection protection via SQLAlchemy parameterized queries

## 🔄 Database Schema

### Models

- **User** - Core user information (email, password_hash, profile data)
- **TraitVector** - Personality profile (5 trait scores, confidence score)
- **AssessmentQuestion** - Assessment questions (20 total)
- **AssessmentResponse** - User's responses to questions
- **CompatibilityMatch** - Computed matches between users (score + explanation)

## 🛠️ Development

### Adding New Questions

Edit `/backend/utils/questions.py`:

```python
QUESTIONS = {
    "new_id": {
        "text": "Question text here?",
        "type": "single_choice",  # or "text", "likert_scale"
        "options": ["Option 1", "Option 2", "Option 3"],
        "trait": "introversion_extraversion"
    }
}
```

### Customizing Personality Model

The personality model is a placeholder in `/backend/models/personality_model.py`. Replace the `PersonalityModel.process_responses()` method with real ML inference logic (NLP analysis, ML model predictions, etc.)

### Database Migrations

For PostgreSQL production, consider using Alembic for schema migrations. Add `alembic` to requirements.txt.

## 🧪 Testing

### Manual Testing with FastAPI Docs

1. Start backend
2. Navigate to `http://localhost:8000/docs`
3. Use Swagger UI to test all endpoints

### Sample Data

To create test data, modify `/backend/app.py` startup to seed sample users.

## 📝 TODO / Future Features

- [ ] Real AI personality model (replace placeholder)
- [ ] Messaging system between matches
- [ ] Profile photos/image uploads
- [ ] Preference filtering (age range, location radius, etc.)
- [ ] User blocking and reporting
- [ ] Password reset via email
- [ ] Notification system
- [ ] Admin dashboard
- [ ] Mobile app (React Native or Flutter)
- [ ] Database migrations (Alembic)
- [ ] Production deployment guide (Docker, AWS, etc.)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a pull request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👨‍💼 Author

**Vynq Development Team**

---

**Happy matching! 💕**
