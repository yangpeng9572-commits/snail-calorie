import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';

/// 圖表分析頁面
class ChartsPage extends ConsumerStatefulWidget {
  const ChartsPage({super.key});

  @override
  ConsumerState<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends ConsumerState<ChartsPage> {
  late DateTime _selectedWeekStart;

  @override
  void initState() {
    super.initState();
    _selectedWeekStart = AppDateUtils.weekStart(DateTime.now());
  }

  void _goToPrevWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;
    final weekLogs = _getWeekLogs(_selectedWeekStart);

    return Scaffold(
      appBar: AppBar(title: const Text('每週分析')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 週導航
            _WeekNavigator(
              weekStart: _selectedWeekStart,
              onPrev: _goToPrevWeek,
              onNext: _goToNextWeek,
            ),
            const SizedBox(height: 24),

            // 標題
            const Text('本週熱量趨勢', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('與每日目標相比的攝入情況', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),

            // 柱狀圖：每日熱量
            _WeeklyCalorieChart(weekLogs: weekLogs, target: target.calories),
            const SizedBox(height: 32),

            // 營養素分佈圓餅圖
            _MacroPieChart(weekLogs: weekLogs),
            const SizedBox(height: 32),

            // 每日詳情列表
            const Text('每日記錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (weekLogs.isEmpty)
              const _EmptyWeekState()
            else
              ...weekLogs.entries.map((e) => _DayCard(dateStr: e.key, log: e.value, target: target)),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getWeekLogs(DateTime weekStart) {
    final storage = ref.read(localStorageProvider);
    final logs = <String, dynamic>{};
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      final log = storage.getDailyLog(dateStr);
      if (log != null) {
        logs[dateStr] = {
          'totalCalories': log.totalCalories,
          'totalCarbs': log.totalCarbs,
          'totalProtein': log.totalProtein,
          'totalFat': log.totalFat,
        };
      }
    }
    return logs;
  }
}

class _WeeklyCalorieChart extends StatelessWidget {
  final Map<String, dynamic> weekLogs;
  final int target;

  const _WeeklyCalorieChart({required this.weekLogs, required this.target});

  @override
  Widget build(BuildContext context) {
    final entries = weekLogs.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (target * 1.5).toDouble(),
              barGroups: entries.asMap().entries.map((entry) {
                final idx = entry.key;
                final log = entry.value.value;
                final calories = (log is Map) ? (log['totalCalories'] ?? 0.0) as double : 0.0;
                final isOver = calories > target;

                return BarChartGroupData(
                  x: idx,
                  barRods: [
                    BarChartRodData(
                      toY: calories,
                      color: isOver ? AppTheme.errorColor : AppTheme.primaryColor,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= entries.length) return const Text('');
                      final date = AppDateUtils.parseDate(entries[value.toInt()].key);
                      const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
                      return Text(weekdays[date.weekday - 1], style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: target.toDouble(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  strokeWidth: 2,
                  dashArray: [5, 5],
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}

class _MacroPieChart extends StatelessWidget {
  final Map<String, dynamic> weekLogs;

  const _MacroPieChart({required this.weekLogs});

  @override
  Widget build(BuildContext context) {
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;

    for (final log in weekLogs.values) {
      if (log is Map) {
        totalCarbs += (log['totalCarbs'] ?? 0.0) as double;
        totalProtein += (log['totalProtein'] ?? 0.0) as double;
        totalFat += (log['totalFat'] ?? 0.0) as double;
      }
    }

    final total = totalCarbs + totalProtein + totalFat;
    if (total == 0) {
      return Card(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: const Text('本週尚無資料', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('本週營養素攝入比例', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: totalCarbs,
                            title: '${(totalCarbs / total * 100).round()}%',
                            color: AppTheme.carbsColor,
                            radius: 60,
                            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          PieChartSectionData(
                            value: totalProtein,
                            title: '${(totalProtein / total * 100).round()}%',
                            color: AppTheme.proteinColor,
                            radius: 60,
                            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          PieChartSectionData(
                            value: totalFat,
                            title: '${(totalFat / total * 100).round()}%',
                            color: AppTheme.fatColor,
                            radius: 60,
                            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(color: AppTheme.carbsColor, label: '碳水化合物', value: '${totalCarbs.round()}g'),
                      _LegendItem(color: AppTheme.proteinColor, label: '蛋白質', value: '${totalProtein.round()}g'),
                      _LegendItem(color: AppTheme.fatColor, label: '脂肪', value: '${totalFat.round()}g'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text('$label: $value', style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String dateStr;
  final dynamic log;
  final dynamic target;

  const _DayCard({required this.dateStr, required this.log, required this.target});

  @override
  Widget build(BuildContext context) {
    final date = AppDateUtils.parseDate(dateStr);
    final calories = (log is Map) ? (log['totalCalories'] ?? 0.0) as double : 0.0;
    final targetCal = target is int ? target : (target as dynamic).calories as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${date.day}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(AppDateUtils.weekday(date), style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
        title: Text('${calories.round()} / $targetCal kcal'),
        subtitle: LinearProgressIndicator(
          value: (calories / targetCal).clamp(0, 1),
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(
            calories > targetCal ? AppTheme.errorColor : AppTheme.primaryColor,
          ),
        ),
        trailing: Text(
          calories > targetCal ? '+${(calories - targetCal).round()}' : '${(targetCal - calories).round()}',
          style: TextStyle(
            color: calories > targetCal ? AppTheme.errorColor : AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _WeekNavigator extends StatelessWidget {
  final DateTime weekStart;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _WeekNavigator({
    required this.weekStart,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final displayFormat = '${weekStart.month}月${weekStart.day}日 - ${weekEnd.month}月${weekEnd.day}日';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          ),
        ),
        Text(
          displayFormat,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

class _EmptyWeekState extends StatelessWidget {
  const _EmptyWeekState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              '本週尚無記錄',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '開始記錄餐點來查看每週分析',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
