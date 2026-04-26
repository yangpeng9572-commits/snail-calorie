import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/food_item.dart';
import '../../providers/app_providers.dart';
import '../search/search_page.dart';

/// 我的最愛（收藏食物）頁面
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteFoodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的最愛'),
      ),
      body: favorites.isEmpty
          ? const _EmptyFavoritesState()
          : _FavoritesList(favorites: favorites),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

/// 空狀態：顯示插圖 + 提示文字
class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_border,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              '還沒有收藏食物',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '搜尋後按星星加入最愛',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '就可以快速新增到每日餐次',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 收藏列表（支援滑動刪除）
class _FavoritesList extends ConsumerWidget {
  final List<FoodItem> favorites;

  const _FavoritesList({required this.favorites});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final food = favorites[index];
        return Dismissible(
          key: Key(food.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: AppTheme.errorColor,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('移除收藏'),
                content: Text('確定要移除「${food.name}」嗎？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('移除'),
                  ),
                ],
              ),
            ) ?? false;
          },
          onDismissed: (direction) {
            ref.read(favoriteFoodsProvider.notifier).toggleFavorite(food);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已移除「${food.name}」'),
                action: SnackBarAction(
                  label: '復原',
                  onPressed: () {
                    // 重新加入收藏
                    ref.read(favoriteFoodsProvider.notifier).toggleFavorite(food);
                  },
                ),
              ),
            );
          },
          child: _FavoriteFoodCard(food: food),
        );
      },
    );
  }
}

/// 收藏食物卡片
class _FavoriteFoodCard extends ConsumerStatefulWidget {
  final FoodItem food;

  const _FavoriteFoodCard({required this.food});

  @override
  ConsumerState<_FavoriteFoodCard> createState() => _FavoriteFoodCardState();
}

class _FavoriteFoodCardState extends ConsumerState<_FavoriteFoodCard> {
  double _servingSize = 100;

  @override
  void initState() {
    super.initState();
    _servingSize = widget.food.servingSize;
  }

  @override
  Widget build(BuildContext context) {
    final calories = widget.food.caloriesForServing(_servingSize);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 食物圖片或預設圖示
                widget.food.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.food.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _DefaultFoodIcon(),
                        ),
                      )
                    : _DefaultFoodIcon(),
                const SizedBox(width: 12),
                // 食物名稱與品牌
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.food.brand ?? '一般'} • ${widget.food.calories.round()} kcal/100g',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // 星星圖示（已收藏）
                const Icon(
                  Icons.star,
                  color: AppTheme.accentColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 份量選擇
            Row(
              children: [
                Text(
                  '份量：${_servingSize.round()}g',
                  style: const TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: Slider(
                    value: _servingSize,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    onChanged: (value) {
                      setState(() => _servingSize = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 巨量營養素與熱量
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _MacroChip(
                      label: '碳',
                      value: widget.food.carbsForServing(_servingSize).round(),
                      color: AppTheme.carbsColor,
                    ),
                    const SizedBox(width: 6),
                    _MacroChip(
                      label: '蛋白',
                      value: widget.food.proteinForServing(_servingSize).round(),
                      color: AppTheme.proteinColor,
                    ),
                    const SizedBox(width: 6),
                    _MacroChip(
                      label: '脂肪',
                      value: widget.food.fatForServing(_servingSize).round(),
                      color: AppTheme.fatColor,
                    ),
                  ],
                ),
                Text(
                  '${calories.round()} kcal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calorieColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 新增到餐次按鈕
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showMealSelectionDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('新增到餐次'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealSelectionDialog(BuildContext context) {
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
              '新增「${widget.food.name}」到',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppConstants.mealTypes.map((mealType) => ListTile(
              leading: Icon(_getMealIcon(mealType), color: AppTheme.primaryColor),
              title: Text(mealType),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(ctx);
                await ref.read(dailyLogProvider.notifier).addEntry(
                  mealType,
                  widget.food,
                  _servingSize,
                );
                messenger.showSnackBar(
                  SnackBar(content: Text('已新增 ${widget.food.name} 到 $mealType')),
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
}

/// 預設食物圖示
class _DefaultFoodIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.fastfood, color: Colors.grey.shade400),
    );
  }
}

/// 巨量營養素標籤
class _MacroChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MacroChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: ${value}g',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
