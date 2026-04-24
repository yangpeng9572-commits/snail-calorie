import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/page_transitions.dart';
import '../../core/widgets/quick_access_tile.dart';
import '../../data/services/nutrition_calculator.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('食刻輕卡'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.push(
              context,
              SlidePageRoute(page: const BarcodeScannerPage()),
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
              SlidePageRoute(page: const SearchPage()),
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

            // 快速捷徑 2x2 網格
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                QuickAccessTile(
                  title: '攝入熱量',
                  value: log.totalCalories.round().toString(),
                  unit: 'kcal',
                  icon: Icons.local_fire_department,
                  color: AppTheme.calorieColor,
                  onTap: () {},
                ),
                QuickAccessTile(
                  title: '蛋白質',
                  value: log.totalProtein.round().toString(),
                  unit: 'g',
                  icon: Icons.fitness_center,
                  color: AppTheme.proteinColor,
                  onTap: () {},
                ),
                QuickAccessTile(
                  title: '碳水',
                  value: log.totalCarbs.round().toString(),
                  unit: 'g',
                  icon: Icons.bakery_dining,
                  color: AppTheme.carbsColor,
                  onTap: () {},
                ),
                QuickAccessTile(
                  title: '脂肪',
                  value: log.totalFat.round().toString(),
                  unit: 'g',
                  icon: Icons.opacity,
                  color: AppTheme.fatColor,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 熱量建議區塊
            _CalorieSuggestionCard(
              consumed: log.totalCalories,
              target: target.calories,
            ),

            const SizedBox(height: 24),

            // 快速捷徑
            _QuickShortcuts(),

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
        onPressed: () => _showQuickAddPanel(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showQuickAddPanel(BuildContext context, WidgetRef ref) {
    final favorites = ref.read(favoriteFoodsProvider);
    final topFavorites = favorites.take(5).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _QuickAddPanel(
        favorites: topFavorites,
        onSelectFood: (food) {
          Navigator.pop(ctx);
          _showMealSelectionDialog(context, ref, food);
        },
        onAddNew: () {
          Navigator.pop(ctx);
          Navigator.push(
            context,
            SlidePageRoute(page: const SearchPage()),
          );
        },
      ),
    );
  }

  void _showMealSelectionDialog(BuildContext context, WidgetRef ref, dynamic food) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '新增「${food.name}」到',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppConstants.mealTypes.map((mealType) => ListTile(
              leading: Icon(_getMealIcon(mealType), color: AppTheme.primaryColor),
              title: Text(mealType),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(dailyLogProvider.notifier).addEntry(mealType, food, food.servingSize);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已新增 ${food.name} 到 $mealType')),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case '早餐': return Icons.wb_sunny;
      case '午餐': return Icons.wb_cloudy;
      case '晚餐': return Icons.nightlight_round;
      case '點心': return Icons.cookie;
      default: return Icons.restaurant;
    }
  }

  void _showAddFoodDialog(BuildContext context, WidgetRef ref, String mealType) {
    Navigator.push(
      context,
      SlidePageRoute(page: AddFoodToMealPage(mealType: mealType)),
    );
  }
}

/// 熱量建議卡片
class _CalorieSuggestionCard extends StatelessWidget {
  final double consumed;
  final int target;

  const _CalorieSuggestionCard({
    required this.consumed,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final hasRecord = consumed > 0 || target > 0;
    final remaining = target - consumed;
    final isOver = remaining < 0;
    final overage = isOver ? -remaining : 0.0;

    if (!hasRecord) {
      return const SizedBox.shrink();
    }

    String suggestion;
    Color suggestionColor;
    Color backgroundColor;

    if (isOver) {
      suggestion = '今日熱量已超標 ${overage.round()} kcal';
      suggestionColor = AppTheme.errorColor;
      backgroundColor = AppTheme.errorColor.withOpacity(0.1);
    } else {
      suggestion = NutritionCalculator.mealSuggestion(remaining);
      suggestionColor = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withOpacity(0.1);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOver ? Icons.warning_amber : Icons.lightbulb_outline,
                  color: suggestionColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '熱量建議',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: suggestionColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOver)
                    Text(
                      suggestion,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    )
                  else ...[
                    Text(
                      '今日攝入：${consumed.round()} kcal',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '目標：$target kcal',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      suggestion,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
class _CalorieCard extends StatefulWidget {
  final double consumed;
  final int target;
  final double progress;

  const _CalorieCard({
    required this.consumed,
    required this.target,
    required this.progress,
  });

  @override
  State<_CalorieCard> createState() => _CalorieCardState();
}

class _CalorieCardState extends State<_CalorieCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_CalorieCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _oldProgress = _animation.value;
      _animation = Tween<double>(begin: _oldProgress, end: widget.progress).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.target - widget.consumed;
    final hasRecord = widget.consumed > 0 || widget.target > 0;

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
                              text: widget.consumed.round().toString(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.calorieColor,
                              ),
                            ),
                            TextSpan(
                              text: ' / ${widget.target} kcal',
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
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return CircularProgressIndicator(
                              value: _animation.value.clamp(0.0, 1.0),
                              strokeWidth: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                _animation.value > 1 ? AppTheme.errorColor : AppTheme.primaryColor,
                              ),
                            );
                          },
                        ),
                        Center(
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Text(
                                '${(_animation.value * 100).round()}%',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            },
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

/// 快速捷徑區塊
class _QuickShortcuts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ShortcutCard(
          icon: Icons.search,
          label: '搜尋食物',
          onTap: () => Navigator.push(
            context,
            SlidePageRoute(page: const SearchPage()),
          ),
        ),
        _ShortcutCard(
          icon: Icons.qr_code_scanner,
          label: '掃描條碼',
          onTap: () => Navigator.push(
            context,
            SlidePageRoute(page: const BarcodeScannerPage()),
          ),
        ),
        _ShortcutCard(
          icon: Icons.star,
          label: '我的最愛',
          onTap: () {
            Navigator.push(
              context,
              SlidePageRoute(page: const SearchPage()),
            );
          },
        ),
        _ShortcutCard(
          icon: Icons.monitor_weight,
          label: '記錄體重',
          onTap: () => _showWeightDialog(context, ref),
        ),
      ],
    );
  }

  void _showWeightDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('記錄體重'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '體重 (kg)',
            hintText: '例如：65.5',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(controller.text);
              if (weight != null && weight > 0) {
                ref.read(dailyLogProvider.notifier).updateWeight(weight);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('體重 $weight kg 已記錄')),
                );
              }
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }
}

/// 捷徑卡片
class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShortcutCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

/// 快速新增收藏食物面板
class _QuickAddPanel extends StatelessWidget {
  final List<dynamic> favorites;
  final Function(dynamic) onSelectFood;
  final VoidCallback onAddNew;

  const _QuickAddPanel({
    required this.favorites,
    required this.onSelectFood,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.accentColor),
              const SizedBox(width: 8),
              const Text(
                '我的最愛',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (favorites.isEmpty)
                TextButton(
                  onPressed: onAddNew,
                  child: const Text('新增食物'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (favorites.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.star_border, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('尚無收藏食物', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(
                      '搜尋食物並點擊星星收藏',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            ...favorites.map((food) => ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: AppTheme.accentColor, size: 20),
              ),
              title: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${food.calories.round()} kcal / ${food.servingSize.round()}g',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
              onTap: () => onSelectFood(food),
            )),
          if (favorites.isNotEmpty) ...[
            const Divider(),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.search, color: AppTheme.primaryColor, size: 20),
              ),
              title: const Text('搜尋新食物'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onAddNew,
            ),
          ],
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
