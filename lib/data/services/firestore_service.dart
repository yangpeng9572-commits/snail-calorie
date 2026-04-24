// Library: 本地 SharedPreferences 同步服務
///
/// 目前實作：本地 SharedPreferences 模式（完全可正常使用）
/// Firebase 設定後，替換為 firebase_pending/firestore_service.dart
///
/// 切換方式：
/// 1. 取消 pubspec.yaml 的 cloud_firestore 註解
/// 2. 放 google-services.json 和 GoogleService-Info.plist
/// 3. 替換本檔案為 firebase_pending/firestore_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';

/// 本地 Firestore 模擬服務（使用 SharedPreferences）
/// 與真正的 FirestoreService API 完全相容，Firebase 設定後可無痛替換
class FirestoreService {
  static const String _keyDailyLogs = 'firestore_daily_logs';
  static const String _keyFavorites = 'firestore_favorites';
  static const String _keyWeightRecords = 'firestore_weight_records';

  final SharedPreferences _prefs;

  FirestoreService(this._prefs);

  /// 工廠方法（async 初始化）
  static Future<FirestoreService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return FirestoreService(prefs);
  }

  bool get isLoggedIn => true; // Guest 模式永遠視為已登入

  // ==================== 每日日誌同步 ====================

  /// 儲存單日日誌
  Future<void> saveDailyLog(DailyLog log) async {
    final logs = _getDailyLogsMap();
    logs[log.date] = log.toJson();
    await _prefs.setString(_keyDailyLogs, json.encode(logs));
  }

  /// 讀取單日日誌
  Future<DailyLog?> getDailyLog(String date) async {
    final logs = _getDailyLogsMap();
    final data = logs[date];
    if (data == null) return null;
    return DailyLog.fromJson(data);
  }

  /// 讀取多日日誌
  Future<Map<String, DailyLog>> getDailyLogs(List<String> dates) async {
    final logs = <String, DailyLog>{};
    for (final date in dates) {
      final log = await getDailyLog(date);
      if (log != null) logs[date] = log;
    }
    return logs;
  }

  Map<String, dynamic> _getDailyLogsMap() {
    final str = _prefs.getString(_keyDailyLogs);
    if (str == null) return {};
    return json.decode(str) as Map<String, dynamic>;
  }

  // ==================== 收藏食物同步 ====================

  /// 儲存收藏食物列表
  Future<void> saveFavoriteFoods(List<FoodItem> foods) async {
    final list = foods.map((f) => f.toJson()).toList();
    await _prefs.setString(_keyFavorites, json.encode(list));
  }

  /// 讀取收藏食物
  Future<List<FoodItem>> getFavoriteFoods() async {
    final str = _prefs.getString(_keyFavorites);
    if (str == null) return [];
    final list = json.decode(str) as List;
    return list.map((e) => FoodItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ==================== 體重歷史同步 ====================

  /// 儲存體重記錄
  Future<void> saveWeightRecord(String date, double weight) async {
    final records = _getWeightRecords();
    records[date] = {'date': date, 'weight': weight, 'timestamp': DateTime.now().toIso8601String()};
    await _prefs.setString(_keyWeightRecords, json.encode(records));
  }

  /// 讀取體重歷史（最近 N 天）
  Future<List<Map<String, dynamic>>> getWeightHistory({int days = 30}) async {
    final records = _getWeightRecords();
    final cutoff = DateTime.now().subtract(Duration(days: days));

    final filtered = records.entries
        .where((e) => DateTime.parse(e.value['timestamp'] as String).isAfter(cutoff))
        .map<Map<String, dynamic>>((e) => e.value as Map<String, dynamic>)
        .toList();

    filtered.sort((a, b) => (b['timestamp'] as String).compareTo(a['timestamp'] as String));
    return filtered;
  }

  Map<String, dynamic> _getWeightRecords() {
    final str = _prefs.getString(_keyWeightRecords);
    if (str == null) return {};
    return json.decode(str) as Map<String, dynamic>;
  }

  // ==================== 衝突處理 ====================

  /// 智能合併（本地模式：永遠保留本地，無衝突）
  Future<DailyLog> mergeDailyLog(String date, DailyLog localLog) async {
    // 本地模式：直接用本地資料
    await saveDailyLog(localLog);
    return localLog;
  }
}
