import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/daily_log.dart';

class ExportService {
  /// 匯出指定日期範圍的飲食記錄為 CSV
  Future<String> exportToCsv(List<DailyLog> logs) async {
    const header = '日期,餐次,食物名稱,熱量(kcal),蛋白質(g),碳水(g),脂肪(g)\n';
    final rows = logs.expand((log) =>
      log.meals.values.expand((meal) =>
        meal.entries.map((e) =>
          '${log.date},${meal.type},${e.food.name},${e.calories.toStringAsFixed(1)},${e.protein.toStringAsFixed(1)},${e.carbs.toStringAsFixed(1)},${e.fat.toStringAsFixed(1)}'
        )
      )
    ).join('\n');
    return '$header$rows';
  }

  /// 匯出為 JSON
  Future<String> exportToJson(List<DailyLog> logs) async {
    return json.encode(logs.map((l) => l.toJson()).toList());
  }

  /// 保存並分享檔案
  Future<void> saveAndShare(String filename, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: '食刻輕卡 - 飲食記錄',
    );
  }
}
