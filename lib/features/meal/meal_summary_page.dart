import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// 每日餐次總結頁面
class MealSummaryPage extends ConsumerWidget {
  const MealSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogProvider);
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;

    return Scaffold(
      appBar: AppBar(
        title: const Text('餐次總結'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 總熱量概覽
            _TotalOverview(
              consumed: log.totalCalories,
              target: target.calories,
            ),
            const SizedBox(height: 20),

            // 各餐次卡片
            ...AppConstants.mealTypes.map((mealType) {
              final meal = log.getMeal(mealType);
              final isOverTarget = meal.totalCalories > target.calories;
              return _MealSummaryCard(
                mealType: mealType,
                meal: meal,
                isOverTarget: isOverTarget,
                onDeleteEntry: (entryId) {
                  ref.read(dailyLogProvider.notifier).removeEntry(mealType, entryId);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 總熱量概覽
class _TotalOverview extends StatelessWidget {
  final double consumed;
  final int target;

  const _TotalOverview({
    required this.consumed,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = target - consumed;
    final isOver = remaining < 0;
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.5) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日總熱量',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: consumed.round().toString(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isOver ? AppTheme.errorColor : AppTheme.calorieColor,
                            ),
                          ),
                          TextSpan(
                            text: ' / $target kcal',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          isOver ? AppTheme.errorColor : AppTheme.primaryColor,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOver
                    ? AppTheme.errorColor.withValues(alpha: 0.1)
                    : AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isOver
                    ? '已超出 ${(-remaining).round()} kcal'
                    : '還可攝入 ${remaining.round()} kcal',
                style: TextStyle(
                  color: isOver ? AppTheme.errorColor : AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 單個餐次總結卡片
class _MealSummaryCard extends StatelessWidget {
  final String mealType;
  final dynamic meal;
  final bool isOverTarget;
  final Function(String) onDeleteEntry;

  const _MealSummaryCard({
    required this.mealType,
    required this.meal,
    required this.isOverTarget,
    required this.onDeleteEntry,
  });

  IconData get _mealIcon {
    switch (mealType) {
      case '早餐': return Icons.wb_sunny;
      case '午餐': return Icons.wb_cloudy;
      case '晚餐': return Icons.nightlight_round;
      case '點心': return Icons.cookie;
      default: return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverTarget ? AppTheme.errorColor : Colors.grey.shade300,
          width: isOverTarget ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // 餐次標題列
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isOverTarget
                  ? AppTheme.errorColor.withValues(alpha: 0.05)
                  : AppTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Icon(_mealIcon, color: isOverTarget ? AppTheme.errorColor : AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  mealType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isOverTarget ? AppTheme.errorColor : Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  '${meal.totalCalories.round()} kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isOverTarget ? AppTheme.errorColor : AppTheme.calorieColor,
                  ),
                ),
                if (isOverTarget) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.warning_amber,
                    color: AppTheme.errorColor,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),

          // 食物列表
          if (meal.entries.isNotEmpty)
            ...meal.entries.map((entry) => _EntryItem(
                  entry: entry,
                  onDelete: () => onDeleteEntry(entry.id),
                ))
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '尚無記錄',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

/// 單筆食物項目
class _EntryItem extends StatelessWidget {
  final dynamic entry;
  final VoidCallback onDelete;

  const _EntryItem({
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('刪除確認'),
            content: Text('確定要刪除「${entry.food.name}」嗎？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('刪除', style: TextStyle(color: AppTheme.errorColor)),
              ),
            ],
          ),
        ) ?? false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.food.name,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.grams.round()}g',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.calories.round()} kcal',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MacroMini(label: '碳', value: entry.carbs.round()),
                    const SizedBox(width: 4),
                    _MacroMini(label: '蛋白', value: entry.protein.round()),
                    const SizedBox(width: 4),
                    _MacroMini(label: '脂', value: entry.fat.round()),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
              onPressed: () => _showDeleteConfirm(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除確認'),
        content: Text('確定要刪除「${entry.food.name}」嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已刪除')),
              );
            },
            child: const Text('刪除', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}

/// 迷你營養素標籤
class _MacroMini extends StatelessWidget {
  final String label;
  final int value;

  const _MacroMini({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label:${value}g',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }
}
