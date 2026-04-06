# 🎯 VYNK - Complete Setup Guide

Personality-based dating app powered by MBTI classification. This guide covers complete setup for both backend and frontend.

## 📋 Prerequisites

### System Requirements
- **macOS/Linux/Windows** for development
- **Python 3.8+** for backend
- **Flutter 3.0+** for frontend
- **MongoDB 4.4+** (local or Atlas cloud)
- **Node.js/npm** (optional, for some tools)

### Install Required Tools

#### macOS
```bash
# Install Brew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python
brew install python@3.11

# Install MongoDB locally (optional - can use Atlas)
brew tap mongodb/brew
brew install mongodb-community

# Install Flutter (follow https://flutter.dev/docs/get-started/install)
```

#### Linux (Ubuntu/Debian)
```bash
# Install Python
sudo apt-get install python3 python3-pip python3-venv

# Install MongoDB
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
sudo apt-get install mongodb-org

# Install Flutter (follow https://flutter.dev/docs/get-started/install)
```

#### Windows
- Install Python from https://www.python.org/downloads/
- Install MongoDB from https://www.mongodb.com/try/download/community
- Install Flutter from https://flutter.dev/docs/get-started/install

---

## 🔧 Backend Setup

### 1. Initialize Python Virtual Environment

```bash
cd /Users/ayush9085/Documents/Vync/backend

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 2. Install Dependencies

```bash
# Install required packages
pip install -r requirements.txt
```

### 3. Configure Environment

```bash
# Create .env file (already exists with defaults)
# Edit if needed for your setup
cat .env

# Key variables:
# MONGODB_URL=mongodb://localhost:27017
# DATABASE_NAME=vynk
# MODEL_PATH=  (leave empty for testing)
```

### 4. Start MongoDB

```bash
# Option A: Local MongoDB
mongod

# Option B: MongoDB Atlas (cloud)
# Update MONGODB_URL in .env with your Atlas connection string
```

### 5. Start Backend Server

```bash
# Make sure you're in backend directory and venv is activated
cd backend
python -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at: **http://localhost:8000**
- API Docs: http://localhost:8000/docs
- Health check: http://localhost:8000/health

---

## 📱 Frontend Setup

### 1. Install Flutter Dependencies

```bash
cd /Users/ayush9085/Documents/Vync/frontend

# Get dependencies
flutter pub get
```

### 2. Configure API Endpoint

Edit `lib/services/api_service.dart` and ensure the API URL matches your backend:

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

For remote backend, use your server's IP or domain.

### 3. Run Flutter App

```bash
# Run on connected device or emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device_id>

# Release build
flutter build apk --release
```

---

## 🚀 Running Everything Together

### Terminal Setup (Recommended: Use 2-3 terminals)

**Terminal 1: MongoDB**
```bash
mongod
```

**Terminal 2: Backend**
```bash
cd /Users/ayush9085/Documents/Vync/backend
source venv/bin/activate
python -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 3: Flutter**
```bash
cd /Users/ayush9085/Documents/Vync/frontend
flutter run
```

---

## 🧪 Testing the Full Flow

### 1. User Registration
- Click "Create Account" on splash screen
- Register with email, first name, last name, password
- Should redirect to onboarding

### 2. Onboarding
- **Step 1**: Enter age and gender
- **Step 2**: Select interests (minimum 3)
- **Step 3**: Answer personality questions
- Click "Analyze" → Backend runs MBTI prediction (placeholder for now)
- Should show MBTI result (e.g., ENFP)

### 3. Home Screen
- View your MBTI type and confidence score
- Access "Find Matches" and "Your Profile"

### 4. Matches
- Click "Find Matches"
- See list of compatible users with scores
- Click on a match to see detailed profile

### 5. Profile
- View your information
- See MBTI type and interests

---

## 🤖 Integration with Model (When Ready)

When you have the pre-trained MBTI classifier:

1. **Save model file** to `backend/ml_models/mbti_classifier.pkl` (or .pt, .h5, etc.)

2. **Update backend/services/mbti_model.py**:
   - Replace `_predict_with_model()` method with your actual inference code
   - Load model from MODEL_PATH in `_load_model()`

3. **Update .env**:
   ```bash
   MODEL_PATH=/path/to/your/mbti_classifier.pkl
   ```

4. **Restart backend** - model will be loaded at startup

Example implementation:
```python
def _predict_with_model(self, text: str) -> Tuple[str, float, Dict[str, float]]:
    import joblib
    mbti_type, confidence = self.model.predict(text)
    trait_scores = self._extract_traits(mbti_type)
    return mbti_type, confidence, trait_scores
