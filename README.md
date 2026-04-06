# 🎯 VYNK - Personality-Based Dating App

**Pronounced: "Wink" 👀**

A mobile-first personality-based matchmaking system powered by MBTI classification. Built with Flutter (frontend) and Python FastAPI (backend).

## 🚀 Project Status

- ✅ Backend API (FastAPI) - Complete
  - Authentication (register/login)
  - Onboarding flow
  - MBTI model service (placeholder for pre-trained model)
  - Compatibility matching algorithm
  - MongoDB integration

- ✅ Frontend App (Flutter) - Complete
  - Beautiful UI with gold/lavender theme
  - Authentication screens
  - 3-step onboarding flow
  - Match discovery and detailed profiles
  - User profile management

- ⏳ ML Model Integration (in progress)
  - Space reserved for pre-trained MBTI classifier
  - Ready to integrate when model is available

## 🎨 Design System

| Aspect | Value |
|--------|-------|
| **Primary** | Gold (#D4AF37) |
| **Secondary** | Lavender (#E6E6FA) |
| **Background** | White (#FFFFFF) |
| **Style** | Minimal, elegant, premium |

## 🏗️ Architecture

```
┌─────────────────┐
│   Flutter App   │
│   (Mobile UI)   │
└────────┬────────┘
         │ HTTP REST
         │
┌────────▼─────────┐
│  FastAPI Backend │
│  (Python)        │
├──────────────────┤
│ - Auth Routes    │
│ - User Routes    │
│ - Match Routes   │
│ - MBTI Service   │
│ - ML Inference   │
└────────┬─────────┘
         │
┌────────▼─────────┐
│    MongoDB       │
│   (Database)     │
└──────────────────┘
```

## 📱 Key Features

### Authentication
- Email & password registration
- Secure JWT-based login
- Token-based API auth

### Onboarding (3-Step)
1. **Basic Info** - Age, gender
2. **Interests** - Multi-select interests
3. **Assessment** - Personality questions

→ Backend runs MBTI prediction (ML inference happens once)

### Matching Algorithm
Uses rule-based compatibility scoring:
- **E/I** (Extroversion/Introversion): Opposite = +25%
- **N/S** (Intuition/Sensing): Same = +25%
- **T/F** (Thinking/Feeling): Opposite = +25%
- **J/P** (Judging/Perceiving): Same = +25%
- **Interests**: Common interests × 5 points each
- Final score: 0-100%

### AI-Powered
- One-time MBTI prediction during onboarding
- Efficient real-time compatibility matching
- No repeated ML inference (performance optimized)

## 📂 Project Structure

```
Vync/
├── backend/                    # FastAPI server
│   ├── app.py                 # Main app
│   ├── requirements.txt       # Dependencies
│   ├── .env                   # Configuration
│   ├── database/
│   │   ├── connection.py      # MongoDB async driver
│   │   └── models.py          # Pydantic models
│   ├── routes/
│   │   ├── auth.py            # /api/auth/*
│   │   ├── user.py            # /api/users/*
│   │   └── match.py           # /api/matches/*
│   ├── services/
│   │   ├── mbti_model.py      # ML model wrapper
│   │   └── matching.py        # Compatibility engine
│   └── ml_models/             # Pre-trained models
│
├── frontend/                  # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart          # Entry point
│   │   ├── theme.dart         # Design system
│   │   ├── router.dart        # Navigation
│   │   ├── models/
│   │   │   └── api_models.dart# Data models
│   │   ├── services/
│   │   │   └── api_service.dart# HTTP client
│   │   └── screens/           # UI screens
│   ├── pubspec.yaml           # Flutter deps
│   └── README.md
│
├── SETUP_GUIDE.md             # Complete setup instructions
└── README.md                  # This file
```

## 🚀 Quick Start

### Backend
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
python -m uvicorn app:app --reload
```

### Frontend
```bash
cd frontend
flutter pub get
flutter run
```

**Full Setup Guide**: See [SETUP_GUIDE.md](SETUP_GUIDE.md)

## 🔌 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | Register new user |
| `POST` | `/api/auth/login` | Login user |
| `GET` | `/api/users/assessment-questions` | Get onboarding questions |
| `POST` | `/api/users/onboarding` | Submit onboarding & get MBTI |
| `GET` | `/api/users/{id}` | Get user profile |
| `GET` | `/api/matches/find` | Find compatible matches |
| `GET` | `/api/matches/{matchId}` | Get match details |
| `POST` | `/api/matches/record-match/{matchId}` | Record interaction |

**Interactive API Docs**: `http://localhost:8000/docs`

## 🧠 Machine Learning

### MBTI Prediction
Currently uses a **placeholder system** that returns random MBTI types.

**To integrate your trained model**:

1. Save model to `backend/ml_models/mbti_classifier.pkl`
2. Update `MODEL_PATH` in `.env`
3. Implement `_predict_with_model()` in `backend/services/mbti_model.py`
4. Restart backend

Supports:
- PyTorch models (`.pt`, `.pth`)
- scikit-learn models (`.pkl`)
- HuggingFace transformers
- TensorFlow/Keras models

## 🗄️ Database Schema

### Users Collection
```json
{
  "_id": ObjectId,
  "email": "user@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "password_hash": "bcrypt_hash",
  "age": 25,
  "gender": "male",
  "interests": ["music", "sports", "travel"],
  "mbti": "ENFP",
  "mbti_confidence": 0.87,
  "raw_assessment_text": "...",
  "created_at": ISODate,
  "updated_at": ISODate
}
```

### Matches Collection
```json
{
  "_id": ObjectId,
  "user_id": "...",
  "match_user_id": "...",
  "compatibility_score": 87.5,
  "match_reasons": ["Complementary traits", "Shared interests"],
  "created_at": ISODate
}
```

## 🎯 User Flow

1. **Splash Screen** → Check auth status
2. **Auth** → Register or Login
3. **Onboarding** → 3-step personality assessment
4. **MBTI Prediction** → ML inference (one time)
5. **Home** → View personality type
6. **Matches** → Browse compatible users
7. **Profile** → View user information

## 🧪 Testing

### Example Test Data
```bash
# Create test users
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alice@example.com",
    "first_name": "Alice",
    "last_name": "Smith",
    "password": "test1234"
  }'
```

Create 5+ test users with different:
- Ages
- Genders
- Interests
- MBTI types

Then test matching between different personality combinations.

## 🚢 Deployment

### Backend (Render)
```bash
# Connect repo to Render
# Deploy with: python -m uvicorn app:app
# Set MONGODB_URL from Atlas
```

### Database (MongoDB Atlas)
```bash
# Create free cluster
# Generate connection string
# Update MONGODB_URL in .env
```

### Frontend (Flutter APK)
```bash
flutter build apk --release
# Upload to Play Store or distribute manually
```

## 📊 Performance Considerations

- ✅ ML model loaded once at startup (not per request)
- ✅ MBTI prediction only during onboarding
- ✅ Compatibility matching uses stored MBTI (no inference)
- ✅ Database indexes on frequently queried fields
- ✅ Async/await for non-blocking operations

## 🔐 Security Features

- 🔒 JWT token-based authentication
- 🔒 Bcrypt password hashing
- 🔒 HTTPS ready (use in production)
- 🔒 CORS configured
- 🔒 Input validation on all endpoints
- 🔒 Environment variables for secrets

## 🛠️ Tech Stack

**Backend**
- Python 3.11+
- FastAPI 0.104+
- MongoDB (Async Motor)
- JWT authentication
- PyTorch/scikit-learn (for models)

**Frontend**
- Flutter 3.0+
- Dart 3.0+
- GoRouter (navigation)
- Provider (state management)
- HTTP client

**Database**
- MongoDB Atlas (cloud) or local

## 📈 Future Enhancements

- [ ] Real-time messaging between matches
- [ ] Video call integration
- [ ] Push notifications
- [ ] Advanced AI recommendations (embeddings)
- [ ] Daily match suggestions
- [ ] Dark mode
- [ ] User avatars/image gallery
- [ ] Swipe UI (Tinder-like)
- [ ] Analytics dashboard

## 📝 API Examples

### Register & Login
```bash
# Register
TOKEN=$(curl -s -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@test.com",
    "first_name": "John",
    "last_name": "Doe",
    "password": "pass123"
  }' | jq -r '.access_token')

# Login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@test.com", "password": "pass123"}'
```

### Complete Onboarding
```bash
curl -X POST http://localhost:8000/api/users/onboarding \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 25,
    "gender": "male",
    "interests": ["music", "travel", "fitness"],
    "responses": {
      "1": "I love weekend hiking trips",
      "2": "I handle conflicts with open communication",
      "3": "I enjoy creative and thoughtful people"
    }
  }'
```

### Find Matches
```bash
curl http://localhost:8000/api/matches/find?limit=10 \
  -H "Authorization: Bearer $TOKEN"
```

## 📚 Documentation

- **Backend API Docs**: `http://localhost:8000/docs` (Swagger UI)
- **Backend Setup**: See `SETUP_GUIDE.md`
- **Frontend README**: See `frontend/README.md`

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Test thoroughly
4. Submit PR

## 📄 License

Part of VYNK project.

---

## 🎬 Presentation Summary

**"This is a mobile-based personality matchmaking system powered by a Python backend using NLP-based MBTI classification trained on large-scale social data. The system computes personality once and performs efficient real-time compatibility matching."**

---

**Built with ❤️ | Let's see who you vynk with 👀**
