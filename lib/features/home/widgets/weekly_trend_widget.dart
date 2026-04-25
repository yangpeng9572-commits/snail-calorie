import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';

/// 每週熱量趨勢折線圖 widget
class WeeklyTrendWidget extends ConsumerWidget {
  const WeeklyTrendWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target.calories;
    final weekLogs = _getWeekLogs(ref);

    // 準備數據
    final today = DateTime.now();
    final monday = AppDateUtils.weekStart(today);
    final spots = <FlSpot>[];
    final xLabels = <String>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      final log = weekLogs[dateStr];
      final calories = log?.totalCalories ?? 0.0;
      spots.add(FlSpot(i.toDouble(), calories));
      xLabels.add(AppDateUtils.weekday(date));
    }

    // 計算 Y軸最大值
    double maxY = (target * 1.5).toDouble();
    for (final spot in spots) {
      if (spot.y > maxY) maxY = spot.y * 1.2;
    }
    if (maxY < 500) maxY = 500;

    final effectiveTarget = target > 0 ? target.toDouble() : 2000.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '本週熱量趨勢',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '目標 $effectiveTarget kcal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '近7天熱量攝入趨勢',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppTheme.calorieColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppTheme.calorieColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.calorieColor.withOpacity(0.15),
                      ),
                    ),
                  ],
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
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
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
                      color: Colors.grey.withOpacity(0.2),
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
                          labelResolver: (_) => '目標',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final idx = spot.x.toInt();
                          final label = idx < xLabels.length ? xLabels[idx] : '';
                          return LineTooltipItem(
                            '$label\n${spot.y.round()} kcal',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
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

  Map<String, dynamic> _getWeekLogs(WidgetRef ref) {
    final storage = ref.read(localStorageProvider);
    final today = DateTime.now();
    final monday = AppDateUtils.weekStart(today);
    final logs = <String, dynamic>{};

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr = AppDateUtils.formatDate(date);
      final log = storage.getDailyLog(dateStr);
      if (log != null) {
        logs[dateStr] = log;
      }
    }
    return logs;
  }
}
