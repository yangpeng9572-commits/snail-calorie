import 'meal_record.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import 'exercise_entry.dart';
import 'water_entry.dart';

/// 單日攝入日誌
class DailyLog {
  final String date; // 'yyyy-MM-dd'
  final Map<String, MealRecord> meals;
  final double? weight; // 體重（可選）
  final List<ExerciseEntry> exercises; // 運動記錄列表
  final double burnedCalories; // 燃燒卡路里（由 exercises 計算）
  final List<WaterEntry> waterEntries; // 喝水記錄列表

  DailyLog({
    required this.date,
    Map<String, MealRecord>? meals,
    this.weight,
    List<ExerciseEntry>? exercises,
    List<WaterEntry>? waterEntries,
  })  : meals = meals ?? _defaultMeals(),
        exercises = exercises ?? [],
        waterEntries = waterEntries ?? [],
        burnedCalories = _calcBurnedCalories(exercises ?? []);

  static double _calcBurnedCalories(List<ExerciseEntry> exercises) {
    return exercises.fold<double>(0.0, (sum, e) => sum + e.caloriesBurned);
  }

  static Map<String, MealRecord> _defaultMeals() {
    return {for (var type in AppConstants.mealTypes) type: MealRecord(type: type)};
  }

  /// 取得某餐記錄
  MealRecord getMeal(String type) => meals[type] ?? MealRecord(type: type);

  /// 更新某餐記錄
  DailyLog updateMeal(MealRecord meal) {
    final newMeals = Map<String, MealRecord>.from(meals);
    newMeals[meal.type] = meal;
    return DailyLog(date: date, meals: newMeals, weight: weight, exercises: exercises, waterEntries: waterEntries);
  }

  /// 新增運動記錄
  DailyLog addExercise(ExerciseEntry exercise) {
    final newExercises = List<ExerciseEntry>.from(exercises)..add(exercise);
    return DailyLog(date: date, meals: meals, weight: weight, exercises: newExercises, waterEntries: waterEntries);
  }

  /// 移除運動記錄
  DailyLog removeExercise(String exerciseId) {
    final newExercises = exercises.where((e) => e.id != exerciseId).toList();
    return DailyLog(date: date, meals: meals, weight: weight, exercises: newExercises, waterEntries: waterEntries);
  }

  /// 當日總熱量
  double get totalCalories {
    return meals.values.fold(0, (sum, meal) => sum + meal.totalCalories);
  }

  /// 當日總碳水
  double get totalCarbs {
    return meals.values.fold(0, (sum, meal) => sum + meal.totalCarbs);
  }

  /// 當日總蛋白質
  double get totalProtein {
    return meals.values.fold(0, (sum, meal) => sum + meal.totalProtein);
  }

  /// 當日總脂肪
  double get totalFat {
    return meals.values.fold(0, (sum, meal) => sum + meal.totalFat);
  }

  /// 熱量達成率
  double calorieProgress(int target) {
    if (target == 0) return 0;
    return (totalCalories / target).clamp(0, 2);
  }

  /// 當日總喝水量（ml）
  double get totalWaterMl {
    return waterEntries.fold<double>(0.0, (sum, e) => sum + e.ml);
  }

  /// 喝水達成率（相對於目標）
  double waterProgress(double targetMl) {
    if (targetMl <= 0) return 0;
    return (totalWaterMl / targetMl).clamp(0, 2);
  }

  /// 新增喝水記錄
  DailyLog addWater(WaterEntry entry) {
    final newWaterEntries = List<WaterEntry>.from(waterEntries)..add(entry);
    return DailyLog(date: date, meals: meals, weight: weight, exercises: exercises, waterEntries: newWaterEntries);
  }

  /// 移除喝水記錄
  DailyLog removeWater(String entryId) {
    final newWaterEntries = waterEntries.where((e) => e.id != entryId).toList();
    return DailyLog(date: date, meals: meals, weight: weight, exercises: exercises, waterEntries: newWaterEntries);
  }

  /// DateTime 版本
  DateTime get dateTime => AppDateUtils.parseDate(date);

  Map<String, dynamic> toJson() => {
    'date': date,
    'meals': meals.map((k, v) => MapEntry(k, v.toJson())),
    'weight': weight,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'waterEntries': waterEntries.map((e) => e.toJson()).toList(),
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as Map<String, dynamic>? ?? {};
    final exercisesJson = json['exercises'] as List? ?? [];
    final waterJson = json['waterEntries'] as List? ?? [];
    return DailyLog(
      date: json['date'] as String? ?? DateTime.now().toIso8601String().split('T').first,
      meals: mealsJson.map((k, v) => MapEntry(
        k,
        MealRecord.fromJson(v as Map<String, dynamic>),
      )),
      weight: (json['weight'] as num?)?.toDouble(),
      exercises: exercisesJson
          .map((e) => ExerciseEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      waterEntries: waterJson
          .map((e) => WaterEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory DailyLog.empty(String date) => DailyLog(date: date);
  factory DailyLog.today() => DailyLog(date: AppDateUtils.todayString());
}
