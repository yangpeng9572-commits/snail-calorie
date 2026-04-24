# 食刻輕卡 - Snail Calorie

一款專為追求健康生活者設計的卡路里追蹤 App，幫助你輕鬆記錄每日飲食。

## 功能特色

🍎 **飲食記錄** - 搜尋食物並記錄每餐營養攝入
📷 **條碼掃描** - 掃描食品包裝條碼，快速查詢營養資訊
📊 **熱量追蹤** - 每日熱量進度視覺化儀表板
💪 **營養素分析** - 蛋白質、碳水、脂肪詳細記錄
⚖️ **體重管理** - 記錄體重變化趨勢
🌙 **深色主題** - 保護眼睛的深色模式
🔔 **吃飯提醒** - 自訂提醒時間再也不忘記
📤 **資料匯出** - 支援 CSV/JSON 格式匯出
🌐 **多語言** - 繁體中文 / English

## 技術架構

- **Flutter 3.24.0** - 跨平台框架（iOS/Android/Web）
- **Riverpod** - 狀態管理
- **Open Food Facts API** - 食物營養資料庫（免費，無需 API Key）
- **Firebase** - 雲端同步（可選，需另行設定）
- **Google ML Kit** - 條碼掃描與文字辨識

## 快速開始

### 預設模式（无需 Firebase）

```bash
flutter pub get
flutter run
```

### Firebase 模式（需設定檔）

```bash
# 1. 建立 Firebase 專案並啟用 Auth 和 Firestore
# 2. 下載設定檔
bash scripts/activate_firebase.sh <google-services.json路徑> <GoogleService-Info.plist路徑>
flutter pub get
flutter run
```

## 目前進度

✅ MVP 功能完成
✅ Guest 模式（免登入直接使用）
✅ 條碼掃描
✅ 收藏功能
✅ 體重追蹤圖表
✅ 深色主題
✅ 多語言
✅ 首次使用引導
🔄 Firebase 雲端同步（待設定）

## License

MIT License
