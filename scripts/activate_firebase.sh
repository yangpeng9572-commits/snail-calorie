#!/bin/bash
# Firebase 啟動腳本
# 用法：bash scripts/activate_firebase.sh <google-services.json路徑> <GoogleService-Info.plist路徑>

set -e

GOOGLE_SERVICES="$1"
IOS_PLIST="$2"

if [ -z "$GOOGLE_SERVICES" ] || [ -z "$IOS_PLIST" ]; then
  echo "用法：bash scripts/activate_firebase.sh <google-services.json路徑> <GoogleService-Info.plist路徑>"
  exit 1
fi

echo "🚀 開始啟動 Firebase..."

# 1. 複製設定檔
cp "$GOOGLE_SERVICES" android/app/google-services.json
cp "$IOS_PLIST" ios/Runner/GoogleService-Info.plist

# 2. 取消 pubspec.yaml 註解
sed -i 's/^  # firebase_core:/  firebase_core:/' pubspec.yaml
sed -i 's/^  # firebase_auth:/  firebase_auth:/' pubspec.yaml
sed -i 's/^  # cloud_firestore:/  cloud_firestore:/' pubspec.yaml
sed -i 's/^  # google_sign_in:/  google_sign_in:/' pubspec.yaml

# 3. flutter pub get
/home/a0938/.local/flutter-sdk/flutter/bin/flutter pub get

echo "✅ Firebase 啟動完成！"
echo "請手動執行：flutter build apk"