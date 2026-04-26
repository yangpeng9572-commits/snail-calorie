import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/daily_log.dart';
import '../../core/constants/app_constants.dart';

/// 統計數據頁面 - 顯示每週/每月趨勢圖表
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedTabIndex = 0; // 0=週, 1=月
  late DateTime _selectedWeekStart;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

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

  void _goToPrevMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: const Text('統計數據', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          //  tabs: 週 / 月
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _TabButton(
                  label: '每週',
                  isSelected: _selectedTabIndex == 0,
                  onTap: () => setState(() => _selectedTabIndex = 0),
                ),
                const SizedBox(width: 12),
                _TabButton(
                  label: '每月',
                  isSelected: _selectedTabIndex == 1,
                  onTap: () => setState(() => _selectedTabIndex = 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedTabIndex == 0
                ? _WeeklyStatsView(
                    weekStart: _selectedWeekStart,
                    target: target,
                    onPrevWeek: _goToPrevWeek,
                    onNextWeek: _goToNextWeek,
                  )
                : _MonthlyStatsView(
                    month: _selectedMonth,
                    year: _selectedYear,
                    target: target,
                    onPrevMonth: _goToPrevMonth,
                    onNextMonth: _goToNextMonth,
                  ),
          ),
        ],
      ),
    );
  }
}

/// 每週統計視圖
class _WeeklyStatsView extends StatelessWidget {
  final DateTime weekStart;
  final NutritionTarget target;
  final VoidCallback onPrevWeek;
  final VoidCallback onNextWeek;

  const _WeeklyStatsView({
    required this.weekStart,
    required this.target,
    required this.onPrevWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final weekLogs = _getWeekLogs(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 週導航
          _WeekNavigator(
            weekStart: weekStart,
            onPrev: onPrevWeek,
            onNext: onNextWeek,
          ),
          const SizedBox(height: 24),

          // 熱量柱狀圖
          const Text('本週熱量攝入', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('每日熱量與目標比較', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 16),
          _WeeklyCalorieBarChart(weekLogs: weekLogs, target: target.calories, weekStart: weekStart),
          const SizedBox(height: 32),

          // 營養素分佈圓餅圖
          const Text('本週營養素比例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('蛋白質 / 脂肪 / 碳水化合物', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 16),
          _MacroPieChart(logs: weekLogs),
          const SizedBox(height: 32),

          // 週摘要統計
          _WeekSummaryCard(weekLogs: weekLogs, target: target.calories),
        ],
      ),
    );
  }

  Map<String, DailyLog> _getWeekLogs(BuildContext context) {
    // Use read instead of watch since this is inside build but doesn't need reactivity
    final container = ProviderScope.containerOf(context);
    final storage = container.read(localStorageProvider);
    final logs = <String, DailyLog>{};

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      final log = storage.getDailyLog(dateStr);
      if (log != null) {
        logs[dateStr] = log;
      }
    }
    return logs;
  }
}

/// 每月統計視圖
class _MonthlyStatsView extends StatelessWidget {
  final int month;
  final int year;
  final NutritionTarget target;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _MonthlyStatsView({
    required this.month,
    required this.year,
    required this.target,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthLogs = _getMonthLogs(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 月份導航
          _MonthNavigator(
            month: month,
            year: year,
            onPrev: onPrevMonth,
            onNext: onNextMonth,
          ),
          const SizedBox(height: 24),

          // 月度熱量柱狀圖
          const Text('本月熱量攝入', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('每日熱量分布', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 16),
          _MonthlyCalorieBarChart(monthLogs: monthLogs, target: target.calories, month: month, year: year),
          const SizedBox(height: 32),

          // 營養素分佈圓餅圖
          const Text('本月營養素比例', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('蛋白質 / 脂肪 / 碳水化合物', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 16),
          _MacroPieChart(logs: monthLogs),
          const SizedBox(height: 32),

          // 月度摘要統計
          _MonthSummaryCard(monthLogs: monthLogs, target: target.calories),
        ],
      ),
    );
  }

  Map<String, DailyLog> _getMonthLogs(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final storage = container.read(localStorageProvider);
    final logs = <String, DailyLog>{};

    final daysInMonth = DateTime(year, month + 1, 0).day;
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dateStr = AppDateUtils.formatDate(date);
      final log = storage.getDailyLog(dateStr);
      if (log != null) {
        logs[dateStr] = log;
      }
    }
    return logs;
  }
}

/// 週導航組件
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
    final formatter = '${weekStart.month}/${weekStart.day} - ${weekEnd.month}/${weekEnd.day}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            formatter,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

/// 月份導航組件
class _MonthNavigator extends StatelessWidget {
  final int month;
  final int year;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthNavigator({
    required this.month,
    required this.year,
    required this.onPrev,
    required this.onNext,
  });

