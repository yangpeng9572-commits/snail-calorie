# 食刻輕卡 — 小龍女工作指引

> 這是 Hermes AI 為小龍女準備的完整工作包。直接跟著以下步驟執行即可。

---

## 🎯 你的任務

**Phase 2：Firebase 雲端同步 + Phase 3 前期準備**

Hermes 已經完成 MVP（Phase 1），現在需要你接手繼續開發。

---

## 📋 立即可執行的工作清單

### 第一天（今天）

#### Step 1：確認環境
```bash
# 確認 Flutter 版本
flutter --version
# 預期：3.24.0 或更新

# 確認 Android SDK
flutter doctor
# 預期：Flutter、Android toolchain ✓
```

#### Step 2：取得程式碼
```bash
# 在 WSL 環境
cd /home/a0938/snail

# 或者 Andy 會把整個資料夾分享給你
# 確認路徑
ls -la /home/a0938/snail/lib/
```

#### Step 3：安裝依賴
```bash
flutter pub get
flutter analyze    # 確認 0 errors
flutter build web  # 確認成功
```

---

### 第二步：設定 Firebase（新增會員系統）

Andy 需要提供 Firebase 專案。你可以先預備好程式碼，等他給你設定檔。

#### 需要的 Firebase 設定檔
Andy 需到 Firebase Console 建立專案後，提供以下檔案：

**Android (`android/app/google-services.json`)**
- 下載位置：Firebase Console → 專案設定 → Android 應用程式 → 下載 google-services.json
- 放到：`android/app/google-services.json`

**iOS (`ios/Runner/GoogleService-Info.plist`)**
- 下載位置：Firebase Console → 專案設定 → iOS 應用程式 → 下載 GoogleService-Info.plist
- 放到：`ios/Runner/GoogleService-Info.plist`

#### 程式碼修改

在 `pubspec.yaml` 找到這幾行（Firebase 相關被註解掉了）：

```yaml
# 取消註解（拿掉前面的 #）：
firebase_core: ^3.13.0
firebase_auth: ^5.6.0
```

然後執行：
```bash
flutter pub get
```

---

### 第三步：實作 Firebase Auth（會員系統）

#### 3.1 建立登入頁面

新增檔案：`lib/features/auth/login_page.dart`

參考以下結構（Hermes 預留的 Provider 在 `providers/app_providers.dart`）：

```dart
// 你需要實作的部分：
// 1. Google 登入按鈕
// 2. Email/密碼 登入/註冊 表單
// 3. 忘記密碼流程
// 4. 登出功能

// 請參考：
// - Firebase Auth 文件：https://firebase.flutter.dev/docs/auth
// - google_sign_in 套件做 Google 登入
// - 預計需要加到 pubspec.yaml：
//   google_sign_in: ^6.2.1
```

#### 3.2 串接 Firestore（雲端同步）

新增套件：
```yaml
cloud_firestore: ^5.6.6
```

實作雲端同步：
- 每日記錄（DailyLog）同步到 Firestore
- 用戶設定（UserProfile）同步到 Firestore
- 衝突處理：本地為主，雲端同步

---

### 第四步：條碼掃描 Camera 權限設定

#### Android
在 `android/app/src/main/AndroidManifest.xml` 確認有：
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

#### iOS
在 `ios/Runner/Info.plist` 確認有：
```xml
<key>NSCameraUsageDescription</key>
<string>食刻輕卡需要使用相機掃描食品條碼</string>
```

---

### 第五步：體重追蹤功能

在 `features/weight/` 新增：
- `weight_page.dart`：體重記錄輸入
- `weight_chart.dart`：體重曲線圖（fl_chart LineChart）

---

## 🔧 技術決策記錄（Hermes 埋的細節）

### 為什麼用 Riverpod 不是 Provider/Bloc？
- 程式碼簡潔，適合中小型 App
- 測試友善
- 若你想換 Bloc也可以，但需要重寫 providers/

### Open Food Facts API 限制
- 無法取得中文食品時， fallback 到英文
- 條碼查詢建議加本地快取，避免重複網路請求
- 未來可串接：衛生福利部國民健康署「國人膳食營養素參考攝取量」

### BMR 公式（Mifflin-St Jeor）
```
男：BMR = 10×體重(kg) + 6.25×身高(cm) - 5×年齡 + 5
女：BMR = 10×體重(kg) + 6.25×身高(cm) - 5×年齡 - 161
```
（已在 `core/constants/app_constants.dart`）

