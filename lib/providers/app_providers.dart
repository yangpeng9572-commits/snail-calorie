import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/open_food_facts_service.dart';
import '../data/services/food_search_service.dart';
import '../data/services/firestore_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/exercise_service.dart';
import '../data/models/meal_record.dart';
import '../data/models/food_item.dart';
import '../data/models/daily_log.dart';
import '../data/models/exercise_entry.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';

// ==================== 地區設定 Provider ====================

/// 地區語言 Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  final storage = ref.watch(localStorageProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<String> {
  final LocalStorageService _storage;

  LocaleNotifier(this._storage) : super('zh') {
    _load();
  }

  void _load() {
    state = _storage.getLocale();
  }

  Future<void> setLocale(String code) async {
    state = code;
    await _storage.saveLocale(code);
  }
}

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

/// 合併食物搜尋服務（本地資料庫 + API）
final foodSearchServiceProvider = Provider<FoodSearchService>((ref) {
  final apiService = ref.watch(openFoodFactsServiceProvider);
  return FoodSearchService(apiService: apiService);
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

    try {
      final food = await _service.getFoodByBarcode(barcode);

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
    } catch (e) {
      state = state.copyWith(
        status: BarcodeScanStatus.notFound,
        errorMessage: '網路錯誤，請檢查連線後重試',
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
    try {
      final log = _storage.getDailyLog(AppDateUtils.formatDate(_date));
      if (log != null) state = log;
    } catch (_) {
      // 資料損壞時使用空白日誌，不影響 App 啟動
    }
  }

  Future<void> addEntry(String mealType, FoodItem food, double grams) async {
    final meal = state.getMeal(mealType);
    final entry = MealEntry(food: food, grams: grams);
    final updatedMeal = meal.addEntry(entry);
    state = state.updateMeal(updatedMeal);
    await _storage.saveDailyLog(state);
  }

  Future<void> addEntryWithPhoto(String mealType, FoodItem food, double grams, String photoPath) async {
    final meal = state.getMeal(mealType);
    final entry = MealEntry(food: food, grams: grams, photoPath: photoPath);
    final updatedMeal = meal.addEntry(entry);
    state = state.updateMeal(updatedMeal);
    await _storage.saveDailyLog(state);
  }

  Future<void> updateEntryPhoto(String mealType, String entryId, String photoPath) async {
    final meal = state.getMeal(mealType);
    final updatedEntries = meal.entries.map((e) {
      if (e.id == entryId) {
        return e.copyWith(photoPath: photoPath);
      }
      return e;
    }).toList();
    final updatedMeal = MealRecord(type: mealType, entries: updatedEntries);
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
    state = DailyLog(date: state.date, meals: state.meals, weight: weight, exercises: state.exercises);
    await _storage.saveDailyLog(state);
  }

  /// 新增運動記錄
  Future<void> addExercise(ExerciseEntry exercise) async {
    state = state.addExercise(exercise);
    await _storage.saveDailyLog(state);
  }

  /// 移除運動記錄
  Future<void> removeExercise(String exerciseId) async {
    state = state.removeExercise(exerciseId);
    await _storage.saveDailyLog(state);
  }
}

// ==================== 食物搜尋 Providers ====================

/// 搜尋關鍵字
final searchQueryProvider = StateProvider<String>((ref) => '');

/// 搜尋結果（本地 + API 合併）
final searchResultsProvider = FutureProvider<List<FoodItem>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return [];

  final service = ref.read(foodSearchServiceProvider);
  final result = await service.searchFoods(query);
  return result.all;
});

/// 搜尋結果（詳細拆分 - 本地/ API 分開顯示）
final searchDetailProvider = FutureProvider<FoodSearchResult>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return FoodSearchResult.empty();

  final service = ref.read(foodSearchServiceProvider);
  return service.searchFoods(query);
});

