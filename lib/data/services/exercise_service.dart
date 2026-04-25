import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_entry.dart';

/// 運動記錄服務
/// 使用 SharedPreferences 儲存運動資料
class ExerciseService {
  static const String _keyExerciseLogPrefix = 'exercise_log_';

  final SharedPreferences _prefs;

  ExerciseService(this._prefs);

  /// 儲存運動記錄
  Future<void> saveExercise(ExerciseEntry entry) async {
    final entries = await getExercisesByDate(entry.date);
    entries.add(entry);
    await _saveEntries(entry.date, entries);
  }

  /// 刪除運動記錄
  Future<void> deleteExercise(String date, String entryId) async {
    final entries = await getExercisesByDate(date);
    entries.removeWhere((e) => e.id == entryId);
    await _saveEntries(date, entries);
  }

  /// 取得指定日期的運動記錄
  Future<List<ExerciseEntry>> getExercisesByDate(String date) async {
    final key = '$_keyExerciseLogPrefix$date';
    final str = _prefs.getString(key);
    if (str == null) return [];

    final list = json.decode(str) as List;
    return list
        .map((e) => ExerciseEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 取得指定日期範圍內的運動記錄
  Future<List<ExerciseEntry>> getExercisesInRange(String startDate, String endDate) async {
    final allEntries = <ExerciseEntry>[];

    // 解析日期範圍
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);

    for (var date = start;
        date.isBefore(end.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final dateStr = _formatDate(date);
      final entries = await getExercisesByDate(dateStr);
      allEntries.addAll(entries);
    }

    return allEntries;
  }

  /// 儲存當日的運動記錄列表
  Future<void> _saveEntries(String date, List<ExerciseEntry> entries) async {
    final key = '$_keyExerciseLogPrefix$date';
    final list = entries.map((e) => e.toJson()).toList();
    await _prefs.setString(key, json.encode(list));
  }

  /// 格式化日期為字串
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 計算指定日期的總燃燒卡路里
  Future<double> getTotalCaloriesByDate(String date) async {
    final entries = await getExercisesByDate(date);
    return entries.fold<double>(0.0, (sum, e) => sum + e.caloriesBurned);
  }
}
