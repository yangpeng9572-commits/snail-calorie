import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/app_providers.dart';

/// 本地存儲服務（使用 SharedPreferences + JSON）
class LocalStorageService {
  static const String _keyUserProfile = 'user_profile';
  static const String _keyNutritionTarget = 'nutrition_target';
  static const String _keyDailyLogPrefix = 'daily_log_';
  static const String _keyFavoriteFoods = 'favorite_foods';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// 建立實例（async 工廠）
  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // ==================== 用戶資料 ====================

  /// 儲存用戶資料
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(_keyUserProfile, json.encode(profile));
  }

  /// 讀取用戶資料
  Map<String, dynamic>? getUserProfile() {
    final str = _prefs.getString(_keyUserProfile);
    if (str == null) return null;
    return json.decode(str) as Map<String, dynamic>;
  }

  // ==================== 營養目標 ====================

  /// 儲存營養目標
  Future<void> saveNutritionTarget(Map<String, dynamic> target) async {
    await _prefs.setString(_keyNutritionTarget, json.encode(target));
  }

  /// 讀取營養目標
  Map<String, dynamic>? getNutritionTarget() {
    final str = _prefs.getString(_keyNutritionTarget);
    if (str == null) return null;
    return json.decode(str) as Map<String, dynamic>;
  }

  // ==================== 每日日誌 ====================

  /// 儲存單日日誌
  Future<void> saveDailyLog(DailyLog log) async {
    final key = '$_keyDailyLogPrefix${log.date}';
    await _prefs.setString(key, json.encode(log.toJson()));
  }

  /// 讀取單日日誌
  DailyLog? getDailyLog(String date) {
    final key = '$_keyDailyLogPrefix$date';
    final str = _prefs.getString(key);
    if (str == null) return null;
    return DailyLog.fromJson(json.decode(str) as Map<String, dynamic>);
  }

  /// 讀取今日日誌
  DailyLog getTodayLog() {
    return getDailyLog(AppDateUtils.todayString()) ?? DailyLog.today();
  }

  /// 儲存今日日誌
  Future<void> saveTodayLog(DailyLog log) => saveDailyLog(log);

  /// 取得本週所有日誌
  Map<String, DailyLog> getWeekLogs() {
    final today = DateTime.now();
    final monday = AppDateUtils.weekStart(today);
    final logs = <String, DailyLog>{};

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      logs[dateStr] = getDailyLog(dateStr) ?? DailyLog.empty(dateStr);
    }

    return logs;
  }

  // ==================== 收藏食物 ====================

  /// 儲存收藏食物
  Future<void> saveFavoriteFoods(List<FoodItem> foods) async {
    final list = foods.map((f) => f.toJson()).toList();
    await _prefs.setString(_keyFavoriteFoods, json.encode(list));
  }

  /// 讀取收藏食物
  List<FoodItem> getFavoriteFoods() {
    final str = _prefs.getString(_keyFavoriteFoods);
    if (str == null) return [];
    final list = json.decode(str) as List;
    return list.map((e) => FoodItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 加入收藏
  Future<void> addFavoriteFood(FoodItem food) async {
    final favorites = getFavoriteFoods();
    if (!favorites.any((f) => f.id == food.id)) {
      favorites.insert(0, food);
      await saveFavoriteFoods(favorites);
    }
  }

  /// 移除收藏
  Future<void> removeFavoriteFood(String foodId) async {
    final favorites = getFavoriteFoods();
    favorites.removeWhere((f) => f.id == foodId);
    await saveFavoriteFoods(favorites);
  }

  // ==================== 清除所有資料 ====================

  /// 儲存通知設定
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    await _prefs.setString(_keyNotificationSettings, json.encode({
      'breakfastEnabled': settings.breakfastEnabled,
      'lunchEnabled': settings.lunchEnabled,
      'dinnerEnabled': settings.dinnerEnabled,
    }));
  }

  /// 讀取通知設定
  NotificationSettings getNotificationSettings() {
    final str = _prefs.getString(_keyNotificationSettings);
    if (str == null) return const NotificationSettings();
    final map = json.decode(str) as Map<String, dynamic>;
    return NotificationSettings(
      breakfastEnabled: map['breakfastEnabled'] as bool? ?? false,
      lunchEnabled: map['lunchEnabled'] as bool? ?? false,
      dinnerEnabled: map['dinnerEnabled'] as bool? ?? false,
    );
  }

  static const String _keyNotificationSettings = 'notification_settings';

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
