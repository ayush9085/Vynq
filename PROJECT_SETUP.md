# Vynq Project Architecture & Setup

## 📂 Directory Structure

```
/Users/ayush9085/Documents/Vync/
│
├── 🔵 BACKEND (FastAPI - Deploy to Railway)
│   ├── backend/
│   │   ├── app.py                 # Main FastAPI app
│   │   ├── models.py              # Database models
│   │   ├── schemas.py             # Pydantic schemas
│   │   ├── crud.py                # Database operations
│   │   ├── database.py            # Database config
│   │   ├── routes/
│   │   │   ├── auth.py            # Login/Signup endpoints
│   │   │   ├── profiles.py        # User profile endpoints
│   │   │   ├── onboarding.py      # Assessment endpoints
│   │   │   └── matches.py         # Match endpoints
│   │   └── utils/
│   │       ├── jwt_utils.py       # JWT token handling
│   │       └── match_engine.py    # Match algorithm
│   │
│   ├── requirements.txt           # Python dependencies
│   ├── Procfile                   # Railway deployment config
│   ├── runtime.txt                # Python version
│   └── .env.example               # Environment variables template
│
├── 📱 MOBILE APP (Flutter - iOS + Android)
│   ├── vynq_mobile/
│   │   ├── lib/
│   │   │   ├── main.dart                    # App entry point
│   │   │   ├── config/
│   │   │   │   └── api_config.dart          # Backend API URL
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── match_model.dart
│   │   │   │   └── question_model.dart
│   │   │   ├── services/
│   │   │   │   ├── api_service.dart         # HTTP calls to backend
│   │   │   │   ├── auth_service.dart        # Auth logic
│   │   │   │   └── storage_service.dart     # Local storage (tokens)
│   │   │   ├── providers/
│   │   │   │   ├── auth_provider.dart       # State management
│   │   │   │   └── matches_provider.dart
│   │   │   ├── screens/
│   │   │   │   ├── auth/
│   │   │   │   │   ├── login_screen.dart
│   │   │   │   │   └── signup_screen.dart
│   │   │   │   ├── assessment/
│   │   │   │   │   └── questions_screen.dart
│   │   │   │   ├── home/
│   │   │   │   │   ├── home_screen.dart
│   │   │   │   │   └── matches_list.dart
│   │   │   │   └── profile/
│   │   │   │       └── profile_screen.dart
│   │   │   └── widgets/
│   │   │       ├── custom_buttons.dart
│   │   │       ├── custom_text_fields.dart
│   │   │       └── loading_widget.dart
│   │   │
│   │   ├── pubspec.yaml            # Flutter dependencies
│   │   ├── pubspec.lock            # Dependency lock file
│   │   ├── ios/                    # iOS-specific configs
│   │   ├── android/                # Android-specific configs
│   │   └── assets/                 # Images, icons, fonts
│   │
│   ├── test/                       # Flutter tests
│   └── integration_test/           # E2E tests
│
├── 🌐 WEB APP (Streamlit - Optional Keep)
│   └── streamlit_app.py            # Existing Streamlit UI
│
├── 📋 DOCUMENTATION
│   ├── HOSTING_MOBILE_GUIDE.md     # Comprehensive guide
│   ├── QUICKSTART.md               # Quick start steps
│   ├── ARCHITECTURE.md             # Architecture overview
│   ├── PROJECT_SETUP.md            # This file
│   └── RAILWAY_DEPLOYMENT.md       # Railway-specific guide
│
├── ⚙️ CONFIG FILES
│   ├── .env.example                # Environment vars template
│   ├── .gitignore                  # Git ignore patterns
│   ├── Procfile                    # Railway deployment
│   ├── runtime.txt                 # Python version
│   └── pubspec.yaml                # Flutter config
│
└── 📝 PROJECT TRACKING
    ├── PROJECT_STATUS.md           # Current status
    └── TODO.md                     # Tasks tracker (this file)
```

---

## 🔄 Data Flow

### Authentication Flow
```
User in Flutter App
    ↓
Taps "Login" or "Sign Up"
    ↓
Flutter → HTTP POST to FastAPI Backend (on Railway)
    ↓
Backend validates credentials
    ↓
Backend returns JWT token
    ↓
Flutter stores token locally (secure storage)
    ↓
Flutter navigates to Home screen
```

### API Calls Flow
```
Flutter App (with stored JWT token)
    ↓
Makes API request to Railway backend
    ↓
Includes: Authorization: Bearer {token}
    ↓
Backend validates token
    ↓
Backend executes logic + returns data
    ↓
Flutter updates UI
```

---

## 🚀 Immediate Action Items

### Phase 1: Railway Deployment (This Week)
- [ ] Prepare backend for production
- [ ] Create Procfile + runtime.txt
- [ ] Push to GitHub
- [ ] Deploy on Railway.app
- [ ] Test endpoints work from Railway URL

### Phase 2: Flutter Setup (Week 2)
- [ ] Create Flutter project structure
- [ ] Setup cross-platform compatibility
- [ ] Configure API endpoints
- [ ] Build auth screens (login/signup)
- [ ] Test connection to Railway backend

### Phase 3: Flutter Core Features (Week 3)
- [ ] Build assessment flow
- [ ] Build matches display
- [ ] Build user profile
- [ ] Test full flows

### Phase 4: Polish & Deploy (Week 4)
- [ ] UI/UX polish
- [ ] Testing on real devices
- [ ] App Store submission (iOS)
- [ ] Play Store submission (Android)

---

## 🔗 Backend Endpoints Used by Flutter

```
POST   /api/auth/signup          → Create new user
POST   /api/auth/login           → Login user (returns JWT)
GET    /api/profiles/me          → Get logged-in user profile
PUT    /api/profiles/update      → Update user profile
GET    /api/onboarding/questions → Get assessment questions
POST   /api/onboarding/submit    → Submit assessment answers
GET    /api/matches/             → Get user matches
POST   /api/matches/compute      → Compute matches
```

**All endpoints already exist in your FastAPI backend!**

---

## 📦 Key Technologies

### Backend
- **Framework**: FastAPI
- **Database**: SQLite (local) → PostgreSQL (Railway)
- **Auth**: JWT tokens
- **Hosting**: Railway.app

### Mobile
- **Framework**: Flutter (Dart)
- **State Management**: Provider pattern
- **Storage**: Secure local storage for JWT tokens
- **API Client**: http package (Dart)
- **Testing**: Flutter test framework

### Deployment
- **Backend**: Railway.app (auto-deploys from GitHub)
- **iOS**: Apple App Store
- **Android**: Google Play Store
- **CI/CD**: GitHub Actions (optional)

---

## ⚡ Why This Architecture?

✅ **One Backend** = No code duplication
✅ **Flutter** = Single codebase for iOS + Android
✅ **Railway** = Simple, fast deployment (5 minutes)
✅ **JWT Auth** = Stateless, scalable
✅ **Shared API** = Web/Mobile/Future use same endpoints
✅ **Quick MVP** = 2-4 weeks to full MVP

---

## 🎯 Success Criteria

- ✅ Backend hosted on Railway (live URL)
- ✅ Flutter app connects to live backend
- ✅ Login/Signup works end-to-end
- ✅ Can fetch matches from backend
- ✅ JWT tokens refresh automatically
- ✅ Ready for App Store/Play Store submission

---

**Next Step**: Follow the TODO.md file for step-by-step execution.
