// Library: 本地 SharedPreferences 同步服務
//
// 目前實作：本地 SharedPreferences 模式（完全可正常使用）
// Firebase 設定後替換為 firebase_pending/firestore_service.dart
//
// 切換方式：
// 1. 取消 pubspec.yaml 的 cloud_firestore 註解
// 2. 放 google-services.json 和 GoogleService-Info.plist
// 3. 把本檔案替換為 firebase_pending/firestore_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';

// Library: 本地 SharedPreferences 同步服務

/// Firestore 服務 Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  throw UnimplementedError('FirestoreService must be overridden at startup');
});

class FirestoreService {
  static const String _keyDailyLogs = 'fs_daily_logs';
  static const String _keyFavorites = 'fs_favorites';
  static const String _keyWeightRecords = 'fs_weight_records';

  final SharedPreferences _prefs;

  FirestoreService(this._prefs);

  static Future<FirestoreService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return FirestoreService(prefs);
  }

  bool get isLoggedIn {
    // 檢查 SharedPreferences 中是否有登入狀態標記
    return _prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> saveDailyLog(DailyLog log) async {
    final logs = _getDailyLogsMap();
    logs[log.date] = log.toJson();
    await _prefs.setString(_keyDailyLogs, json.encode(logs));
  }

  Future<DailyLog?> getDailyLog(String date) async {
    final logs = _getDailyLogsMap();
    final data = logs[date];
    if (data == null) return null;
    return DailyLog.fromJson(data);
  }

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

  Future<void> saveFavoriteFoods(List<FoodItem> foods) async {
    final list = foods.map((f) => f.toJson()).toList();
    await _prefs.setString(_keyFavorites, json.encode(list));
  }

  Future<List<FoodItem>> getFavoriteFoods() async {
    final str = _prefs.getString(_keyFavorites);
    if (str == null) return [];
    final list = json.decode(str) as List;
    return list.map((e) => FoodItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveWeightRecord(String date, double weight) async {
    final records = _getWeightRecords();
    records[date] = {'date': date, 'weight': weight, 'timestamp': DateTime.now().toIso8601String()};
    await _prefs.setString(_keyWeightRecords, json.encode(records));
  }

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

  Future<DailyLog> mergeDailyLog(String date, DailyLog localLog) async {
    await saveDailyLog(localLog);
    return localLog;
  }
}