  static const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$year年${monthNames[month - 1]}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

/// 每週熱量柱狀圖
class _WeeklyCalorieBarChart extends StatelessWidget {
  final Map<String, DailyLog> weekLogs;
  final int target;
  final DateTime weekStart;

  const _WeeklyCalorieBarChart({
    required this.weekLogs,
    required this.target,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context) {
    final entries = weekLogs.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // 動態計算星期抬頭，從 weekStart 當天開始
    final barGroups = <BarChartGroupData>[];
    final weekdays = <String>[];
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final weekday = day.weekday; // 1=Mon, 7=Sun
      final labels = ['', '一', '二', '三', '四', '五', '六', '日'];
      weekdays.add(labels[weekday]);
    }

    for (int i = 0; i < 7; i++) {
      double calories = 0;
      if (i < entries.length) {
        calories = entries[i].value.totalCalories;
      }

      final isOver = target > 0 && calories > target;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: calories,
              color: isOver ? AppTheme.errorColor : AppTheme.calorieColor,
              width: 28,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ],
        ),
      );
    }

    // 計算最大Y值
    double maxY = (target * 1.5).toDouble();
    for (final log in weekLogs.values) {
      if (log.totalCalories > maxY) {
        maxY = log.totalCalories * 1.2;
      }
    }
    if (maxY < 500) maxY = 500;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    interval: (maxY / 4).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('');
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= weekdays.length) return const Text('');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          weekdays[idx],
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: (maxY / 4).ceilToDouble(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: target.toDouble(),
                    color: AppTheme.accentColor,
                    strokeWidth: 2,
                    dashArray: [8, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      labelResolver: (_) => '目標 $target',
                      style: const TextStyle(fontSize: 10, color: AppTheme.accentColor),
                    ),
                  ),
                ],
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.round()} kcal',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 月度熱量柱狀圖
class _MonthlyCalorieBarChart extends StatelessWidget {
  final Map<String, DailyLog> monthLogs;
  final int target;
  final int month;
  final int year;

