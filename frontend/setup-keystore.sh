#!/bin/bash
# 🔑 Android Keystore Setup Script
# This creates a signing key for building release APKs

set -e

echo "🔑 VYNK Android Release Keystore Setup"
echo "======================================"
echo ""

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "❌ Error: keytool not found"
    echo "Install Java Development Kit (JDK) first"
    exit 1
fi

# Keystore path
KEYSTORE_PATH="$HOME/.android/vynk-release.jks"
KEYSTORE_ALIAS="vynk-release-key"

# Check if keystore already exists
if [ -f "$KEYSTORE_PATH" ]; then
    echo "✅ Keystore already exists at: $KEYSTORE_PATH"
    echo "Skipping creation..."
    exit 0
fi

echo "📝 Creating Android signing keystore..."
echo ""
echo "You'll be prompted for a password. Remember this password!"
echo ""

# Create keystore
keytool -genkey -v \
    -keystore "$KEYSTORE_PATH" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias "$KEYSTORE_ALIAS" \
    -storepass android \
    -keypass android \
    -dname "CN=VYNK Developer, O=VYNK, C=US"

echo ""
echo "✅ Keystore created successfully!"
echo "📍 Location: $KEYSTORE_PATH"
echo "🔐 Alias: $KEYSTORE_ALIAS"
echo "🔑 Password: android (or your custom password)"
echo ""
echo "✅ You're ready to build release APK!"
