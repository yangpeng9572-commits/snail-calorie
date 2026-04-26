import '../models/daily_log.dart';

/// 營養熱量計算服務
class NutritionCalculator {
  /// 計算今日已攝入熱量
  static double todayCalories(List<DailyLog> logs) {
    return logs.fold(0, (sum, log) => sum + log.totalCalories);
  }

  /// 計算今日蛋白質攝入
  static double todayProtein(List<DailyLog> logs) {
    return logs.fold(0, (sum, log) => sum + log.totalProtein);
  }

  /// 估算達成目標熱量還需要吃多少
  static double remainingCalories(double target, List<DailyLog> logs) {
    final consumed = todayCalories(logs);
    return target - consumed;
  }

  /// 根據剩餘熱量給予餐點建議
  static String mealSuggestion(double remainingCalories) {
    if (remainingCalories < 200) {
      return '熱量已接近目標，建議吃輕食或水果';
    }
    if (remainingCalories < 500) {
      return '建議均衡一餐，熱量約 400-500 kcal';
    }
    return '熱量充足，可以正常用餐';
  }

  /// 檢查是否超標
  static bool isOverTarget(double target, List<DailyLog> logs) {
    return todayCalories(logs) > target;
  }

  /// 計算超標熱量
  static double overageCalories(double target, List<DailyLog> logs) {
    final remaining = remainingCalories(target, logs);
    return remaining < 0 ? -remaining : 0;
  }
}