  const _MonthlyCalorieBarChart({
    required this.monthLogs,
    required this.target,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    // 計算天數
    if (monthLogs.isEmpty) {
      return Card(
        child: Container(
          height: 250,
          alignment: Alignment.center,
          child: Text('${DateTime.now().month}月尚無資料', style: TextStyle(color: Colors.grey.shade600)),
        ),
      );
    }

    // 找出最大天數
    int maxDay = 0;
    for (final key in monthLogs.keys) {
      final day = int.tryParse(key.split('-').last) ?? 0;
      if (day > maxDay) maxDay = day;
    }

    // 計算最大Y值
    double maxY = (target * 1.5).toDouble();
    for (final log in monthLogs.values) {
      if (log.totalCalories > maxY) {
        maxY = log.totalCalories * 1.2;
      }
    }
    if (maxY < 500) maxY = 500;

    // 按日期排序
    final sortedEntries = monthLogs.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // 建立 day -> log 的 map，確保所有天都有對應 bar（無資料日高度 0）
    final logMap = {for (var e in sortedEntries) int.tryParse(e.key.split('-').last) ?? 0: e.value};
    final barGroups = <BarChartGroupData>[];
    final daysInMonth = DateTime(month, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final log = logMap[day];
      final calories = log?.totalCalories ?? 0.0;
      final isOver = target > 0 && calories > target;
      barGroups.add(
        BarChartGroupData(
          x: day - 1,
          barRods: [
            BarChartRodData(
              toY: calories,
              color: isOver ? AppTheme.errorColor : AppTheme.calorieColor,
              width: 8,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ],
        ),
      );
    }

    // 如果沒有資料（改檢查 monthLogs 而非 barGroups，因為現在每天都生成 bar）
    if (monthLogs.isEmpty) {
      return Card(
        child: Container(
          height: 250,
          alignment: Alignment.center,
          child: const Text('本月尚無資料', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    interval: (maxY / 4).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('');
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 5, // 每5天顯示一次
                    getTitlesWidget: (value, meta) {
                      final day = value.toInt() + 1;
                      if (day % 5 == 0 || day == 1) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '$day日',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: (maxY / 4).ceilToDouble(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: target.toDouble(),
                    color: AppTheme.accentColor,
                    strokeWidth: 2,
                    dashArray: [8, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      labelResolver: (_) => '目標 $target',
                      style: const TextStyle(fontSize: 10, color: AppTheme.accentColor),
                    ),
                  ),
                ],
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${group.x + 1}日\n${rod.toY.round()} kcal',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 營養素圓餅圖
class _MacroPieChart extends StatelessWidget {
  final Map<String, DailyLog> logs;

  const _MacroPieChart({required this.logs});

  @override
  Widget build(BuildContext context) {
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;

    for (final log in logs.values) {
      totalCarbs += log.totalCarbs;
      totalProtein += log.totalProtein;
      totalFat += log.totalFat;
    }

    final total = totalCarbs + totalProtein + totalFat;
    if (total == 0) {
      return Card(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: const Text('尚無資料', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            value: totalCarbs,
                            title: '${(totalCarbs / total * 100).round()}%',
                            color: AppTheme.carbsColor,
                            radius: 65,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: totalProtein,
                            title: '${(totalProtein / total * 100).round()}%',
                            color: AppTheme.proteinColor,
                            radius: 65,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: totalFat,
                            title: '${(totalFat / total * 100).round()}%',
                            color: AppTheme.fatColor,
                            radius: 65,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(
                        color: AppTheme.carbsColor,
                        label: '碳水',
                        value: '${totalCarbs.round()}g',
                      ),
                      const SizedBox(height: 12),
                      _LegendItem(
                        color: AppTheme.proteinColor,
                        label: '蛋白質',
                        value: '${totalProtein.round()}g',
                      ),
                      const SizedBox(height: 12),
                      _LegendItem(
                        color: AppTheme.fatColor,
                        label: '脂肪',
                        value: '${totalFat.round()}g',
                      ),
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

/// 圖例項
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

/// 週摘要卡片
class _WeekSummaryCard extends StatelessWidget {
  final Map<String, DailyLog> weekLogs;
  final int target;

  const _WeekSummaryCard({required this.weekLogs, required this.target});


  @override
  Widget build(BuildContext context) {
    double totalCalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;
    int daysWithData = 0;

    for (final log in weekLogs.values) {
      if (log.totalCalories > 0) {
        daysWithData++;
        totalCalories += log.totalCalories;
        totalCarbs += log.totalCarbs;
        totalProtein += log.totalProtein;
        totalFat += log.totalFat;
      }
    }

    final avgCalories = daysWithData > 0 ? totalCalories / daysWithData : 0.0;
    final avgCarbs = daysWithData > 0 ? totalCarbs / daysWithData : 0.0;
    final avgProtein = daysWithData > 0 ? totalProtein / daysWithData : 0.0;
    final avgFat = daysWithData > 0 ? totalFat / daysWithData : 0.0;

    final targetMetDays = weekLogs.values.where((log) => log.totalCalories >= target && target > 0).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('本週摘要', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.calendar_today,
                    label: '記錄天數',
                    value: '$daysWithData/7天',
                    color: AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.flag,
                    label: '達標天數',
                    value: '$targetMetDays天',
                    color: targetMetDays >= 4 ? AppTheme.primaryColor : AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.local_fire_department,
                    label: '平均熱量',
                    value: '${avgCalories.round()} kcal',
                    color: AppTheme.calorieColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.trending_up,
                    label: '平均碳水',
                    value: '${avgCarbs.round()}g',
                    color: AppTheme.carbsColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.fitness_center,
                    label: '平均蛋白質',
                    value: '${avgProtein.round()}g',
                    color: AppTheme.proteinColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.opacity,
                    label: '平均脂肪',
                    value: '${avgFat.round()}g',
                    color: AppTheme.fatColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 月度摘要卡片
class _MonthSummaryCard extends StatelessWidget {
  final Map<String, DailyLog> monthLogs;
  final int target;

  const _MonthSummaryCard({required this.monthLogs, required this.target});

  @override
  Widget build(BuildContext context) {
    double totalCalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;
    int daysWithData = 0;
    for (final log in monthLogs.values) {
      if (log.totalCalories > 0) {
        daysWithData++;
        totalCalories += log.totalCalories;
        totalCarbs += log.totalCarbs;
        totalProtein += log.totalProtein;
        totalFat += log.totalFat;
      }
    }

    final avgCalories = daysWithData > 0 ? totalCalories / daysWithData : 0.0;
    final targetMetDays = monthLogs.values.where((log) => log.totalCalories >= target && target > 0).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('本月摘要', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.calendar_today,
                    label: '記錄天數',
                    value: '$daysWithData天',
                    color: AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.flag,
                    label: '達標天數',
                    value: '$targetMetDays天',
                    color: targetMetDays >= 15 ? AppTheme.primaryColor : AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.local_fire_department,
                    label: '日均熱量',
                    value: '${avgCalories.round()} kcal',
                    color: AppTheme.calorieColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.restaurant,
                    label: '總攝入熱量',
                    value: '${totalCalories.round()} kcal',
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.fitness_center,
                    label: '蛋白質',
                    value: '${totalProtein.round()}g',
                    color: AppTheme.proteinColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.local_fire_department,
                    label: '脂肪',
                    value: '${totalFat.round()}g',
                    color: AppTheme.fatColor,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.grain,
                    label: '碳水',
                    value: '${totalCarbs.round()}g',
                    color: AppTheme.carbsColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 摘要項目
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

/// Tab 按鈕
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
