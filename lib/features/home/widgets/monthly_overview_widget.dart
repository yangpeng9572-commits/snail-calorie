import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';

/// 月度熱量概覽柱狀圖 widget
class MonthlyOverviewWidget extends ConsumerWidget {
  const MonthlyOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target.calories;
    final monthLogs = _getMonthLogs(ref);

    // 取得近30天的數據
    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(const Duration(days: 29));
    final barGroups = <BarChartGroupData>[];
    final xLabels = <String>[];
    double maxY = target.toDouble() * 1.5;

    for (int i = 0; i < 30; i++) {
      final date = thirtyDaysAgo.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      final log = monthLogs[dateStr];
      final calories = log?.totalCalories ?? 0.0;

      if (calories > maxY) maxY = calories * 1.2;
      if (maxY < 500) maxY = 500;

      final isOver = calories > target && target > 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: calories,
              color: isOver ? AppTheme.errorColor : AppTheme.primaryColor,
              width: 8,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ],
        ),
      );

      // X軸標籤：只顯示每5天
      if (i % 5 == 0) {
        xLabels.add('${date.month}/${date.day}');
      } else {
        xLabels.add('');
      }
    }

    final effectiveTarget = target > 0 ? target.toDouble() : 2000.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '30天熱量概覽',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _LegendDot(color: AppTheme.primaryColor, label: '達標'),
                    SizedBox(width: 12),
                    _LegendDot(color: AppTheme.errorColor, label: '超標'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '近30天每日熱量柱狀圖',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
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
                          if (idx < 0 || idx >= xLabels.length) return const Text('');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              xLabels[idx],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                        y: effectiveTarget,
                        color: AppTheme.accentColor,
                        strokeWidth: 2,
                        dashArray: [8, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          labelResolver: (_) => '目標 $effectiveTarget',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final date = thirtyDaysAgo.add(Duration(days: group.x));
                        return BarTooltipItem(
                          '${date.month}/${date.day}\n${rod.toY.round()} kcal',
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
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getMonthLogs(WidgetRef ref) {
    final storage = ref.read(localStorageProvider);
    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(const Duration(days: 29));
    final logs = <String, dynamic>{};

    for (int i = 0; i < 30; i++) {
      final date = thirtyDaysAgo.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      final log = storage.getDailyLog(dateStr);
      if (log != null) {
        logs[dateStr] = log;
      }
    }
    return logs;
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
