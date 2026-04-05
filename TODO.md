# Vynq: Railway + Flutter - TODO List

## 📋 Phase 1: Railway Backend Deployment (This Week)

### Task 1.1: Prepare Backend for Production
- [ ] Ensure `requirements.txt` has all dependencies
- [ ] Add `gunicorn` and `uvicorn` to requirements
- [ ] Set `DEBUG=False` in production config
- [ ] Test backend locally: `python -m uvicorn backend.app:app --reload`

### Task 1.2: Create Deployment Files
- [ ] Create `Procfile` with: `web: gunicorn -w 4 -k uvicorn.workers.UvicornWorker backend.app:app`
- [ ] Create `runtime.txt` with: `python-3.11.7`
- [ ] Create `.env.example` with all env variables
- [ ] Verify both files are in project root

### Task 1.3: Push to GitHub
- [ ] Initialize Git repo (if not done): `git init`
- [ ] Add files: `git add .`
- [ ] Commit: `git commit -m "Production ready: add Railway deployment configs"`
- [ ] Create GitHub repo if needed
- [ ] Push: `git push origin main`

### Task 1.4: Deploy on Railway
- [ ] Go to https://railway.app
- [ ] Sign up with GitHub
- [ ] New Project → Deploy from GitHub repo
- [ ] Select Vynq repository
- [ ] Wait for Railway to detect Python
- [ ] Add environment variables:
  - `SECRET_KEY` = Generate random string
  - `DATABASE_URL` = Leave blank (Railway auto-sets)
  - `DEBUG` = `False`
- [ ] Click Deploy
- [ ] Copy live URL (e.g., `https://vynq-prod.railway.app`)

### Task 1.5: Test Backend
- [ ] Visit `https://your-railway-url/docs` → Should see Swagger UI
- [ ] Test signup endpoint
- [ ] Test login endpoint
- [ ] Verify database is created
- [ ] Check logs for errors

---

## 📱 Phase 2: Flutter Mobile Setup (Week 2)

### Task 2.1: Create Flutter Project Structure
```bash
flutter create vynq_mobile
cd vynq_mobile
```

- [ ] Create folder structure (see PROJECT_SETUP.md)
- [ ] Create `lib/config/api_config.dart`
- [ ] Create `lib/services/api_service.dart`
- [ ] Create `lib/services/auth_service.dart`
- [ ] Create `lib/services/storage_service.dart`

### Task 2.2: Update pubspec.yaml Dependencies
- [ ] Add `provider` for state management
- [ ] Add `http` for API calls
- [ ] Add `shared_preferences` for local storage
- [ ] Add `flutter_secure_storage` for JWT tokens
- [ ] Run `flutter pub get`

### Task 2.3: Setup Environment Configuration
- [ ] Create `lib/config/api_config.dart`
- [ ] Set backend URL to your Railway URL
- [ ] Add DEBUG mode flag
- [ ] Add API timeouts

### Task 2.4: Build Auth Service
- [ ] Create API client in `lib/services/api_service.dart`
- [ ] Implement HTTP interceptor for JWT token
- [ ] Create sign-up method
- [ ] Create login method
- [ ] Create logout method

### Task 2.5: Build Auth State Management
- [ ] Create `AuthProvider` with Provider pattern
- [ ] Handle token storage/retrieval
- [ ] Handle token refresh
- [ ] Handle logout

---

## 🎨 Phase 3: Flutter Auth Screens (Week 2-3)

### Task 3.1: Build Login Screen
- [ ] Create `lib/screens/auth/login_screen.dart`
- [ ] Email/password input fields
- [ ] Login button
- [ ] Connect to backend API
- [ ] Handle errors
- [ ] Navigation on success

### Task 3.2: Build Signup Screen
- [ ] Create `lib/screens/auth/signup_screen.dart`
- [ ] First name, last name inputs
- [ ] Email, password inputs
- [ ] Validation (8+ char password, valid email)
- [ ] Connect to backend API
- [ ] Handle errors
- [ ] Navigation on success

### Task 3.3: Build Home Screen
- [ ] Create `lib/screens/home/home_screen.dart`
- [ ] Display user greeting
- [ ] Add logout button
- [ ] Show loading state

### Task 3.4: Navigation Setup
- [ ] Create `lib/main.dart`
- [ ] Setup navigation between Auth screens
- [ ] Setup navigation to Home after login
- [ ] Handle auto-login if token exists

---

## ⚙️ Phase 4: Core Features (Week 3)

### Task 4.1: Assessment Questions
- [ ] Fetch questions from backend
- [ ] Display questions with answer options
- [ ] Submit answers to backend
- [ ] Handle validation

### Task 4.2: Matches Display
- [ ] Fetch matches from backend
- [ ] Display matches in list
- [ ] Show compatibility score
- [ ] Add user details card

### Task 4.3: User Profile
- [ ] Display user profile
- [ ] Edit profile functionality
- [ ] Update profile on backend
- [ ] Show profile picture option

---

## 🧪 Phase 5: Testing & Deployment (Week 4)

### Task 5.1: Local Testing
- [ ] Run backend locally
- [ ] Test app in iOS Simulator
- [ ] Test app in Android Emulator
- [ ] Test all auth flows
- [ ] Test API calls

### Task 5.2: iOS Deployment
- [ ] Create Apple Developer account
- [ ] Create app in App Store Connect
- [ ] Build iOS release: `flutter build ios`
- [ ] Submit to App Store
- [ ] Wait for review (24-48 hours)

### Task 5.3: Android Deployment
- [ ] Create Google Developer account
- [ ] Create app in Google Play Console
- [ ] Generate signing key
- [ ] Build APK: `flutter build apk`
- [ ] Build App Bundle: `flutter build appbundle`
- [ ] Submit to Play Store
- [ ] Wait for review (usually 1-2 hours)

### Task 5.4: Post-Launch
- [ ] Monitor app reviews
- [ ] Fix bugs based on feedback
- [ ] Plan feature updates
- [ ] Consider adding ratings/reviews

---

## 📊 Progress Tracking

### Week 1: Railway + Backend ✋ START HERE
- [ ] Task 1.1-1.5 complete
- [ ] Backend live on Railway
- [ ] API endpoints tested

### Week 2: Flutter Setup
- [ ] Task 2.1-2.5 complete
- [ ] Flutter project scaffolded
- [ ] Auth service working

### Week 3: Screens + Features
- [ ] Task 3.1-4.3 complete
- [ ] All screens built
- [ ] Core features working

### Week 4: Testing + Launch
- [ ] Task 5.1-5.4 complete
- [ ] Apps on App Stores
- [ ] Ready for users

---

## 🚨 Important Notes

1. **Keep Railway URL Secure**: Don't commit urls with secrets
2. **Environment Variables**: Use .env files, not hardcoding
3. **JWT Tokens**: Store securely in `flutter_secure_storage`
4. **CORS**: Configure on backend if needed
5. **API Changes**: Update Flutter app when backend changes
6. **Testing**: Test on real devices before submission
7. **App Store**: Apple review takes 24-48 hours, be patient

---

## ✅ Definition of Done

Phase is complete when:
- ✅ All tasks are checked
- ✅ No known bugs
- ✅ Tested on real device
- ✅ Code is committed to GitHub
- ✅ Ready for next phase

---

## 📞 Need Help?

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Railway Docs: https://docs.railway.app
- HTTP Package: https://pub.dev/packages/http
- Provider Package: https://pub.dev/packages/provider

---

**Start with Phase 1 - It's only 5 minutes! 🚀**
