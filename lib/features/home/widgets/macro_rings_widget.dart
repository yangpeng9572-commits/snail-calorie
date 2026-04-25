import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';

/// 營養素三環圖 widget（蛋白質 / 脂肪 / 碳水化合物）
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

    // 目標量計算
    double targetProtein;
    double targetFat;
    double targetCarbs;

    if (target.proteinGrams > 0) {
      targetProtein = target.proteinGrams;
    } else {
      // 預設：體重 * 1.6 g，若無體重則預設 60g
      final weight = profile?.weightKg ?? 60;
      targetProtein = weight * 1.6;
    }

    if (target.fatGrams > 0) {
      targetFat = target.fatGrams;
    } else {
      // 預設：熱量目標 * 25% / 9，無資料則預設 50g
      targetFat = 50;
    }

    if (target.carbsGrams > 0) {
      targetCarbs = target.carbsGrams;
    } else {
      // 碳水：(熱量目標 - 蛋白質熱量 - 脂肪熱量) / 4
      final proteinCals = targetProtein * 4;
      final fatCals = targetFat * 9;
      final calories = target.calories > 0 ? target.calories : 2000;
      targetCarbs = (calories - proteinCals - fatCals) / 4;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '營養素攝入',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MacroRing(
                  label: '蛋白質',
                  consumed: consumedProtein,
                  target: targetProtein,
                  unit: 'g',
                  color: AppTheme.proteinColor,
                ),
                _MacroRing(
                  label: '脂肪',
                  consumed: consumedFat,
                  target: targetFat,
                  unit: 'g',
                  color: AppTheme.fatColor,
                ),
                _MacroRing(
                  label: '碳水',
                  consumed: consumedCarbs,
                  target: targetCarbs,
                  unit: 'g',
                  color: AppTheme.carbsColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 單一營養素環
class _MacroRing extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final String unit;
  final Color color;

  const _MacroRing({
    required this.label,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(
            painter: _RingPainter(
              progress: progress,
              color: color,
              backgroundColor: Colors.grey.shade200,
            ),
            child: Center(
              child: Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          '${consumed.round()}/${target.round()}$unit',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

/// 環形圖 CustomPaint
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 8.0;

    // 背景環
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // 前景環（進度）
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -90 * (3.14159265359 / 180); // 從頂部開始
    final sweepAngle = 2 * 3.14159265359 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
