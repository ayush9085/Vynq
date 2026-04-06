# VYNK Frontend - Flutter Mobile App

Mobile-first personality-based matchmaking app powered by MBTI classification.

## 🎨 Design System

- **Primary Color**: Gold (#D4AF37)
- **Secondary Color**: Lavender (#E6E6FA)
- **Background**: White (#FFFFFF)
- **Style**: Minimal, elegant, premium feel with soft gradients

## 📱 Features

### Authentication
- User registration with email and password
- User login
- JWT token-based authentication

### Onboarding (3-step)
1. **Basic Info**: Age and Gender
2. **Interests**: Select from predefined interests
3. **Assessment**: Answer personality questions

After completing onboarding, the backend runs MBTI prediction (ML inference happens once).

### Home Screen
- Display user's MBTI type and confidence score
- Quick access to matches and profile

### Matching
- Find compatible matches based on MBTI and interests
- View compatibility score (0-100%)
- See why users match
- View detailed match profiles

### Profile
- View personal information
- MBTI type and confidence
- Interests and bio
- Member since date
- Logout option

## 🚀 Setup

### Requirements
- Flutter 3.0+
- Dart 3.0+
- macOS / Windows / Linux (for development)

### Installation

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure API endpoint** (if not localhost):
   Edit `lib/services/api_service.dart` and change `baseUrl`

3. **Run the app**:
   ```bash
   flutter run
   ```

### Build APK (Android)
```bash
flutter build apk --release
```

### Build iOS (requires macOS)
```bash
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── theme.dart             # Color scheme and theme
├── router.dart            # Navigation setup
├── models/
│   └── api_models.dart    # Data models
├── services/
│   └── api_service.dart   # API communication
└── screens/
    ├── splash_screen.dart
    ├── auth/
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── onboarding/
    │   └── onboarding_screen.dart
    ├── home/
    │   └── home_screen.dart
    ├── matches/
    │   ├── matches_screen.dart
    │   └── match_detail_screen.dart
    └── profile/
        └── profile_screen.dart
```

## 🔌 API Integration

The app communicates with the backend at:
- **Base URL**: `http://localhost:8000/api`

### Key Endpoints

- `POST /auth/register` - Register new user
- `POST /auth/login` - Login user
- `GET /users/assessment-questions` - Get onboarding questions
- `POST /users/onboarding` - Submit onboarding and get MBTI
- `GET /users/{id}` - Get user profile
- `GET /matches/find` - Find matches
- `GET /matches/{matchId}` - Get match details
- `POST /matches/record-match/{matchId}` - Record match interaction

Authentication uses Bearer tokens stored in SharedPreferences.

## 🧪 Testing

To test locally:

1. Start the backend server (see backend README)
2. Ensure MongoDB is running
3. Update API URL in `api_service.dart` to your backend URL
4. Run Flutter app: `flutter run`

## 📦 Dependencies

- **provider**: State management
- **go_router**: Navigation
- **http**: HTTP requests
- **shared_preferences**: Local storage for auth tokens
- **intl**: Internationalization
- **flutter_svg**: SVG support
- **smooth_page_indicator**: Page indicators for onboarding

## 🛠️ Development

- **Hot reload**: Press `r` in terminal while running
- **Hot restart**: Press `R` in terminal while running
- **Debug**: Use Chrome DevTools or Android Studio

## 📝 Future Enhancements

- [ ] User avatars / image upload
- [ ] Edit profile feature
- [ ] Messaging system
- [ ] Push notifications
- [ ] Matches history
- [ ] Preferences/settings
- [ ] Dark mode support

## 📄 License

Part of VYNK project.
