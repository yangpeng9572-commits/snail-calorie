# 食刻輕卡 — 部署指南

## 📱 Android 部署

### 1. 設定 Android SDK

```bash
# 安裝 Android SDK（推薦使用 Android Studio）
# 下載：https://developer.android.com/studio

# 設定環境變數
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 確認 SDK 路徑
flutter doctor -v
```

### 2. 啟動 Firebase（執行 activate_firebase.sh）

```bash
cd /home/a0938/snail

# 如果有 Firebase 啟動腳本
bash scripts/activate_firebase.sh

# 或手動放置 Firebase 設定檔：
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
```

### 3. 建立 Firebase 專案

1. 前往 [Firebase Console](https://console.firebase.google.com/)
2. 點擊「新增專案」
3. 輸入專案名稱：「snail-calorie」或任何名稱
4. 停用 Google Analytics（可選）
5. 點擊「建立專案」

#### 建立 Android 應用程式
1. 在 Firebase Console 新增 Android 應用程式
2. 填入 Android package name：`com.example.snail_calorie`
3. 下載 `google-services.json`
4. 放置到 `android/app/google-services.json`

#### 建立 iOS 應用程式
1. 在 Firebase Console 新增 iOS 應用程式
2. 填入 iOS bundle ID
3. 下載 `GoogleService-Info.plist`
4. 放置到 `ios/Runner/GoogleService-Info.plist`

### 4. 建置 Release APK

```bash
cd /home/a0938/snail

# 確認依賴
flutter pub get

# 建置 release APK
flutter build apk --release

# APK 位置：build/app/outputs/flutter-apk/app-release.apk
```

### 5. 上架 Google Play

1. 前往 [Google Play Console](https://play.google.com/console)
2. 註冊開發者帳號（一次性費用 $25）
3. 點擊「建立應用程式」
4. 填入應用程式資訊（名稱、描述、截圖）
5. 在「正式版」上傳 APK 或 AAB
6. 填寫內容評級問卷
7. 提交審核

---

## 🍎 iOS 部署

### 1. 設定 iOS 開發環境

```bash
# 確認 Xcode 已安裝
xcodebuild --version

# 確認 Flutter iOS 工具鏈
flutter doctor
```

### 2. 建置 iOS App

```bash
cd /home/a0938/snail

# 打開 iOS 模擬器
open -a Simulator

# 建置 iOS 模擬器版本
flutter build ios --simulator --no-codesign

# 或建置 release 版本（需要簽署）
flutter build ios --release
```

### 3. 上架 App Store

1. 前往 [Apple Developer Console](https://developer.apple.com/)
2. 註冊 Apple Developer 帳號（年費 $99）
3. 在 Xcode 設定簽署與Capabilities
4. 在 App Store Connect 建立新應用程式
5. 填入應用程式資訊
6. 上傳建置產出的 .ipa 檔案
7. 提交審核

---

## 🌐 Web 部署

### 方式一：GitHub Pages

```bash
cd /home/a0938/snail

# 建置 Web 版本
flutter build web

# 將 build/web 目錄內容推送到 gh-pages branch
# 或使用 actions 自動部署

# .github/workflows/deploy.yml 範例：
# name: Deploy to GitHub Pages
# on: [push]
# jobs:
#   build:
#     runs-on: ubuntu-latest
#     steps:
#       - uses: actions/checkout@v3
#       - uses: subosito/flutter-action@v2
#       - run: flutter pub get
#       - run: flutter build web
#       - uses: peaceiris/actions-gh-pages@v3
#         with:
#           publish_dir: ./build/web
```

### 方式二：Netlify

```bash
# 安裝 Netlify CLI
npm install -g netlify-cli

cd /home/a0938/snail
flutter build web

# 部署
netlify deploy --prod --dir=build/web
```

### 方式三：Vercel

```bash
npm install -g vercel-cli

cd /home/a0938/snail
vercel --prod
```

---

## 🔧 常見問題

### Firebase 相關

**Q: Firebase Auth 在 iOS 模擬器無法運作？**
A: 這是預期行為。Google Sign-In 在 iOS 模擬器有限制，需要使用真機或 Firebase Emulator。

**Q: 如何啟動 Firebase？**
A: 執行 `bash scripts/activate_firebase.sh`，或手動放置 Firebase 設定檔到指定路徑。

### Android 相關

**Q: `flutter build apk` 失敗，顯示「No Android SDK found」？**
A: 請確認 ANDROID_HOME 環境變數已正確設定，並且 Android SDK 已安裝。

**Q: Android Gradle 版本衝突？**
A: 檢查 `android/build.gradle` 中的 Gradle 版本，確保與 `android/gradle/wrapper/gradle-wrapper.properties` 相容。

### iOS 相關

**Q: CocoaPods 安裝失敗？**
A: 執行 `cd ios && pod install --repo-update`

**Q: Code Signing 錯誤？**
A: 在 Xcode 中重新設定 Signing & Capabilities，確保 Team 已選取。

### Web 相關

**Q: Web 建置成功但無法顯示？**
A: 檢查 `web/index.html` 是否正確引用了 Flutter 產出的 `main.dart.js`。

---

## 📋 部署檢查清單

- [ ] `flutter analyze` 無錯誤
- [ ] `flutter build web` 成功
- [ ] Firebase 專案已建立
- [ ] Firebase 設定檔已放置
- [ ] Android APK 已建置（測試版本）
- [ ] iOS App 已建置（測試版本）
- [ ] 隱私權政策頁面已上線
- [ ] 應用程式截圖已準備
- [ ] 應用程式說明已撰寫
