# 食刻輕卡 Phase 2 — 詳細工作任務

> 分配：Hermes（PM）→ 小龍女（開發者）
> 日期：2026-04-24

---

## 任務分配原則

- Hermes 負責：技術決策、架構設計、困難問題 Debug
- 小龍女負責：依任務清單實作、功能交付
- Andy 負責：提供 Firebase 設定檔、測試驗收
- 遇到問題：截圖貼給 Andy，轉 Hermes 分析

---

## 任務一：Firebase 會員系統

### 預估工時：3-4 小時

### Step 1：申請 Firebase 專案（由 Andy 操作）
Andy 需要做：
1. 前往 https://console.firebase.google.com/
2. 建立新專案「食刻輕卡」
3. 啟用「Authentication」→「Sign-in method」：
   - 啟用「Google」
   - 啟用「Email/密碼」
4. 建立 Firestore Database（測試模式）
5. 下載 `google-services.json` 和 `GoogleService-Info.plist`
6. 把檔案路徑告訴小龍女

### Step 2：設定 Flutter Firebase（由小龍女做）

在 `pubspec.yaml` 取消註解：
```yaml
firebase_core: ^3.13.0
firebase_auth: ^5.6.0
cloud_firestore: ^5.6.6
google_sign_in: ^6.2.1
```

然後執行：
```bash
flutter pub get
```

把 Andy 給的 `google-services.json` 放到 `android/app/google-services.json`
把 Andy 給的 `GoogleService-Info.plist` 放到 `ios/Runner/GoogleService-Info.plist`

### Step 3：實作登入頁面

新增：`lib/features/auth/login_page.dart`

功能需求：
- App 啟動時檢查是否已登入
- 已登入 → 進首頁
- 未登入 → 顯示登入頁

登入頁要有：
- 「以 Google 登入」按鈕
- 「以 Email 註冊」表單（Email + 密碼 + 確認密碼）
- 「以 Email 登入」表單（Email + 密碼）
- 忘記密碼連結

程式碼參考：
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async { ... }
  Future<User?> signInWithEmail(String email, String password) async { ... }
  Future<User?> registerWithEmail(String email, String password) async { ... }
  Future<void> sendPasswordReset(String email) async { ... }
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<void> signOut() async { ... }
}
```

### Step 4：串接 Firestore 雲端同步

修改 `LocalStorageService`，讓它同時寫入 Firestore：

新增 `lib/data/services/firestore_service.dart`

```dart
// 用戶資料 collection: users/{uid}/
//   - profile: Map (對應 UserProfile.toJson())
//   - dailyLogs: Map<date, Map> (對應 DailyLog.toJson())

// 同步邏輯：
// 1. 寫入本地後，異步寫入 Firestore
// 2. App 啟動時，從 Firestore 同步到本地
// 3. 衝突處理：取 Firestore 的更新时间戳 > 本地的为准
```

---

## 任務二：條碼掃描 Camera 權限

### 預估工時：1 小時

### Android（`android/app/src/main/AndroidManifest.xml`）
在 `<manifest>` 標籤內加入：
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

### iOS（`ios/Runner/Info.plist`）
在 `<dict>` 內加入：
```xml
<key>NSCameraUsageDescription</key>
<string>食刻輕卡需要使用相機掃描食品條碼</string>
```

---

## 任務三：體重追蹤功能

### 預估工時：3 小時

新增目錄：`lib/features/weight/`

### 3.1 體重記錄頁面（`weight_page.dart`）
- 輸入今日體重（數字鍵盤，單位 kg）
- 顯示最近 7 天體重列表
- 顯示目前體重 vs 目標體重

### 3.2 體重曲線圖（`weight_chart.dart`）
- fl_chart `LineChart` 元件
- X 軸：日期（過去 30 天）
- Y 軸：體重（kg）
- 目標體重參考線（虛線）

### 3.3 體重 Provider
在 `providers/app_providers.dart` 新增：
```dart
// weightHistoryProvider: List<WeightEntry>
// WeightEntry: { date: String, weight: double }
```

### 3.4 在首頁底部加「記錄體重」入口
在 `home_page.dart` 底部加一張體重捷徑卡片

---

## 任務四：收藏食物離線快取

### 預估工時：2 小時

目前收藏食物存在 SharedPreferences（JSON），可以接受。

但建議加 SQLite 快取搜尋結果，減少 API 請求：

```dart
// lib/data/services/food_cache_service.dart
// 使用 sqflite 快取 FoodItem
// 欄位：id, name, brand, calories, carbs, protein, fat, cached_at
// 過期時間：7 天
```

---

## 任務五：通知提醒（吃飯提醒）

### 預估工時：2-3 小時

新增套件：
```yaml
flutter_local_notifications: ^18.1.0
timezone: ^0.10.0
```

功能：
- 設定「吃飯提醒」時間（早餐 8:00、午餐 12:00、晚餐 18:00 可開關）
- 通知內容：「該記錄午餐了！今天已攝入 X kcal」

---

## 任務優先順序

```
P0（必須做）：
  1. Firebase 設定 + 會員登入（等待 Andy 提供 Firebase 設定檔）
  2. Camera 權限（Android + iOS）

P1（重要）：
  3. Firestore 雲端同步
  4. 體重追蹤功能

P2（可選，Phase 3）：
  5. 收藏食物快取優化
  6. 吃飯提醒通知
```

---

## 提交規範

每完成一個任務，commit 格式：
```
feat(task-name): 實作的功能

具體做了什麼變更
```

例如：
```
feat(firebase-auth): 實作 Google / Email 登入

- 新增 AuthService 處理 Firebase Authentication
- 新增 login_page.dart 登入介面
- 新增 auth_guard.dart 登入狀態守衛
- 串接 Firebase Auth 與 Firestore
```

---

## Debug 問題回報格式

遇到問題時，这样告诉 Andy：

```
任務：<任務名稱>
錯誤：<錯誤訊息全文>
截圖：<貼截圖>
已經試過：<你嘗試的解法>
```
