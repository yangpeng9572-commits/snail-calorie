import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/open_food_facts_service.dart';
import '../data/models/meal_record.dart';
import '../data/models/food_item.dart';
import '../data/models/daily_log.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';

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
