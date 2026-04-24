import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../search/search_page.dart';
import '../barcode/barcode_scanner_page.dart';

/// 首頁儀表板
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogProvider);
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;
    final selectedDate = ref.watch(selectedDateProvider);

    final calorieProgress = target.calories > 0 ? log.totalCalories / target.calories : 0.0;
    final carbsProgress = target.carbsGrams > 0 ? log.totalCarbs / target.carbsGrams : 0.0;
    final proteinProgress = target.proteinGrams > 0 ? log.totalProtein / target.proteinGrams : 0.0;
    final fatProgress = target.fatGrams > 0 ? log.totalFat / target.fatGrams : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('食刻輕卡'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日期選擇列
            _DateSelector(
              selectedDate: selectedDate,
              onDateChanged: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            ),
            const SizedBox(height: 16),

            // 熱量卡片
            _CalorieCard(
              consumed: log.totalCalories,
              target: target.calories,
              progress: calorieProgress.clamp(0.0, 1.0),
            ),
            const SizedBox(height: 16),

            // 三大營養素進度
            Row(
              children: [
                Expanded(
                  child: _MacroProgressCard(
                    label: '碳水',
                    current: log.totalCarbs,
                    target: target.carbsGrams,
                    progress: carbsProgress.clamp(0.0, 1.0),
                    color: AppTheme.carbsColor,
                    unit: 'g',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MacroProgressCard(
                    label: '蛋白質',
                    current: log.totalProtein,
                    target: target.proteinGrams,
                    progress: proteinProgress.clamp(0.0, 1.0),
                    color: AppTheme.proteinColor,
                    unit: 'g',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MacroProgressCard(
                    label: '脂肪',
                    current: log.totalFat,
                    target: target.fatGrams,
                    progress: fatProgress.clamp(0.0, 1.0),
                    color: AppTheme.fatColor,
                    unit: 'g',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 餐次列表
            const Text('今日餐次', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...AppConstants.mealTypes.map((mealType) => _MealSection(
              mealType: mealType,
              meal: log.getMeal(mealType),
              onAdd: () => _showAddFoodDialog(context, ref, mealType),
              onRemove: (entryId) => ref.read(dailyLogProvider.notifier).removeEntry(mealType, entryId),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFoodDialog(BuildContext context, WidgetRef ref, String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddFoodToMealPage(mealType: mealType),
      ),
    );
  }
}

/// 日期選擇列
class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DateSelector({required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.subtract(Duration(days: 3 - i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = AppDateUtils.isSameDay(date, selectedDate);
          final isToday = AppDateUtils.isToday(date);

          return GestureDetector(
            onTap: () => onDateChanged(date),
            child: Container(
              width: 56,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isToday && !isSelected
                    ? Border.all(color: AppTheme.primaryColor, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppDateUtils.weekday(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 熱量卡片
class _CalorieCard extends StatelessWidget {
  final double consumed;
  final int target;
  final double progress;

  const _CalorieCard({
    required this.consumed,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = target - consumed;
    final hasRecord = consumed > 0 || target > 0;

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
                    const Text('今日攝入', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 4),
                    if (!hasRecord)
                      const Text(
                        '尚未記錄',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                    else
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: consumed.round().toString(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.calorieColor,
                              ),
                            ),
                            TextSpan(
                              text: ' / $target kcal',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (hasRecord)
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            progress > 1 ? AppTheme.errorColor : AppTheme.primaryColor,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: 0,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(Colors.grey),
                        ),
                        const Center(
                          child: Icon(Icons.add, color: Colors.grey, size: 32),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasRecord)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: remaining >= 0
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  remaining >= 0
                      ? '還可攝入 ${remaining.round()} kcal'
                      : '已超出 ${(-remaining).round()} kcal',
                  style: TextStyle(
                    color: remaining >= 0 ? AppTheme.primaryColor : AppTheme.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '點擊 + 新增餐點',
                  style: TextStyle(
                    color: Colors.grey,
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

/// 營養素進度卡片
class _MacroProgressCard extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final double progress;
  final Color color;
  final String unit;

  const _MacroProgressCard({
    required this.label,
    required this.current,
    required this.target,
    required this.progress,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              '${current.round()}$unit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '/ ${target.round()}$unit',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 餐次區塊
class _MealSection extends StatelessWidget {
  final String mealType;
  final dynamic meal;
  final VoidCallback onAdd;
  final Function(String) onRemove;

  const _MealSection({
    required this.mealType,
    required this.meal,
    required this.onAdd,
    required this.onRemove,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(_mealIcon, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(mealType, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  '${meal.totalCalories.round()} kcal',
                  style: const TextStyle(color: AppTheme.calorieColor, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                  onPressed: onAdd,
                ),
              ],
            ),
            if (meal.entries.isNotEmpty) ...[
              const Divider(),
              ...meal.entries.map((entry) => _EntryRow(
                entry: entry,
                onDelete: () => onRemove(entry.id),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

/// 單筆食物列
class _EntryRow extends StatelessWidget {
  final dynamic entry;
  final VoidCallback onDelete;

  const _EntryRow({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.food.name, style: const TextStyle(fontSize: 14)),
                Text(
                  '${entry.grams.round()}g',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${entry.calories.round()} kcal',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

/// 新增食物到餐次的頁面（跳轉用）
class AddFoodToMealPage extends StatelessWidget {
  final String mealType;

  const AddFoodToMealPage({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新增到 $mealType')),
      body: const Center(child: Text('選擇食物')),
    );
  }
}
