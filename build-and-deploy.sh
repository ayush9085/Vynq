#!/bin/bash
# 🚀 One-Command Build & Deploy Script

set -e

echo "🚀 VYNK Build & Deploy Helper"
echo "=============================="
echo ""
echo "Choose what to build:"
echo "1) Android APK only"
echo "2) Web app only"
echo "3) Both (Android APK + Web)"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo "📱 Building Android APK..."
        cd frontend
        flutter clean
        flutter pub get
        flutter build apk --release
        echo ""
        echo "✅ APK built successfully!"
        echo "📍 Location: frontend/build/app/outputs/flutter-apk/app-release.apk"
        echo ""
        echo "Next steps:"
        echo "1. Copy to desktop: cp frontend/build/app/outputs/flutter-apk/app-release.apk ~/Desktop/"
        echo "2. Share via Google Drive, email, or Dropbox"
        ;;
    2)
        echo "🌐 Deploying web app to Railway..."
        echo ""
        echo "Prerequisites:"
        echo "✅ Code pushed to GitHub"
        echo "✅ Railway account created"
        echo ""
        echo "Steps:"
        echo "1. Go to https://railway.app"
        echo "2. Click 'New Project'"
        echo "3. Select 'Deploy from GitHub'"
        echo "4. Select 'vync' repository"
        echo "5. Click 'Deploy'"
        echo "6. Wait 5-10 minutes for deployment"
        echo "7. Get your URL from Settings"
        echo ""
        echo "Share URL with users!"
        ;;
    3)
        echo "📱 Building Android APK..."
        cd frontend
        flutter clean
        flutter pub get
        flutter build apk --release
        cd ..
        echo ""
        echo "✅ APK built!"
        echo "📍 Location: frontend/build/app/outputs/flutter-apk/app-release.apk"
        echo ""
        echo "🌐 Now deploying web app to Railway..."
        echo ""
        echo "Push code to GitHub:"
        echo "$ git add ."
        echo "$ git commit -m 'VYNK release'"
        echo "$ git push origin main"
        echo ""
        echo "Then go to railway.app and deploy!"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
