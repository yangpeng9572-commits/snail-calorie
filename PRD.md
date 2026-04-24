# 食刻輕卡 (SnailCalorie) — 產品規格書

> **文件版本：** 1.0.0
> **最後更新：** 2026-04-24
> **狀態：** MVP 已完成（可直接交接给小龍女）

---

## 1. 產品願景

**產品名稱：** 食刻輕卡
**定位：** 輕鬆記錄飲食、管理熱量的健康生活助手
**核心價值：** 3 秒記錄一餐、視覺化營養攝入、幫助用戶達成減脂/維持/增重目標
**目標用戶：** 想控制體重但不想複雜計算的一般大眾

---

## 2. 技術架構

### 技術堆疊

| 層面 | 技術 |
|------|------|
| 框架 | Flutter 3.24.0 |
| 語言 | Dart 3.5.0 |
| 狀態管理 | Riverpod 2.6.1 |
| API | Open Food Facts API（免費，無需 Key） |
| 本地存儲 | SharedPreferences + JSON |
| 圖表 | fl_chart 0.68.0 |
| 條碼掃描 | mobile_scanner 5.2.3 |
| 條碼資料 | Open Food Facts 資料庫 |
| 未來可加 | Firebase Auth（雲端會員）、TensorFlow Lite（AI 食物辨識）|

### 專案結構

```
snail/
├── lib/
│   ├── main.dart                          # 進入點
│   ├── core/
│   │   ├── constants/app_constants.dart   # 常數、UserProfile、NutritionTarget 模型
│   │   ├── theme/app_theme.dart           # 主題色彩（Material Design）
│   │   └── utils/date_utils.dart          # 日期工具
│   ├── data/
│   │   ├── models/
│   │   │   ├── food_item.dart             # 食物資料模型
│   │   │   ├── meal_record.dart           # 餐次與單筆記錄模型
│   │   │   └── daily_log.dart             # 單日日誌模型
│   │   └── services/
│   │       ├── open_food_facts_service.dart  # API 服務
│   │       └── local_storage_service.dart     # 本地存儲服務
│   ├── providers/
│   │   └── app_providers.dart             # Riverpod 狀態管理
│   └── features/
│       ├── home/home_page.dart            # 首頁儀表板
│       ├── search/search_page.dart         # 食物搜尋
│       ├── barcode/barcode_scanner_page.dart  # 條碼掃描
│       ├── charts/charts_page.dart         # 每週分析圖表
│       └── profile/profile_page.dart       # 個人設定
└── pubspec.yaml
```

---

## 3. 功能模組（已實作）

### 3.1 首頁儀表板 ✅
- **日期選擇列：** 可查看過去 7 天的記錄
- **熱量卡片：** 顯示今日攝入 / 目標，達成率圓環圖
- **三大營養素卡片：** 碳水、蛋白質、脂肪，各有進度條
- **餐次列表：** 早餐 / 午餐 / 晚餐 / 點心，可展開查看每筆食物
- **快速新增按鈕：** FAB 跳轉搜尋頁

### 3.2 食物搜尋 ✅
- **搜尋框：** 即時搜尋（>= 2 字才觸發）
- **資料來源：** Open Food Facts API（全球最大開放食品資料庫）
- **搜尋結果：** 顯示食物名稱、品牌、熱量、圖片
- **新增流程：** 點擊食物 → 選擇份量（滑桿 10~500g）→ 選擇加入哪一餐
- **收藏功能：** 我的收藏（本地），可隨時快速添加常用食物

### 3.3 條碼掃描 ✅
- **相機掃描：** 使用 mobile_scanner 套件
- **條碼對應：** 查詢 Open Food Facts 資料庫
- **找到食品：** 顯示營養素，直接選擇加入哪一餐
- **找不到時：** 提示用戶手動搜尋，1.5 秒後恢復掃描

### 3.4 熱量目標設定 ✅
- **個人資料輸入：** 姓名、年齡、性別、身高、體重
- **活動量選擇：** 5 級（久坐 → 極度運動）
- **目標設定：** 減重 / 維持 / 增重
- **BMR 計算：** 使用 Mifflin-St Jeor 公式
- **自動建議：** 根據目標自動給予熱量缺口（減重 -500kcal、增重 +300kcal）
- **營養素分配：** 預設 50% 碳水 / 20% 蛋白質 / 30% 脂肪
- **自訂調整：** 用戶可自行修改各營養素目標

### 3.5 每週分析圖表 ✅
- **柱狀圖：** 本週每日熱量與目標線對比
- **圓餅圖：** 本週營養素攝入比例（碳水/蛋白質/脂肪）
- **每日卡片：** 每日達成率，還差 / 超過多少 kcal

### 3.6 個人設定頁面 ✅
- 基本資料編輯（姓名、年齡、身高、體重）
- 性別切換（男 / 女）
- 減重目標切換
- 活動量選擇（5 級）
- 即時預覽計算後的每日目標

---

## 4. 尚未實作（Phase 2）

以下功能在 MVP 中預留了位置，但尚未實作：