```

---

## 📊 API Reference

### Authentication
```bash
# Register
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "password": "password123"
  }'

# Login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Get Assessment Questions
```bash
curl http://localhost:8000/api/users/assessment-questions
```

### Complete Onboarding
```bash
curl -X POST http://localhost:8000/api/users/onboarding \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 25,
    "gender": "male",
    "interests": ["music", "sports", "travel"],
    "responses": {"1": "answer_text", "2": "answer_text"}
  }'
```

### Find Matches
```bash
curl http://localhost:8000/api/matches/find \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 🐛 Troubleshooting

### Backend Issues

**Port already in use**
```bash
# Kill process on port 8000
lsof -i :8000
kill -9 <PID>
```

**MongoDB Connection Error**
```bash
# Check MongoDB is running
mongosh  # Connect to MongoDB shell
```

**Import errors**
```bash
# Reinstall requirements
pip uninstall -r requirements.txt
pip install -r requirements.txt
```

### Flutter Issues

**Emulator not found**
```bash
# Create new emulator
flutter emulators --create --name <name>
flutter emulators --launch <name>
```

**Build cache issues**
```bash
flutter clean
flutter pub get
flutter run
```

### API Connection Issues

**Backend unreachable**
- Check backend is running: `http://localhost:8000/health`
- Check firewall settings
- For remote: update API URL in Flutter

**CORS errors**
- Backend CORS is configured for `localhost:*`
- Add your frontend URL to `CORS_ORIGINS` in `.env`

---

## 📦 Project Structure

```
Vync/
├── backend/
│   ├── app.py                  # FastAPI app
│   ├── requirements.txt        # Python dependencies
│   ├── .env                    # Configuration
│   ├── database/
│   │   ├── connection.py       # MongoDB connection
│   │   └── models.py           # Data models
│   ├── routes/
│   │   ├── auth.py             # Authentication endpoints
│   │   ├── user.py             # User endpoints
│   │   └── match.py            # Matching endpoints
│   ├── services/
│   │   ├── mbti_model.py       # MBTI prediction (model placeholder)
│   │   └── matching.py         # Compatibility algorithm
│   └── ml_models/              # Pre-trained models go here
│
├── frontend/
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── theme.dart          # Design system
│   │   ├── router.dart         # Navigation
│   │   ├── models/
│   │   │   └── api_models.dart # Data models
│   │   ├── services/
│   │   │   └── api_service.dart # API client
│   │   └── screens/            # UI screens
│   ├── pubspec.yaml            # Dependencies
│   └── README.md
│
└── README.md                   # This file
```

---

## 🎨 Design System

**VYNK Theme**
- Primary: Gold (#D4AF37)
- Secondary: Lavender (#E6E6FA)
- Background: White (#FFFFFF)

All colors and typography defined in `frontend/lib/theme.dart`

---

## 📝 Next Steps

1. ✅ Backend structure complete
2. ✅ Frontend UI complete
3. ⏳ Integrate pre-trained MBTI model
4. ⏳ Add messaging system (future)
5. ⏳ Deploy to Render (backend) & Play Store (Flutter)

---

## 🔗 Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Flutter Documentation](https://flutter.dev/docs)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [GO Router Documentation](https://pub.dev/packages/go_router)

---

## 📞 Support

For issues, check:
1. Backend logs: Check terminal running FastAPI
2. Frontend logs: Run with `--verbose` flag
3. MongoDB: Use MongoDB Compass to inspect data
4. API Docs: Visit `http://localhost:8000/docs` for interactive API explorer

---

**Let's build something amazing! 👀**
