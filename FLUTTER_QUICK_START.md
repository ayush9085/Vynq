# 🚀 VYNK Flutter App - Quick Start Guide

## Running the App

### Prerequisites (Already Installed)
- ✅ Flutter SDK
- ✅ Chrome browser
- ✅ Dependencies installed

### Start the App

```bash
cd /Users/ayush9085/Documents/Vync/frontend
flutter run -d chrome
```

The app will automatically open in Chrome at http://localhost (with dynamic port).

## Hot Reload While Running

While the app is running, you can edit code and reload instantly:

- Press **`r`** in terminal → Hot reload (keep state)
- Press **`R`** in terminal → Hot restart (fresh start)
- Press **`q`** in terminal → Quit app
- Press **`h`** in terminal → Help menu

## Terminal Commands While Running

```
r                    Hot reload
R                    Hot restart
h                    Help
q                    Quit
d                    Detach (quit flutter but keep app running)
```

## Backend API Integration

To connect to the backend:

1. **Start MongoDB** (if running locally):
   ```bash
   mongod
   ```

2. **Start Backend** in another terminal:
   ```bash
   cd /Users/ayush9085/Documents/Vync/backend
   source venv/bin/activate
   python -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
   ```

3. **Verify Backend Health**:
   ```bash
   curl http://localhost:8000/health
   ```

4. **View API Docs**:
   Open http://localhost:8000/docs in browser

## Testing the App

### User Registration
1. Click "Create Account"
2. Enter: Email, First Name, Last Name, Password
3. Should redirect to onboarding

### Onboarding Flow
1. **Step 1**: Enter age (e.g., 25) and gender
2. **Step 2**: Select 3+ interests
3. **Step 3**: Answer personality questions
4. Click "Analyze" → Shows MBTI result (with backend: real prediction; without: placeholder)

### Main Features
- **Home**: View your MBTI type
- **Find Matches**: Browse compatible users
- **Match Details**: See why you match
- **Profile**: View your information
- **Logout**: Sign out

## File Structure

Important files to know:

```
frontend/lib/
├── main.dart                    # App entry point
├── theme.dart                   # Design system (gold/lavender colors)
├── router.dart                  # Navigation routes
├── screens/
│   ├── splash_screen.dart      # Loading screen
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── matches/
│   │   ├── matches_screen.dart
│   │   └── match_detail_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── services/
│   └── api_service.dart        # HTTP client for backend
└── models/
    └── api_models.dart         # Data models
```

## Customizing API URL

To change the backend URL (e.g., for remote server):

Edit `frontend/lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://your-server:8000/api';
```

## Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Chrome not found
```bash
flutter devices  # List available devices
flutter run -d <device_name>
```

### Hot reload not working
```bash
# Press R for hot restart
# Or quit and restart the app
```

### API connection issues
- Check backend is running: `curl http://localhost:8000/health`
- Check API URL in `api_service.dart`
- Check CORS settings in backend `.env`

## Build for Production

### Web Build
```bash
flutter build web --release
# Output: build/web/
```

### Android Build (requires Android SDK)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## Development Tips

1. **Use DevTools** - Click DevTools link in terminal to debug
2. **Hot Reload Often** - Press `r` after every code change
3. **Check Logs** - Terminal shows all errors and logs
4. **Format Code** - `flutter format lib/`
5. **Check Lint** - `flutter analyze`

---

**App is ready for development! 🎉**
