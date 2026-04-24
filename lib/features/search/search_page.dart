import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../data/models/food_item.dart';
import '../../core/theme/app_theme.dart';

/// 食物搜尋頁面
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 自動聚焦到搜尋框
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final favorites = ref.watch(favoriteFoodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: '搜尋食物...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            filled: false,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _onSearch('');
              },
            ),
        ],
      ),
      body: _controller.text.isEmpty
          ? _FavoritesSection(favorites: favorites)
          : results.when(
              data: (foods) => foods.isEmpty
                  ? const _EmptyState(message: '找不到符合的食物\n試試其他關鍵字')
                  : _SearchResults(foods: foods),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _EmptyState(message: '搜尋失敗：$e'),
            ),
    );
  }
}

class _FavoritesSection extends StatelessWidget {
  final List<FoodItem> favorites;

  const _FavoritesSection({required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('還沒有收藏的食物', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('搜尋並加入常用食物', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('我的收藏', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...favorites.map((food) => _FoodListTile(food: food, isFavorite: true)),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<FoodItem> foods;

  const _SearchResults({required this.foods});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) => _FoodListTile(food: foods[index]),
    );
  }
}

class _FoodListTile extends ConsumerWidget {
  final FoodItem food;
  final bool isFavorite;

  const _FoodListTile({required this.food, this.isFavorite = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteFoodsProvider);
    final isFav = favorites.any((f) => f.id == food.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: food.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  food.imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
                ),
              )
            : Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
        title: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${food.brand ?? '一般'} • ${food.calories.round()} kcal/100g',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                _MacroTag(label: '碳', value: food.carbs.round(), color: AppTheme.carbsColor),
                const SizedBox(width: 4),
                _MacroTag(label: '蛋白質', value: food.protein.round(), color: AppTheme.proteinColor),
                const SizedBox(width: 4),
                _MacroTag(label: '脂肪', value: food.fat.round(), color: AppTheme.fatColor),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(isFav ? Icons.star : Icons.star_border,
              color: isFav ? AppTheme.accentColor : Colors.grey),
          onPressed: () => ref.read(favoriteFoodsProvider.notifier).toggleFavorite(food),
        ),
        onTap: () => _showAddDialog(context, ref),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    double grams = 100;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food.name, style: const TextStyle(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('熱量: ${food.calories.round()} kcal / 100g'),
            Text('碳水化合物: ${food.carbs.round()}g / 100g'),
            Text('蛋白質: ${food.protein.round()}g / 100g'),
            Text('脂肪: ${food.fat.round()}g / 100g'),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  Text('份量: ${grams.round()}g'),
                  Slider(
                    value: grams,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    label: '${grams.round()}g',
                    onChanged: (v) => setState(() => grams = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '= ${food.caloriesForServing(grams).round()} kcal',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.calorieColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          const Text('新增到：'),
          ...['早餐', '午餐', '晚餐', '點心'].map(
            (meal) => TextButton(
              onPressed: () {
                ref.read(dailyLogProvider.notifier).addEntry(meal, food, grams);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已新增到 $meal')),
                );
              },
              child: Text(meal),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _MacroTag extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MacroTag({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: ${value}g',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
