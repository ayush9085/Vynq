# 🚀 Build & Deploy Guide - Android APK + Web App

This guide covers building an Android APK and deploying the web version to Railway.

---

## 📱 Part 1: Build Android APK

### Prerequisites

1. **Android SDK** - Check if installed:
```bash
flutter doctor
```

Look for "Android toolchain" - should be ✓ (green checkmark)

2. **Java Development Kit** (JDK) - Usually comes with Android Studio

### Step 1: Configure Android App

Edit [android/app/build.gradle](android/app/build.gradle):

```gradle
android {
    // ... other config ...
    
    defaultConfig {
        applicationId "com.vynk.app"  // Unique package ID
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    // ... rest of config ...
}
```

### Step 2: Build Release APK

```bash
cd /Users/ayush9085/Documents/Vync/frontend

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build APK (this takes 2-3 minutes)
flutter build apk --release
```

✅ APK will be created at:
```
frontend/build/app/outputs/flutter-apk/app-release.apk
```

### Step 3: Share APK

**Option A: Direct File Sharing**
```bash
# Copy to desktop for easy sharing
cp frontend/build/app/outputs/flutter-apk/app-release.apk ~/Desktop/VYNK.apk

# Share file via:
# - Google Drive
# - Dropbox
# - Email
# - AirDrop
```

**Option B: Upload to Website**
```bash
# Upload to your web server for download link
# Users download via browser
```

### Step 4: Install on Android Phone

1. Email APK to phone or download from link
2. Open Files app
3. Find `app-release.apk`
4. Tap to install
5. Allow "Install from unknown sources" if prompted
6. Done! ✅

---

## 🌐 Part 2: Deploy Web App to Railway

### Step 1: Create GitHub Repository

```bash
cd /Users/ayush9085/Documents/Vync

# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit: VYNK dating app"

# Create repo on GitHub.com, then:
git remote add origin https://github.com/YOUR_USERNAME/vync.git
git branch -M main
git push -u origin main
```

### Step 2: Sign Up on Railway

1. Go to [railway.app](https://railway.app)
2. Click "Start Building"
3. Sign up with GitHub
4. Authorize Railway to access your repos

### Step 3: Deploy Project

1. After login, click "New Project"
2. Select "Deploy from GitHub repo"
3. Select your `vync` repository
4. Click "Deploy"
5. Railway auto-detects `docker-compose.yml` ✅
6. Services start automatically

### Step 4: Get Your URL

1. Go to "Settings" → "Environment"
2. Note the deployed URL: `https://your-app.railway.app`
3. Share this link!

### Step 5: Verify Deployment

```bash
# Test your deployed app
curl https://your-app.railway.app/api/health

# Should return:
# {"status":"healthy","version":"1.0.0","service":"VYNK API"}
```

---

## 📦 Distribution Options

### For Android Users

**Share the APK:**
```
Download link: https://drive.google.com/your-apk-link
Or: https://your-server.com/vynk-app.apk
```

Or use **Google Play Console** for official app store hosting.

### For All Users (Preferred)

**Share the web app:**
```
Web App: https://your-app.railway.app
- Works on Android phone browser
- Works on iPhone
- Works on desktop/laptop
- No app download needed
- Instant updates
```

---

## ✨ Recommended Distribution

### For Initial Sharing:
1. **Android APK** → For dedicated Android app experience
2. **Web URL** → For everyone else + easier

### Example Share Message:
```
🎉 Check out VYNK - A personality-based dating app!

📱 Android App:
Download and install: [APK Link]

🌐 Or use the web app:
Visit: https://your-app.railway.app
```

---

## 🎯 Comparison

| Method | Ease | Share | Update |
|--------|------|-------|--------|
| **Android APK** | Easy | File download | Rebuild & reshare |
| **Web App** | Easy | URL link | Auto-updates on server |
| **Both** | Easy | Both options | Best of both |

---

## 🚨 Important Notes

### APK Security
- APK contains your API endpoint URL
- Make sure API keys/secrets aren't hardcoded
- Currently OK since you're not using sensitive keys in frontend

### Web App Security
- Always use HTTPS in production
- Railway provides free SSL certificates ✅
- Update SECRET_KEY in production

### Database
- MongoDB persists on Railway's managed database
- Your 66+ test users will be available
- Backups automatic

---

## 📊 Current Status

✅ **Code Ready**
- Flutter app built for web
- Backend API ready
- Docker configured

✅ **APK Ready to Build**
- Run: `flutter build apk --release`
- Takes 2-3 minutes
- Creates shareable APK file

✅ **Web Hosting Ready**
- Push to GitHub
- Connect Railway
- Deploy in 2 clicks

---

## 🔗 Next Steps

### To Build APK:
```bash
cd /Users/ayush9085/Documents/Vync/frontend
flutter build apk --release
```

### To Deploy Web:
```bash
cd /Users/ayush9085/Documents/Vync

# Push to GitHub
git add .
git commit -m "Deploy to Railway"
git push origin main

# Then go to railway.app and deploy
```

---

## 📞 Support

If you run into issues:

**APK build fails:** Run `flutter doctor` to check setup
**Railway deployment fails:** Check `docker-compose.yml` is valid
**App connects wrong API:** Verify backend URL in `api_service.dart`

---

**Let's get VYNK live! 🚀**
