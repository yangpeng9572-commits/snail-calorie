import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/open_food_facts_service.dart';
import '../data/services/firestore_service.dart';
import '../data/services/notification_service.dart';
import '../data/models/meal_record.dart';
import '../data/models/food_item.dart';
import '../data/models/daily_log.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';

// ==================== 主題設定 Provider ====================

/// 主題模式 Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final storage = ref.watch(localStorageProvider);
  return ThemeModeNotifier(storage);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageService _storage;

  ThemeModeNotifier(this._storage) : super(ThemeMode.system) {
    _load();
  }

  void _load() {
    final savedTheme = _storage.getThemeMode();
    state = savedTheme;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode);
  }

  Future<void> toggleDarkMode() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

// ==================== 認證狀態 Provider ====================

/// 認證狀態 Provider（Guest 模式視為已登入，default = true）
final authStateProvider = StateProvider<bool>((ref) => true);

// ==================== 服務 Providers ====================

/// 本地存儲服務（全域單例）
final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('LocalStorageService must be overridden at startup');
});

/// Open Food Facts API 服務
final openFoodFactsServiceProvider = Provider<OpenFoodFactsService>((ref) {
  return OpenFoodFactsService();
});

// ==================== 條碼掃描 Providers ====================

/// 條碼掃描狀態
enum BarcodeScanStatus { idle, scanning, found, notFound }

class BarcodeScanState {
  final BarcodeScanStatus status;
  final String? lastBarcode;
  final FoodItem? foundFood;
  final String? errorMessage;

  const BarcodeScanState({
    this.status = BarcodeScanStatus.idle,
    this.lastBarcode,
    this.foundFood,
    this.errorMessage,
  });

  BarcodeScanState copyWith({
    BarcodeScanStatus? status,
    String? lastBarcode,
    FoodItem? foundFood,
    String? errorMessage,
  }) {
    return BarcodeScanState(
      status: status ?? this.status,
      lastBarcode: lastBarcode ?? this.lastBarcode,
      foundFood: foundFood ?? this.foundFood,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// 條碼掃描 Provider
final barcodeScannerProvider = StateNotifierProvider<BarcodeScannerNotifier, BarcodeScanState>((ref) {
  final service = ref.watch(openFoodFactsServiceProvider);
  return BarcodeScannerNotifier(service);
});

class BarcodeScannerNotifier extends StateNotifier<BarcodeScanState> {
  final OpenFoodFactsService _service;

  BarcodeScannerNotifier(this._service) : super(const BarcodeScanState());

  Future<void> scanBarcode(String barcode) async {
    if (barcode.isEmpty) return;
    if (barcode == state.lastBarcode && state.status == BarcodeScanStatus.found) return;

    state = state.copyWith(
      status: BarcodeScanStatus.scanning,
      lastBarcode: barcode,
    );

    final food = await _service.getFoodByBarcode(barcode);

    if (!mounted) return;

    if (food != null) {
      state = state.copyWith(
        status: BarcodeScanStatus.found,
        foundFood: food,
      );
    } else {
      state = state.copyWith(
        status: BarcodeScanStatus.notFound,
        errorMessage: '找不到條碼 $barcode 對應的食品',
      );
    }
  }

  void reset() {
    state = const BarcodeScanState();
  }
}

// ==================== 用戶資料 Providers ====================

/// 用戶資料
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final storage = ref.watch(localStorageProvider);
  return UserProfileNotifier(storage);
});

class UserProfileState {
  final UserProfile? profile;
  final NutritionTarget target;

  UserProfileState({this.profile, NutritionTarget? target})
      : target = target ?? NutritionTarget.defaultTarget();

  UserProfileState copyWith({UserProfile? profile, NutritionTarget? target}) {
    return UserProfileState(
      profile: profile ?? this.profile,
      target: target ?? this.target,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final LocalStorageService _storage;

  UserProfileNotifier(this._storage) : super(UserProfileState()) {
    _load();
  }

  void _load() {
    final profileJson = _storage.getUserProfile();
    final targetJson = _storage.getNutritionTarget();

    UserProfile? profile;
    if (profileJson != null) {
      profile = UserProfile.fromJson(profileJson);
    }

    NutritionTarget target;
    if (targetJson != null) {
      target = NutritionTarget.fromJson(targetJson);
    } else if (profile != null) {
      target = profile.nutritionTarget;
    } else {
      target = NutritionTarget.defaultTarget();
    }

    state = UserProfileState(profile: profile, target: target);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _storage.saveUserProfile(profile.toJson());
    state = state.copyWith(profile: profile, target: profile.nutritionTarget);
  }

  Future<void> updateTarget(NutritionTarget target) async {
    await _storage.saveNutritionTarget(target.toJson());
    state = state.copyWith(target: target);
  }
}

// ==================== 每日日誌 Providers ====================

/// 選擇的日期
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 當日日誌
final dailyLogProvider = StateNotifierProvider<DailyLogNotifier, DailyLog>((ref) {
  final storage = ref.watch(localStorageProvider);
  final date = ref.watch(selectedDateProvider);
  return DailyLogNotifier(storage, date);
});

class DailyLogNotifier extends StateNotifier<DailyLog> {
  final LocalStorageService _storage;
  final DateTime _date;

  DailyLogNotifier(this._storage, this._date) : super(DailyLog.empty(AppDateUtils.formatDate(_date))) {
    _load();
  }

  void _load() {
    final log = _storage.getDailyLog(AppDateUtils.formatDate(_date));
    if (log != null) state = log;
  }

  Future<void> addEntry(String mealType, FoodItem food, double grams) async {
    final meal = state.getMeal(mealType);
    final entry = MealEntry(food: food, grams: grams);
    final updatedMeal = meal.addEntry(entry);
    state = state.updateMeal(updatedMeal);
    await _storage.saveDailyLog(state);
  }

  Future<void> removeEntry(String mealType, String entryId) async {
    final meal = state.getMeal(mealType);
    final updatedMeal = meal.removeEntry(entryId);
    state = state.updateMeal(updatedMeal);
    await _storage.saveDailyLog(state);
  }

  Future<void> updateWeight(double weight) async {
    state = DailyLog(date: state.date, meals: state.meals, weight: weight);
    await _storage.saveDailyLog(state);
  }
}

// ==================== 食物搜尋 Providers ====================

/// 搜尋關鍵字
final searchQueryProvider = StateProvider<String>((ref) => '');

/// 搜尋結果
final searchResultsProvider = FutureProvider<List<FoodItem>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return [];

  final service = ref.read(openFoodFactsServiceProvider);
  return service.searchFoods(query);
});

// ==================== 收藏食物 Providers ====================

final favoriteFoodsProvider = StateNotifierProvider<FavoriteFoodsNotifier, List<FoodItem>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return FavoriteFoodsNotifier(storage);
});

