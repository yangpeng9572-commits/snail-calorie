import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';

/// 營養素三環圖 widget（蛋白質 / 脂肪 / 碳水化合物）
/// FatSecret 風格 - 粗環、厚實、數字在環上
class MacroRingsWidget extends ConsumerWidget {
  const MacroRingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogProvider);
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;
    final profile = profileState.profile;

    // 當日攝入量
    final consumedProtein = log.totalProtein;
    final consumedFat = log.totalFat;
    final consumedCarbs = log.totalCarbs;
    final consumedCalories = log.totalCalories;
    final burnedCalories = log.burnedCalories;
    final targetCalories = target.calories > 0 ? target.calories : 2000;

    // 目標量計算
    double targetProtein;
    double targetFat;
    double targetCarbs;

    if (target.proteinGrams > 0) {
      targetProtein = target.proteinGrams;
    } else {
      final weight = profile?.weightKg ?? 60;
      targetProtein = weight * 1.6;
    }

    if (target.fatGrams > 0) {
      targetFat = target.fatGrams;
    } else {
      targetFat = 50;
    }

    if (target.carbsGrams > 0) {
      targetCarbs = target.carbsGrams;
    } else {
      final proteinCals = targetProtein * 4;
      final fatCals = targetFat * 9;
      targetCarbs = (targetCalories - proteinCals - fatCals) / 4;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題列
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '今日營養攝入',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.calorieColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${consumedCalories.round()} / ${targetCalories.round()} kcal',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.calorieColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 巨量環 - FatSecret 風格（粗線條 + 加大）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MacroRingFat(
                  label: '熱量',
                  consumed: consumedCalories.toDouble(),
                  target: targetCalories.toDouble(),
                  unit: 'kcal',
                  color: AppTheme.calorieColor,
                  size: 96,
                  strokeWidth: 14,
                ),
                _MacroRingFat(
                  label: '蛋白質',
                  consumed: consumedProtein,
                  target: targetProtein,
                  unit: 'g',
                  color: AppTheme.proteinColor,
                  size: 96,
                  strokeWidth: 14,
                ),
                _MacroRingFat(
                  label: '脂肪',
                  consumed: consumedFat,
                  target: targetFat,
                  unit: 'g',
                  color: AppTheme.fatColor,
                  size: 96,
                  strokeWidth: 14,
                ),
                _MacroRingFat(
                  label: '碳水',
                  consumed: consumedCarbs,
                  target: targetCarbs,
                  unit: 'g',
                  color: AppTheme.carbsColor,
                  size: 96,
                  strokeWidth: 14,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 消耗熱量（分開顯示）
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.exerciseColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppTheme.exerciseColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '今日消耗 ${burnedCalories.round()} kcal',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.exerciseColor,
                    ),
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

/// FatSecret 風格巨量環
class _MacroRingFat extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final String unit;
  final Color color;
  final double size;
  final double strokeWidth;

  const _MacroRingFat({
    required this.label,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.color,
    this.size = 80,
    this.strokeWidth = 12,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainterFat(
              progress: progress,
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
              strokeWidth: strokeWidth,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: size == 96 ? 18 : (size == 88 ? 16 : 14),
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${consumed.round()}$unit',
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// 環形圖 CustomPaint - FatSecret 厚實風格
class _RingPainterFat extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _RingPainterFat({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 背景環
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // 前景環（進度）
    if (progress > 0) {
      final fgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // 從頂部開始（-90度）
      const startAngle = -90 * (3.14159265359 / 180);
      final sweepAngle = 2 * 3.14159265359 * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainterFat oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
