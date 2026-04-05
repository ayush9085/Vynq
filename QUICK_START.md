# Vynq Quick Start Guide

Get Vynq up and running in 5 minutes!

## 📋 Prerequisites

- Python 3.8+
- Git

## 🚀 Setup

### Step 1: Clone & Navigate

```bash
cd Vync
```

### Step 2: Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # On macOS/Linux
# or
venv\Scripts\activate     # On Windows
```

### Step 3: Install Dependencies

```bash
# Install backend dependencies
pip install -r backend/requirements.txt

# Install frontend dependencies
pip install -r frontend/requirements.txt
```

### Step 4: Configure Environment

```bash
# Copy environment template
cp .env.example .env

# (Optional: Edit .env to customize settings)
```

## 🏃 Running the Application

### Terminal 1: Start Backend (FastAPI)

```bash
cd backend
python3 -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

**Expected Output:**
```
Uvicorn running on http://0.0.0.0:8000
Press CTRL+C to quit
```

**Access Points:**
- API: `http://localhost:8000`
- Docs: `http://localhost:8000/docs` (Swagger UI)
- ReDoc: `http://localhost:8000/redoc`

### Terminal 2: Start Frontend (Streamlit)

```bash
cd frontend
streamlit run app.py --server.port 8501
```

**Expected Output:**
```
You can now view your Streamlit app in your browser.
Local URL: http://localhost:8501
```

## 🧪 Testing the Application

### Via Swagger UI (Backend API)

1. Open `http://localhost:8000/docs`
2. Try endpoints in this order:
   - **POST /api/auth/signup** - Create account
   - **GET /api/onboarding/questions** - Get assessment questions
   - **POST /api/onboarding/submit-assessment** - Submit responses
   - **GET /api/matches/compute** - Compute matches
   - **GET /api/matches/** - Get matches list

### Via Streamlit UI (Frontend)

1. Open `http://localhost:8501`
2. Follow the flow:
   - Sign up with email/password
   - Complete personality assessment (20 questions)
   - View and compute matches
   - Check your personality profile

## 📊 Test Flow

### Quick Demo with 2 Users

**User 1 - Terminal 1-2:**
1. Sign up: `alex@example.com` / `password123`
2. Complete assessment (answer all 20 questions)
3. View matches (will be empty initially)

**User 2 - Different Browser/Incognito Window:**
1. Sign up: `jordan@example.com` / `password456`
2. Complete assessment (answer all 20 questions)

**Back to User 1:**
1. Click "🔄 Compute Matches" on Matches page
2. Click "📋 Load Matches" to see Jordan as a match
3. Check their compatibility score and explanation

## 🔍 API Test Examples

### Signup
```bash
curl -X POST http://localhost:8000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "first_name": "Alex",
    "last_name": "Chen"
  }'
```

### Login
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Get Questions
```bash
curl http://localhost:8000/api/onboarding/questions
```

### Submit Assessment
```bash
curl -X POST http://localhost:8000/api/onboarding/submit-assessment \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token_from_login}" \
  -d '{
    "1": "Option A",
    "2": "4",
    "3": "I love meeting new people"
  }'
```

## 🐛 Troubleshooting

### Port Already in Use

Backend port 8000 or frontend port 8501 already in use?

```bash
# Backend - use different port
python3 -m uvicorn app:app --reload --port 8001

# Frontend - Streamlit will ask automatically
```

### Module Not Found Errors

Make sure you installed dependencies:

```bash
pip install -r backend/requirements.txt
pip install -r frontend/requirements.txt
```

### JWT Token Errors

- Clear browser cache/cookies
- Get a fresh token by signing up/logging in again
- Token is valid for 24 hours

### Database Issues

Delete the SQLite database and it will be recreated:

```bash
rm backend/vynq.db
```

## 📁 Key Files

| File | Purpose |
|------|---------|
| `backend/app.py` | FastAPI main app |
| `backend/routes/auth.py` | Login/signup |
| `backend/routes/onboarding.py` | Assessment |
| `backend/routes/matches.py` | Matching engine |
| `backend/routes/profiles.py` | User profiles |
| `frontend/app.py` | Streamlit UI |
| `backend/database/models.py` | Database schema |
| `backend/models/personality_model.py` | Personality logic |

## 📚 Documentation

For detailed documentation, see:
- [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Complete architecture guide
- [README.md](./README.md) - Project overview

## ✅ Next Steps

After testing:
1. Customize questions in `backend/utils/questions.py`
2. Replace personality model placeholder with real ML logic
3. Deploy to production (AWS, Heroku, etc.)
4. Add messaging system between matches
5. Implement profile photos/images

## 🆘 Need Help?

Check the logs in the terminal windows for detailed error messages. Most issues are related to:
- Missing dependencies
- Ports in use
- Database connection issues

Happy testing! 🎉