class FavoriteFoodsNotifier extends StateNotifier<List<FoodItem>> {
  final LocalStorageService _storage;

  FavoriteFoodsNotifier(this._storage) : super([]) {
    _load();
  }

  void _load() {
    state = _storage.getFavoriteFoods();
  }

  Future<void> toggleFavorite(FoodItem food) async {
    final isFavorite = state.any((f) => f.id == food.id);
    if (isFavorite) {
      await _storage.removeFavoriteFood(food.id);
      state = state.where((f) => f.id != food.id).toList();
    } else {
      await _storage.addFavoriteFood(food);
      state = [food, ...state];
    }
  }

  bool isFavorite(String foodId) => state.any((f) => f.id == foodId);
}

// ==================== 本週數據 Providers ====================

final weekLogsProvider = Provider<Map<String, DailyLog>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getWeekLogs();
});

// ==================== 體重追蹤 Providers ====================

/// 體重記錄 Provider
final weightRecordsProvider = StateNotifierProvider<WeightRecordsNotifier, List<Map<String, dynamic>>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return WeightRecordsNotifier(firestore);
});

class WeightRecordsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final FirestoreService _firestore;

  WeightRecordsNotifier(this._firestore) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final records = await _firestore.getWeightHistory(days: 30);
    if (mounted) {
      state = records;
    }
  }

  Future<void> addWeight(DateTime date, double weight) async {
    final dateStr = AppDateUtils.formatDate(date);
    await _firestore.saveWeightRecord(dateStr, weight);
    await _load();
  }

  List<Map<String, dynamic>> getWeightHistory({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return state.where((r) {
      final timestamp = DateTime.parse(r['timestamp'] as String);
      return timestamp.isAfter(cutoff);
    }).toList()
      ..sort((a, b) => (a['timestamp'] as String).compareTo(b['timestamp'] as String));
  }

  Future<void> refresh() async {
    await _load();
  }
}

// ==================== 通知設定 Providers ====================

/// 通知服務單例
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// 通知設定狀態
class NotificationSettings {
  final bool breakfastEnabled;
  final bool lunchEnabled;
  final bool dinnerEnabled;

  const NotificationSettings({
    this.breakfastEnabled = false,
    this.lunchEnabled = false,
    this.dinnerEnabled = false,
  });

  NotificationSettings copyWith({
    bool? breakfastEnabled,
    bool? lunchEnabled,
    bool? dinnerEnabled,
  }) {
    return NotificationSettings(
      breakfastEnabled: breakfastEnabled ?? this.breakfastEnabled,
      lunchEnabled: lunchEnabled ?? this.lunchEnabled,
      dinnerEnabled: dinnerEnabled ?? this.dinnerEnabled,
    );
  }
}

/// 通知設定 Provider
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier(ref);
});

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final Ref _ref;

  NotificationSettingsNotifier(this._ref) : super(const NotificationSettings()) {
    _init();
  }

  Future<void> _init() async {
    final storage = _ref.read(localStorageProvider);
    final settings = storage.getNotificationSettings();
    state = settings;
    await _syncReminders();
  }

  Future<void> toggleBreakfast(bool enabled) async {
    state = state.copyWith(breakfastEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> toggleLunch(bool enabled) async {
    state = state.copyWith(lunchEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> toggleDinner(bool enabled) async {
    state = state.copyWith(dinnerEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> _saveAndSync() async {
    final storage = _ref.read(localStorageProvider);
    await storage.saveNotificationSettings(state);
    await _syncReminders();
  }

  Future<void> _syncReminders() async {
    final notificationService = _ref.read(notificationServiceProvider);

    // 取消所有現有提醒
    await notificationService.cancelAllReminders();

    // 根據設定重新排程
    if (state.breakfastEnabled) {
      await notificationService.scheduleMealReminder(
        id: 1,
        title: '🍳 早餐時間到！',
        body: '記得吃早餐，補充一天的活力！',
        hour: 8,
        minute: 0,
      );
    }

    if (state.lunchEnabled) {
      await notificationService.scheduleMealReminder(
        id: 2,
        title: '🥗 午餐時間到！',
        body: '該吃午餐了，注意營養均衡！',
        hour: 12,
        minute: 0,
      );
    }

    if (state.dinnerEnabled) {
      await notificationService.scheduleMealReminder(
        id: 3,
        title: '🍽️ 晚餐時間到！',
        body: '晚餐時間到了，別忘了記錄！',
        hour: 18,
        minute: 0,
      );
    }
  }
}