| 功能 | 說明 | 建議技術 |
|------|------|----------|
| Firebase 會員系統 | Google / Email 登入、雲端同步 | Firebase Auth + Firestore |
| 體重記錄追蹤 | 每日體重曲線、里程碑系統 | fl_chart 曲線圖 |
| 餐點照片日記 | 拍照記錄飲食 | image_picker |
| AI 食物辨識 | 拍照自動估算食物與份量 | TensorFlow Lite / Google ML Kit |
| 通知提醒 | 吃飯提醒、喝水提醒 | flutter_local_notifications |
| 資料匯出 | 匯出 CSV / PDF 報告 | csv + pdf 套件 |

---

## 5. Open Food Facts API 文件

### 搜尋食物
```
GET https://world.openfoodfacts.org/cgi/search.pl
  ?search_terms={關鍵字}
  &search_simple=1
  &action=process
  &json=1
  &page_size=20
  &fields=code,product_name,product_name_tw,brands,nutriments,serving_size,image_small_url
```

### 以條碼查詢
```
GET https://world.openfoodfacts.org/api/v0/product/{barcode}.json
```

### 回應格式
```json
{
  "product": {
    "code": "4710018001021",
    "product_name": "原味拿鐵咖啡",
    "product_name_tw": "原味拿鐵咖啡",
    "brands": "星巴克",
    "nutriments": {
      "energy-kcal_100g": 45.0,
      "carbohydrates_100g": 5.2,
      "proteins_100g": 1.3,
      "fat_100g": 1.8
    },
    "serving_size": "100ml",
    "image_small_url": "https://...jpg"
  }
}
```

---

## 6. 營養計算公式

### 基礎代謝率（BMR）— Mifflin-St Jeor
```
男性: BMR = 10 × 體重(kg) + 6.25 × 身高(cm) - 5 × 年齡 + 5
女性: BMR = 10 × 體重(kg) + 6.25 × 身高(cm) - 5 × 年齡 - 161
```

### 每日總消耗（TDEE）
```
TDEE = BMR × 活動係數
```
活動係數：久坐 1.2 / 輕度 1.375 / 中度 1.55 / 高度 1.725 / 極度 1.9

### 熱量目標
```
減重: TDEE - 500 kcal
維持: TDEE
增重: TDEE + 300 kcal
```

---

## 7. 營養素熱量係數

| 營養素 | kcal/g |
|--------|-------|
| 碳水化合物 | 4 |
| 蛋白質 | 4 |
| 脂肪 | 9 |

---

## 8. 色彩系統

```dart
primaryColor:     #4CAF50  // 健康綠（主色）
secondaryColor:   #00BCD4  // 活力藍綠
accentColor:      #FF9800  // 熱情橙
errorColor:       #E53935  // 警示紅
calorieColor:     #FF7043  // 熱量橙紅
carbsColor:       #42A5F5  // 碳水藍
proteinColor:     #66BB6A  // 蛋白質綠
fatColor:         #FFCA28  // 脂肪黃
backgroundColor:  #F5F5F5  // 背景灰
```

---

## 9. 啟動與執行

### 前置需求
- Flutter SDK 3.24.0+（Linux/Windows/Mac）
- Android SDK（Android 版編譯用）
- Xcode（iOS 版編譯用，限 Mac）

### 本機執行
```bash
cd snail
flutter pub get
flutter run          # 預設 Android 模擬器
flutter run -d chrome  # Chrome 網頁版
```

### Web 編譯
```bash
flutter build web
# 輸出: build/web/
```

### Debug APK 編譯
```bash
flutter build apk --debug
# 輸出: build/app/outputs/flutter-apk/app-debug.apk
```

---

## 10. 小龍女交接重點

### 立即可以測試的部分
1. **首頁儀表板** — 完全可運作，資料存在本地
2. **食物搜尋** — 串接真實 API，需網路
3. **條碼掃描** — Camera 權限需要設定
4. **個人設定** — BMR 計算邏輯完整

### 需要處理的部分
1. **Android 編譯** — Andy 的 Windows 上有 Flutter，需設定 ANDROID_HOME
2. **iOS 編譯** — 需要 Mac + Xcode
3. **Firebase 整合** — Phase 2 的雲端同步功能
4. **Google Play / App Store 上架** — 需要各自平台的開發者帳號

### 已預留的擴充點
- Firebase Auth 在 `pubspec.yaml` 已有註解（需取消註解並設定）
- AI 食物辨識在 `pubspec.yaml` 預留了 TensorFlow Lite
- 通知功能在 `pubspec.yaml` 預留了 `flutter_local_notifications`

---

## 11. 已知限制

1. **食物資料庫準確性** — Open Food Facts 為用戶貢獻資料，部分資料未經專業驗證（FatSecret 也有同樣問題）
2. **條碼掃描速度** — 依賴網路下載食品資料，離線無法使用
3. **AI 食物辨識** — Phase 2 才會實作，目前只有手動記錄
4. **台灣本地食物** — Open Food Facts 台灣資料較少，可考慮串接衛生福利部國民健康署的開放資料
