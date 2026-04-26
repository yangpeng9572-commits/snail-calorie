import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../../providers/app_providers.dart';
import '../../data/models/food_item.dart';
import '../../core/theme/app_theme.dart';

/// 食物搜尋頁面
class SearchPage extends ConsumerStatefulWidget {
  final String? preselectedMeal;

  const SearchPage({super.key, this.preselectedMeal});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // 自動聚焦到搜尋框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      // 檢查是否有從 camera search 傳來的食物名稱
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _controller.text = args;
        _onSearch(args);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = query;
      if (query.trim().isNotEmpty) {
        ref.read(localStorageProvider).addSearchHistory(query);
      }
    });
  }

  void _showComingSoonSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('語音輸入功能開發中，敬請期待！🎤'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showVoiceInputDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '語音輸入',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '說出食物名稱，例如「一碗白飯」',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // 語音輸入功能开发中，稍後上線
                    _showComingSoonSnackbar();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('開始輸入'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(List<FoodItem> favorites) {
    final history = ref.read(searchHistoryProvider);

    if (history.isNotEmpty) {
      return CustomScrollView(
        slivers: [
          if (favorites.isNotEmpty) _FavoritesSection(favorites: favorites),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '最近搜尋',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(localStorageProvider).clearSearchHistory();
                        },
                        child: const Text('清除', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: history.map((query) => _HistoryChip(
                      query: query,
                      onTap: () {
                        _controller.text = query;
                        _onSearch(query);
                      },
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return favorites.isEmpty
        ? const _PopularFoodsSection()
        : _FavoritesSection(favorites: favorites);
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final favorites = ref.watch(favoriteFoodsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: '搜尋食物...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: _onSearch,
        ),
        actions: [
          // 麥克風按鈕（語音輸入）
          IconButton(
            icon: const Icon(Icons.mic_none),
            onPressed: () => _showVoiceInputDialog(),
            tooltip: '語音輸入',
          ),
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
          ? _buildEmptyState(favorites)
          : results.when(
              data: (foods) => foods.isEmpty
                  ? const _EmptyState(
                      emoji: '🍽️',
                      message: '找不到食物，試著換個關鍵字',
                    )
                  : _SearchResults(
                      foods: foods,
                      preselectedMeal: widget.preselectedMeal,
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _NetworkError(
                onRetry: () => _onSearch(_controller.text),
              ),
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
  final String? preselectedMeal;

  const _SearchResults({required this.foods, this.preselectedMeal});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) => _AnimatedFoodListTile(
        food: foods[index],
        index: index,
        preselectedMeal: preselectedMeal,
      ),
    );
  }
}

class _AnimatedFoodListTile extends StatefulWidget {
  final FoodItem food;
  final int index;
  final String? preselectedMeal;

  const _AnimatedFoodListTile({required this.food, required this.index, this.preselectedMeal});

  @override
  State<_AnimatedFoodListTile> createState() => _AnimatedFoodListTileState();
}

class _AnimatedFoodListTileState extends State<_AnimatedFoodListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final delay = widget.index * 0.1;
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(delay.clamp(0.0, 0.7), (delay + 0.5).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(delay.clamp(0.0, 0.7), (delay + 0.5).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _FoodListTile(food: widget.food, preselectedMeal: widget.preselectedMeal),
      ),
    );
  }
}

class _FoodListTile extends ConsumerWidget {
  final FoodItem food;
  final bool isFavorite;
  final String? preselectedMeal;

  const _FoodListTile({required this.food, this.isFavorite = false, this.preselectedMeal});

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
        onTap: () => _showAddDialog(context, ref, preselectedMeal),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref, String? preselectedMeal) {
    double grams = 100;
    String? photoPath;

    // 如果有預選餐次，直接新增
    void addToMeal(String meal) {
      if (photoPath != null) {
        ref.read(dailyLogProvider.notifier).addEntryWithPhoto(meal, food, grams, photoPath!);
      } else {
        ref.read(dailyLogProvider.notifier).addEntry(meal, food, grams);
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已新增到 $meal')),
      );
    }

    Future<void> takePhoto(String mealType, void Function(void Function()) setStateInner) async {
      try {
        final picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1280,
          maxHeight: 1280,
          imageQuality: 85,
        );

        if (image == null) return;

        // Save to app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'meal_${mealType}_$timestamp.jpg';
        final savedPath = '${appDir.path}/$fileName';

        // Copy image to app directory
        await File(image.path).copy(savedPath);

        if (context.mounted) {
          setStateInner(() => photoPath = savedPath);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('照片已拍攝')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('無法開啟相機：$e')),
          );
        }
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(food.name, style: const TextStyle(fontSize: 18)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('熱量: ${food.calories.round()} kcal / 100g'),
                Text('碳水化合物: ${food.carbs.round()}g / 100g'),
                Text('蛋白質: ${food.protein.round()}g / 100g'),
                Text('脂肪: ${food.fat.round()}g / 100g'),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, setSliderState) => Column(
                    children: [
                      Text('份量: ${grams.round()}g'),
                      Slider(
                        value: grams,
                        min: 10,
                        max: 500,
                        divisions: 49,
                        label: '${grams.round()}g',
                        onChanged: (v) => setSliderState(() => grams = v),
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
                const SizedBox(height: 16),
                // Photo section
                if (photoPath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(photoPath!),
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => takePhoto(preselectedMeal ?? '早餐', setDialogState),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('重新拍攝'),
                      ),
                      TextButton.icon(
                        onPressed: () => setDialogState(() => photoPath = null),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('移除'),
                      ),
                    ],
                  ),
                ] else ...[
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => takePhoto(preselectedMeal ?? '早餐', setDialogState),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('拍攝餐點'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            if (preselectedMeal != null)
              TextButton(
                onPressed: () => addToMeal(preselectedMeal),
                child: Text('加入 $preselectedMeal'),
              )
            else
              ...['早餐', '午餐', '晚餐', '點心'].map(
                (meal) => TextButton(
                  onPressed: () => addToMeal(meal),
                  child: Text(meal),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String message;

  const _EmptyState({required this.emoji, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '嘗試不同的關鍵字，或使用條碼掃描',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkError extends StatelessWidget {
  final VoidCallback onRetry;

  const _NetworkError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              '網路連線失敗',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '請檢查網路連線後重試',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('重試'),
            ),
          ],
        ),
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
        color: color.withValues(alpha: 0.15),
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

/// 熱門台灣食物區（當沒有收藏時顯示）
class _PopularFoodsSection extends ConsumerWidget {
  const _PopularFoodsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularFoods = _getPopularFoods();
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '🍜 熱門台灣美食',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularFoods.map((food) {
              return ActionChip(
                avatar: const Text('🍴', style: TextStyle(fontSize: 14)),
                label: Text(food.name, style: const TextStyle(fontSize: 13, color: Color(0xFF212121))),
                onPressed: () => _showAddDialogForFood(context, ref, food),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            '🥤 手搖飲料',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getDrinkFoods().map((food) {
              return ActionChip(
                avatar: const Text('🧋', style: TextStyle(fontSize: 14)),
                label: Text(food.name, style: const TextStyle(fontSize: 13, color: Color(0xFF212121))),
                onPressed: () => _showAddDialogForFood(context, ref, food),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            '輸入關鍵字搜尋更多食物 🔍',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<_SimpleFood> _getPopularFoods() {
    return [
      _SimpleFood('雞腿便當', 680, '1盒'),
      _SimpleFood('排骨便當', 720, '1盒'),
      _SimpleFood('滷肉飯', 290, '1碗'),
      _SimpleFood('牛肉麵', 550, '1碗'),
      _SimpleFood('鹹酥雞', 290, '100g'),
      _SimpleFood('小籠包', 250, '100g'),
      _SimpleFood('蚵仔煎', 225, '1份'),
      _SimpleFood('鍋貼', 230, '100g'),
      _SimpleFood('水餃', 200, '100g'),
      _SimpleFood('臭豆腐', 150, '100g'),
      _SimpleFood('肉圓', 200, '1顆'),
      _SimpleFood('豆花', 95, '1碗'),
    ];
  }

  List<_SimpleFood> _getDrinkFoods() {
    return [
      _SimpleFood('珍珠奶茶', 350, '500ml'),
      _SimpleFood('波霸奶茶', 350, '500ml'),
      _SimpleFood('冬瓜茶', 120, '500ml'),
      _SimpleFood('鮮奶茶', 200, '500ml'),
      _SimpleFood('檸檬愛玉', 100, '500ml'),
      _SimpleFood('青茶（無糖）', 5, '500ml'),
      _SimpleFood('豆漿（無糖）', 130, '500ml'),
      _SimpleFood('米漿', 220, '500ml'),
    ];
  }

  void _showAddDialogForFood(BuildContext context, WidgetRef ref, _SimpleFood food) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(food.name, style: const TextStyle(color: Color(0xFF212121))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('熱量: ${food.calories} kcal / ${food.serving}', style: const TextStyle(color: Color(0xFF212121))),
            const SizedBox(height: 4),
            Text(
              '營養素：蛋白質/脂肪/碳水未細分',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Text('新增到：', style: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['早餐', '午餐', '晚餐', '點心'].map(
                (meal) => ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    final foodItem = food.toFoodItem();
                    ref.read(dailyLogProvider.notifier).addEntry(meal, foodItem, foodItem.servingSize);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已新增 ${food.name} 到 $meal（${food.calories} kcal）')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(meal),
                ),
              ).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _SimpleFood {
  final String name;
  final int calories;
  final String serving;
  _SimpleFood(this.name, this.calories, this.serving);

  /// 轉換為 FoodItem（用於新增到記錄）
  FoodItem toFoodItem() {
    return FoodItem(
      id: 'popular_${name.hashCode}',
      name: name,
      brand: '一般',
      calories: calories.toDouble(),
      // 依熱量比例估算三大營養素（保守估算）
      carbs: (calories * 0.50 / 4).roundToDouble(),
      protein: (calories * 0.25 / 4).roundToDouble(),
      fat: (calories * 0.25 / 9).roundToDouble(),
      servingSize: _parseServing(serving),
    );
  }

  double _parseServing(String s) {
    final match = RegExp(r'(\d+)').firstMatch(s);
    if (match != null) {
      return (int.tryParse(match.group(1)!) ?? 100).toDouble();
    }
    return 100;
  }
}

/// 搜尋歷史 Chip 元件
class _HistoryChip extends StatelessWidget {
  final String query;
  final VoidCallback onTap;

  const _HistoryChip({required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 14,
              color: AppTheme.primaryColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              query,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