/// 搜尋歷史 Provider
final searchHistoryProvider = Provider<List<String>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getSearchHistory();
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
  final bool snackEnabled;
  final int breakfastHour;
  final int breakfastMinute;
  final int lunchHour;
  final int lunchMinute;
  final int dinnerHour;
  final int dinnerMinute;
  final int snackHour;
  final int snackMinute;

  const NotificationSettings({
    this.breakfastEnabled = false,
    this.lunchEnabled = false,
    this.dinnerEnabled = false,
    this.snackEnabled = false,
    this.breakfastHour = 8,
    this.breakfastMinute = 0,
    this.lunchHour = 12,
    this.lunchMinute = 0,
    this.dinnerHour = 18,
    this.dinnerMinute = 0,
    this.snackHour = 20,
    this.snackMinute = 0,
  });

  NotificationSettings copyWith({
    bool? breakfastEnabled,
    bool? lunchEnabled,
    bool? dinnerEnabled,
    bool? snackEnabled,
    int? breakfastHour,
    int? breakfastMinute,
    int? lunchHour,
    int? lunchMinute,
    int? dinnerHour,
    int? dinnerMinute,
    int? snackHour,
    int? snackMinute,
  }) {
    return NotificationSettings(
      breakfastEnabled: breakfastEnabled ?? this.breakfastEnabled,
      lunchEnabled: lunchEnabled ?? this.lunchEnabled,
      dinnerEnabled: dinnerEnabled ?? this.dinnerEnabled,
      snackEnabled: snackEnabled ?? this.snackEnabled,
      breakfastHour: breakfastHour ?? this.breakfastHour,
      breakfastMinute: breakfastMinute ?? this.breakfastMinute,
      lunchHour: lunchHour ?? this.lunchHour,
      lunchMinute: lunchMinute ?? this.lunchMinute,
      dinnerHour: dinnerHour ?? this.dinnerHour,
      dinnerMinute: dinnerMinute ?? this.dinnerMinute,
      snackHour: snackHour ?? this.snackHour,
      snackMinute: snackMinute ?? this.snackMinute,
    );
  }

  String formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get breakfastTimeStr => formatTime(breakfastHour, breakfastMinute);
  String get lunchTimeStr => formatTime(lunchHour, lunchMinute);
  String get dinnerTimeStr => formatTime(dinnerHour, dinnerMinute);
  String get snackTimeStr => formatTime(snackHour, snackMinute);
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

  Future<void> toggleSnack(bool enabled) async {
    state = state.copyWith(snackEnabled: enabled);
    await _saveAndSync();
  }

  Future<void> updateBreakfastTime(int hour, int minute) async {
    state = state.copyWith(breakfastHour: hour, breakfastMinute: minute);
    await _saveAndSync();
  }

  Future<void> updateLunchTime(int hour, int minute) async {
    state = state.copyWith(lunchHour: hour, lunchMinute: minute);
    await _saveAndSync();
  }

  Future<void> updateDinnerTime(int hour, int minute) async {
    state = state.copyWith(dinnerHour: hour, dinnerMinute: minute);
    await _saveAndSync();
  }

  Future<void> updateSnackTime(int hour, int minute) async {
    state = state.copyWith(snackHour: hour, snackMinute: minute);
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
        hour: state.breakfastHour,
        minute: state.breakfastMinute,
      );
    }

    if (state.lunchEnabled) {
      await notificationService.scheduleMealReminder(
        id: 2,
        title: '🥗 午餐時間到！',
        body: '該吃午餐了，注意營養均衡！',
        hour: state.lunchHour,
        minute: state.lunchMinute,
      );
    }

    if (state.dinnerEnabled) {
      await notificationService.scheduleMealReminder(
        id: 3,
        title: '🍽️ 晚餐時間到！',
        body: '晚餐時間到了，別忘了記錄！',
        hour: state.dinnerHour,
        minute: state.dinnerMinute,
      );
    }

    if (state.snackEnabled) {
      await notificationService.scheduleMealReminder(
        id: 4,
        title: '🍬 點心時間到！',
        body: '想吃點小零食嗎？注意熱量哦！',
        hour: state.snackHour,
        minute: state.snackMinute,
      );
    }
  }
}

// ==================== 運動記錄 Providers ====================

/// 運動服務 Provider
final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  // ExerciseService 需要 SharedPreferences，但 LocalStorageService 包裝了它
  // 這裡我們直接用 SharedPreferences
  throw UnimplementedError('ExerciseService must be overridden at startup');
});

/// 運動記錄列表 Provider
final exerciseLogProvider = StateNotifierProvider<ExerciseLogNotifier, List<ExerciseEntry>>((ref) {
  final service = ref.watch(exerciseServiceProvider);
  return ExerciseLogNotifier(service);
});

class ExerciseLogNotifier extends StateNotifier<List<ExerciseEntry>> {
  final ExerciseService _service;

  ExerciseLogNotifier(this._service) : super([]);

  Future<void> loadExercises(String date) async {
    final entries = await _service.getExercisesByDate(date);
    state = entries;
  }

  Future<void> addEntry(ExerciseEntry entry) async {
    await _service.saveExercise(entry);
    // 重新載入以確保狀態同步
    final entries = await _service.getExercisesByDate(entry.date);
    state = entries;
  }

  Future<void> removeEntry(String entryId) async {
    // 找到條目以獲取日期
    final entry = state.firstWhere((e) => e.id == entryId, orElse: () => throw Exception('Entry not found'));
    await _service.deleteExercise(entry.date, entryId);
    // 重新載入
    final entries = await _service.getExercisesByDate(entry.date);
    state = entries;
  }
}
