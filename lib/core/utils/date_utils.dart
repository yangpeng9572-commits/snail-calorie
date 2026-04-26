import 'package:intl/intl.dart';

/// 日期時間工具
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayDateFormat = DateFormat('MM月dd日');

  /// 取得今天日期字串（yyyy-MM-dd）
  static String todayString() => _dateFormat.format(DateTime.now());

  /// 格式化日期
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// 顯示用格式（MM月dd日）
  static String displayDate(DateTime date) => _displayDateFormat.format(date);

  /// 取得星期幾（繁體）
  static String weekday(DateTime date) {
    const weekdays = ['週一', '週二', '週三', '週四', '週五', '週六', '週日'];
    return weekdays[date.weekday - 1];
  }

  /// 解析日期字串
  static DateTime parseDate(String dateStr) => _dateFormat.parse(dateStr);

  /// 取得本週第一天（週一）
  static DateTime weekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// 取得日期範圍內所有日期
  static List<DateTime> dateRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = start;
    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  /// 是否為同一天
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 是否為今天
  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());
}
