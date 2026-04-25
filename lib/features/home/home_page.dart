import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/page_transitions.dart';
import '../../data/models/meal_record.dart';
import 'widgets/macro_rings_widget.dart';
import '../search/search_page.dart';
import '../barcode/barcode_scanner_page.dart';
import '../meal/meal_detail_page.dart';
import 'stats_screen.dart';

/// 首頁儀表板 - FatSecret 風格
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogProvider);
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: const Text(
          '食刻輕卡',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.push(
              context,
              SlidePageRoute(page: const StatsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.push(
              context,
              SlidePageRoute(page: const BarcodeScannerPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 日期選擇列 - FatSecret 風格
            _DateSelector(
              selectedDate: selectedDate,
              onDateChanged: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  // 熱量卡片
                  _CalorieCardFat(
                    consumed: log.totalCalories,
                    target: target.calories,
                    burnedCalories: log.burnedCalories,
                  ),
                  const SizedBox(height: 16),

                  // 營養素三環圖
                  const MacroRingsWidget(),
                  const SizedBox(height: 16),

                  // 快速捷徑 - FatSecret 2x3 網格
                  _QuickAccessGrid(log: log),
                  const SizedBox(height: 16),

                  // 餐次列表
                  _MealSection(
                    mealType: '早餐',
                    meal: log.getMeal('早餐'),
                    onAdd: () => _showAddFoodDialog(context, ref, '早餐'),
                    onRemove: (id) => ref.read(dailyLogProvider.notifier).removeEntry('早餐', id),
                    onTap: () => Navigator.push(context, SlidePageRoute(page: const MealDetailPage(mealType: '早餐'))),
                  ),
                  _MealSection(
                    mealType: '午餐',
                    meal: log.getMeal('午餐'),
                    onAdd: () => _showAddFoodDialog(context, ref, '午餐'),
                    onRemove: (id) => ref.read(dailyLogProvider.notifier).removeEntry('午餐', id),
                    onTap: () => Navigator.push(context, SlidePageRoute(page: const MealDetailPage(mealType: '午餐'))),
                  ),
                  _MealSection(
                    mealType: '晚餐',
                    meal: log.getMeal('晚餐'),
                    onAdd: () => _showAddFoodDialog(context, ref, '晚餐'),
                    onRemove: (id) => ref.read(dailyLogProvider.notifier).removeEntry('晚餐', id),
                    onTap: () => Navigator.push(context, SlidePageRoute(page: const MealDetailPage(mealType: '晚餐'))),
                  ),
                  _MealSection(
                    mealType: '點心',
                    meal: log.getMeal('點心'),
                    onAdd: () => _showAddFoodDialog(context, ref, '點心'),
                    onRemove: (id) => ref.read(dailyLogProvider.notifier).removeEntry('點心', id),
                    onTap: () => Navigator.push(context, SlidePageRoute(page: const MealDetailPage(mealType: '點心'))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => _showQuickAddPanel(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showQuickAddPanel(BuildContext context, WidgetRef ref) {
    final favorites = ref.read(favoriteFoodsProvider);
    final topFavorites = favorites.take(5).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
          Navigator.push(context, SlidePageRoute(page: const SearchPage()));
        },
      ),
    );
  }

  void _showMealSelectionDialog(BuildContext context, WidgetRef ref, dynamic food) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                  SnackBar(
                    content: Text('已新增 ${food.name} 到 $mealType'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
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
    Navigator.push(context, SlidePageRoute(page: AddFoodToMealPage(mealType: mealType)));
  }
}

/// 日期選擇列 - FatSecret 風格
class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DateSelector({required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.subtract(Duration(days: 3 - i)));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 76,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            final isSelected = AppDateUtils.isSameDay(date, selectedDate);
            final isToday = AppDateUtils.isToday(date);

            return GestureDetector(
              onTap: () => onDateChanged(date),
              child: Container(
                width: 52,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
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
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 熱量卡片 - FatSecret 風格（扁平大卡片）
class _CalorieCardFat extends StatelessWidget {
  final double consumed;
  final int target;
  final double burnedCalories;

  const _CalorieCardFat({
    required this.consumed,
    required this.target,
    required this.burnedCalories,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = target - consumed;
    final hasRecord = consumed > 0 || target > 0;
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日攝入',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!hasRecord)
                      const Text(
                        '尚未記錄',
                        style: TextStyle(
                          fontSize: 32,
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
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.calorieColor,
                              ),
                            ),
                            TextSpan(
                              text: ' / $target',
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // 圓環進度
              if (hasRecord)
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          progress > 1 ? AppTheme.errorColor : AppTheme.primaryColor,
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
          if (hasRecord) ...[
            const SizedBox(height: 16),
            // 狀態標籤
            Row(
              children: [
                if (burnedCalories > 0)
                  _StatusTag(
                    icon: Icons.local_fire_department,
                    text: '消耗 $burnedCalories',
                    color: AppTheme.exerciseColor,
                  ),
                const SizedBox(width: 8),
                _StatusTag(
                  icon: remaining >= 0 ? Icons.check_circle : Icons.warning,
                  text: remaining >= 0 ? '還有 $remaining kcal' : '超標 ${-remaining} kcal',
                  color: remaining >= 0 ? AppTheme.primaryColor : AppTheme.errorColor,
                ),
              ],
            ),
          ] else
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _StatusTag({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// 快速存取網格 - FatSecret 2x3
class _QuickAccessGrid extends StatelessWidget {
  final dynamic log;

  const _QuickAccessGrid({required this.log});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '快速記錄',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _QuickAccessCard(
                icon: Icons.search,
                label: '搜尋食物',
                color: AppTheme.primaryColor,
                onTap: () => Navigator.push(
                  context,
                  SlidePageRoute(page: const SearchPage()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAccessCard(
                icon: Icons.qr_code_scanner,
                label: '掃描條碼',
                color: AppTheme.accentColor,
                onTap: () => Navigator.push(
                  context,
                  SlidePageRoute(page: const BarcodeScannerPage()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickAccessCard(
                icon: Icons.fitness_center,
                label: '運動消耗',
                color: AppTheme.exerciseColor,
                onTap: () => Navigator.pushNamed(context, '/exercise'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAccessCard(
                icon: Icons.monitor_weight,
                label: '記錄體重',
                color: AppTheme.carbsColor,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

/// 餐次區塊 - FatSecret 風格
class _MealSection extends StatelessWidget {
  final String mealType;
  final MealRecord meal;
  final VoidCallback onAdd;
  final Function(String) onRemove;
  final VoidCallback onTap;

  const _MealSection({
    required this.mealType,
    required this.meal,
    required this.onAdd,
    required this.onRemove,
    required this.onTap,
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

  Color get _mealColor {
    switch (mealType) {
      case '早餐': return const Color(0xFFFF9800);
      case '午餐': return const Color(0xFF4CAF50);
      case '晚餐': return const Color(0xFF2196F3);
      case '點心': return const Color(0xFFE91E63);
      default: return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _mealColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_mealIcon, color: _mealColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${meal.totalCalories.round()} kcal',
                        style: TextStyle(
                          fontSize: 13,
                          color: meal.totalCalories > 0 ? AppTheme.calorieColor : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: _mealColor),
                  onPressed: onAdd,
                ),
              ],
            ),
            if (meal.entries.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...meal.entries.take(3).map((entry) => _EntryRow(
                entry: entry,
                onDelete: () => onRemove(entry.id),
              )),
              if (meal.entries.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '還有 ${meal.entries.length - 3} 項...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

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
            child: Text(
              entry.food.name,
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${entry.grams.round()}g',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 8),
          Text(
            '${entry.calories.round()}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'kcal',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
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
                '快速新增',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: onAddNew,
                child: const Text('搜尋更多'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (favorites.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.star_border, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    const Text('尚無收藏食物', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            ...favorites.map((food) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.star, color: AppTheme.accentColor, size: 20),
              ),
              title: Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${food.calories.round()} kcal / ${food.servingSize.round()}g',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
              onTap: () => onSelectFood(food),
            )),
        ],
      ),
    );
  }
}

/// 新增食物到餐次的頁面
class AddFoodToMealPage extends ConsumerWidget {
  final String mealType;

  const AddFoodToMealPage({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(preselectedMeal: mealType),
        ),
      );
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: Text('新增到 $mealType'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