### 營養素熱量係數
```
碳水：4 kcal/g
蛋白質：4 kcal/g
脂肪：9 kcal/g
```

---

## ✅ 已預先實作的 Firebase 程式碼

Hermes 已經幫你把 Firebase Auth 程式碼寫好了！你不需要從零開始。

### 已建立的檔案

| 檔案 | 用途 |
|------|------|
| `lib/data/services/auth_service.dart` | Firebase 認證（Google/Email 登入） |
| `lib/data/services/firestore_service.dart` | Firestore 雲端同步 |
| `lib/features/auth/login_page.dart` | 登入頁面 UI |

### 你需要做的

只需要完成以下 3 步，系統就能運作：

**Step 1：取消 pubspec.yaml 註解（Andy 給 Firebase 設定檔後）**

Andy 需要提供 Firebase 設定檔，然後在 `pubspec.yaml` 取消註解：
```yaml
firebase_core: ^3.13.0
firebase_auth: ^5.6.0
cloud_firestore: ^5.6.6
google_sign_in: ^6.2.1
```

**Step 2：放置設定檔**
- Andy 把 `google-services.json` 放到 `android/app/google-services.json`
- Andy 把 `GoogleService-Info.plist` 放到 `ios/Runner/GoogleService-Info.plist`

**Step 3：初始化 Firebase（在 main.dart）**

在 `lib/main.dart` 的 `main()` 函式最前面加入：
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // ← 加這行
  // ... 其餘程式碼不變
}
```

---

## ⚠️ 容易踩的坑

### 坑 1：Firebase Auth 在 iOS 模擬器有限制
Google Sign-In 在 iOS 模擬器可能無法運作（需要真機或 Firebase Emulator）

### 坑 2：Flutter SDK 版本衝突
`pubspec.lock` 已鎖定依賴版本。若你的 Flutter SDK 不同，可能需要 `flutter pub upgrade`

### 坑 3：Open Food Facts API 慢
建議加 HTTP 快取（cache：http_cache、dio_cache_interceptor）
目前實作無快取，搜尋會即時打 API

### 坑 4：條碼掃描在 Android 需要 Gradle 設定
`mobile_scanner` 需要 Android Gradle 7.0+，檢查 `android/build.gradle`：
```groovy
classpath 'com.android.tools.build:gradle:7.4.2'  // 或更新
```

### 坑 5：fl_chart 型別問題
`_WeeklyCalorieChart` 傳入的 `weekLogs` 是 `Map<String, dynamic>`，
轉成 `DailyLog` 請用 `DailyLog.fromJson(Map<String, dynamic>)`

---

## 📁 程式碼對照表

| 你要找的東西 | 檔案位置 |
|------------|---------|
| 主題色彩 | `lib/core/theme/app_theme.dart` |
| 使用者資料模型 | `lib/core/constants/app_constants.dart`（`UserProfile`） |
| 食物模型 | `lib/data/models/food_item.dart` |
| 每日記錄模型 | `lib/data/models/daily_log.dart` |
| 餐次記錄模型 | `lib/data/models/meal_record.dart` |
| API 服務 | `lib/data/services/open_food_facts_service.dart` |
| 本地存儲 | `lib/data/services/local_storage_service.dart` |
| 狀態管理 | `lib/providers/app_providers.dart` |
| 首頁 | `lib/features/home/home_page.dart` |
| 搜尋頁 | `lib/features/search/search_page.dart` |
| 條碼掃描 | `lib/features/barcode/barcode_scanner_page.dart` |
| 設定頁 | `lib/features/profile/profile_page.dart` |
| 圖表頁 | `lib/features/charts/charts_page.dart` |
| 進入點 | `lib/main.dart` |

---

## 📞 與 Hermes 溝通

有任何問題，在 Telegram 找 **@pengAndy**（Andy），讓他轉告 Hermes。

或直接問 Andy：「Hermes 那個設定/架構的問題」

Hermes 會回來處理。

---

## ✅ 驗收標準（完成 Phase 2 的指標）

- [ ] 使用者可以用 Google 帳號登入
- [ ] 使用者可以用 Email/密碼註冊並登入
- [ ] 登入後，資料在關閉 App 重開仍然存在（Firestore 同步正常）
- [ ] 體重記錄頁面可以輸入並顯示歷史曲線
- [ ] `flutter analyze` 0 errors
- [ ] Debug APK 可以成功編譯（`flutter build apk --debug`）
