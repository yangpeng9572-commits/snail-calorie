import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_providers.dart';
import '../../data/models/meal_photo.dart';
import '../../data/models/food_item.dart';
import '../../core/theme/app_theme.dart';

/// 餐次詳情頁面（支援拍照記錄）
class MealDetailPage extends ConsumerStatefulWidget {
  final String mealType;

  const MealDetailPage({
    super.key,
    required this.mealType,
  });

  @override
  ConsumerState<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends ConsumerState<MealDetailPage> {
  final ImagePicker _picker = ImagePicker();
  List<MealPhoto> _photos = [];
  // ignore: prefer_final_fields
  bool _isLoading = false; // 預留，未來用於非同步載入

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  void _loadPhotos() {
    // 從 dailyLog 中收集該餐次的照片
    final log = ref.read(dailyLogProvider);
    final meal = log.getMeal(widget.mealType);
    final photos = <MealPhoto>[];

    for (final entry in meal.entries) {
      if (entry.photoPath != null) {
        photos.add(MealPhoto(
          mealType: widget.mealType,
          entryId: entry.id, // 關聯 MealEntry ID
          foodId: entry.food.id,
          foodName: entry.food.name,
          photoPath: entry.photoPath!,
          takenAt: entry.loggedAt,
        ));
      }
    }

    setState(() {
      _photos = photos;
    });
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );

      if (image == null) return;

      // 保存到 app documents 目錄
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'meal_${widget.mealType}_$timestamp.jpg';
      final savedPath = '${appDir.path}/$fileName';

      // 複製圖片到 app 目錄
      await File(image.path).copy(savedPath);

      // 顯示新增食物對話框
      if (mounted) {
        _showAddFoodWithPhotoDialog(savedPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('無法開啟相機：$e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );

      if (image == null) return;

      // 保存到 app documents 目錄
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'meal_${widget.mealType}_$timestamp.jpg';
      final savedPath = '${appDir.path}/$fileName';

      // 複製圖片到 app 目錄
      await File(image.path).copy(savedPath);

      // 顯示新增食物對話框
      if (mounted) {
        _showAddFoodWithPhotoDialog(savedPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('無法選擇圖片：$e')),
        );
      }
    }
  }

  void _showAddFoodWithPhotoDialog(String photoPath) {
    showDialog(
      context: context,
      builder: (ctx) => _AddFoodWithPhotoDialog(
        mealType: widget.mealType,
        photoPath: photoPath,
        onFoodAdded: () {
          _loadPhotos();
        },
      ),
    );
  }

  void _showPhotoSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '選擇图片来源',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
              title: const Text('拍攝照片'),
              onTap: () {
                Navigator.pop(ctx);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('從相簿選擇'),
              onTap: () {
                Navigator.pop(ctx);
                _pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  // 暖色增艷矩陣（模擬增加飽和度+暖色調）
  static const List<double> _warmVividMatrix = [
    1.2, 0, 0, 0, 10,   // R 增加
    0, 1.1, 0, 0, 15,   // G 輕微增加
    0, 0, 0.9, 0, -10,  // B 輕微減少（暖色效果）
    0, 0, 0, 1.0, 0,
  ];

  void _viewPhotoDetail(MealPhoto photo) {
    showDialog(
      context: context,
      builder: (ctx) => _PhotoDetailDialog(
        photo: photo,
        warmVividMatrix: _warmVividMatrix,
        onPhotoUpdated: (newPath) {
          // 持久化背景移除後的照片
          if (photo.entryId != null) {
            ref.read(dailyLogProvider.notifier).updateEntryPhoto(
              photo.mealType,
              photo.entryId!,
              newPath,
            );
            _loadPhotos(); // 重新載入照片列表
          }
        },
      ),
    );
  }

  IconData get _mealIcon {
    switch (widget.mealType) {
      case '早餐': return Icons.wb_sunny;
      case '午餐': return Icons.wb_cloudy;
      case '晚餐': return Icons.nightlight_round;
      case '點心': return Icons.cookie;
      default: return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = ref.watch(dailyLogProvider);
    final meal = log.getMeal(widget.mealType);
    final target = ref.watch(userProfileProvider).target;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_mealIcon, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(widget.mealType),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _showPhotoSourceDialog,
            tooltip: '拍攝餐點',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 餐次總結卡片
                  _MealSummaryCard(
                    mealType: widget.mealType,
                    totalCalories: meal.totalCalories,
                    totalCarbs: meal.totalCarbs,
                    totalProtein: meal.totalProtein,
                    totalFat: meal.totalFat,
                    target: target.calories,
                  ),
                  const SizedBox(height: 20),

                  // 照片牆標題
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '📷 餐點照片',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showPhotoSourceDialog,
                        icon: const Icon(Icons.add_a_photo, size: 18),
                        label: const Text('新增'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 照片網格（Thumbnail 顯示）
                  _buildPhotoGrid(),

                  const SizedBox(height: 24),

                  // 食物列表標題
                  const Text(
                    '🍽️ 食物記錄',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 食物列表
                  if (meal.entries.isEmpty)
                    _EmptyMealState(
                      mealType: widget.mealType,
                      onAddFood: () => _showPhotoSourceDialog(),
                    )
                  else
                    ...meal.entries.map((entry) => _FoodEntryCard(
                          entry: entry,
                          mealType: widget.mealType,
                          onPhotoUpdated: () => _loadPhotos(),
                        )),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPhotoSourceDialog,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    if (_photos.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                '尚無照片',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                '點擊下方按鈕拍攝',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final photo = _photos[index];
        return _PhotoThumbnail(
          photo: photo,
          onTap: () => _viewPhotoDetail(photo),
        );
      },
    );
  }
}

/// 餐次總結卡片
class _MealSummaryCard extends StatelessWidget {
  final String mealType;
  final double totalCalories;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;
  final int target;

  const _MealSummaryCard({
    required this.mealType,
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (totalCalories / (target / 4)).clamp(0.0, 1.5) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '本餐熱量',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: totalCalories.round().toString(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.calorieColor,
                              ),
                            ),
                            const TextSpan(
                              text: ' kcal',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          totalCalories > (target / 4) ? AppTheme.errorColor : AppTheme.primaryColor,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroChip(label: '碳水', value: totalCarbs.round(), color: AppTheme.carbsColor),
                _MacroChip(label: '蛋白', value: totalProtein.round(), color: AppTheme.proteinColor),
                _MacroChip(label: '脂肪', value: totalFat.round(), color: AppTheme.fatColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 營養素小晶片
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$label: ${value}g',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// 照片縮圖
class _PhotoThumbnail extends StatelessWidget {
  final MealPhoto photo;
  final VoidCallback onTap;

  const _PhotoThumbnail({
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: photo.id,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(photo.photoPath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    photo.foodName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 空餐次狀態
class _EmptyMealState extends StatelessWidget {
  final String mealType;
  final VoidCallback onAddFood;

  const _EmptyMealState({
    required this.mealType,
    required this.onAddFood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            '尚無食物記錄',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '新增食物並拍攝餐點照片',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddFood,
            icon: const Icon(Icons.camera_alt),
            label: const Text('拍攝餐點'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// 食物 entry 卡片（支援照片顯示）
class _FoodEntryCard extends StatelessWidget {
  final dynamic entry;
  final String mealType;
  final VoidCallback onPhotoUpdated;

  const _FoodEntryCard({
    required this.entry,
    required this.mealType,
    required this.onPhotoUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = entry.photoPath != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 食物縮圖
            if (hasPhoto)
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(entry.photoPath!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.no_food,
                  color: Colors.grey.shade400,
                ),
              ),
            
            // 食物資訊
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.food.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.grams.round()}g',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _MiniMacro(label: '碳', value: entry.carbs.round()),
                      const SizedBox(width: 4),
                      _MiniMacro(label: '蛋白', value: entry.protein.round()),
                      const SizedBox(width: 4),
                      _MiniMacro(label: '脂', value: entry.fat.round()),
                    ],
                  ),
                ],
              ),
            ),

            // 熱量
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.calories.round()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calorieColor,
                  ),
                ),
                const Text(
                  'kcal',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 迷你營養素標籤
class _MiniMacro extends StatelessWidget {
  final String label;
  final int value;

  const _MiniMacro({required this.label, required this.value});

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

/// 新增食物（帶照片）對話框
class _AddFoodWithPhotoDialog extends ConsumerStatefulWidget {
  final String mealType;
  final String photoPath;
  final VoidCallback onFoodAdded;

  const _AddFoodWithPhotoDialog({
    required this.mealType,
    required this.photoPath,
    required this.onFoodAdded,
  });

  @override
  ConsumerState<_AddFoodWithPhotoDialog> createState() =>
      _AddFoodWithPhotoDialogState();
}

class _AddFoodWithPhotoDialogState
    extends ConsumerState<_AddFoodWithPhotoDialog> {
  List<FoodItem> _searchResults = [];
  FoodItem? _selectedFood;
  double _grams = 100;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 照片預覽
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.file(
                File(widget.photoPath),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '新增到 ${widget.mealType}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 食物搜尋框
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '搜尋食物...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      if (value.length >= 2) {
                        _searchFood(value);
                      } else {
                        setState(() {
                          _searchResults = [];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // 份量滑桿
                  if (_selectedFood != null) ...[
                    Text(
                      '份量: ${_grams.round()}g',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Slider(
                      value: _grams,
                      min: 10,
                      max: 500,
                      divisions: 49,
                      label: '${_grams.round()}g',
                      onChanged: (value) {
                        setState(() {
                          _grams = value;
                        });
                      },
                    ),
                    Text(
                      '熱量: ${(_selectedFood!.caloriesForServing(_grams)).round()} kcal',
                      style: const TextStyle(color: AppTheme.calorieColor),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // 動作按鈕
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _selectedFood != null
                            ? () => _addFood()
                            : null,
                        child: const Text('新增'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 搜尋結果列表
            if (_searchResults.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final food = _searchResults[index];
                    final isSelected = _selectedFood?.id == food.id;
                    return ListTile(
                      leading: food.imageUrl != null
                          ? Image.network(
                              food.imageUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                            )
                          : const Icon(Icons.fastfood),
                      title: Text(
                        food.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${food.calories.round()} kcal/100g',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                          : null,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedFood = food;
                          _searchResults = [];
                        });
                      },
                    );
                  },
                ),
              ),

            if (_isSearching)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchFood(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final service = ref.read(foodSearchServiceProvider);
      final results = await service.searchFoods(query);
      setState(() {
        _searchResults = results.all;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _addFood() async {
    if (_selectedFood == null) return;

    // 透過 provider 新增加到日誌
    await ref.read(dailyLogProvider.notifier).addEntryWithPhoto(
          widget.mealType,
          _selectedFood!,
          _grams,
          widget.photoPath,
        );

    widget.onFoodAdded();
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已新增 ${_selectedFood!.name} 到 ${widget.mealType}'),
        ),
      );
    }
  }
}

/// 照片詳情對話框（支援美味濾鏡 + 背景移除）
class _PhotoDetailDialog extends StatefulWidget {
  final MealPhoto photo;
  final List<double> warmVividMatrix;
  final void Function(String newPath)? onPhotoUpdated;

  const _PhotoDetailDialog({
    required this.photo,
    required this.warmVividMatrix,
    this.onPhotoUpdated,
  });

  @override
  State<_PhotoDetailDialog> createState() => _PhotoDetailDialogState();
}

class _PhotoDetailDialogState extends State<_PhotoDetailDialog> {
  bool _isWarmFilterEnabled = false;
  bool _isRemovingBg = false;
  String? _processedPhotoPath;

  @override
  void initState() {
    super.initState();
    _processedPhotoPath = widget.photo.photoPath;
  }

  Future<void> _removeBackground() async {
    setState(() {
      _isRemovingBg = true;
    });

    try {
      final result = await _executeRembg(widget.photo.photoPath);
      if (result != null && mounted) {
        setState(() {
          _processedPhotoPath = result;
          _isRemovingBg = false;
        });
        // 持久化到 MealEntry
        widget.onPhotoUpdated?.call(result);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('背景移除失敗')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('背景移除錯誤：$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRemovingBg = false;
        });
      }
    }
  }

  Future<String?> _executeRembg(String inputPath) async {
    final tmpDir = await getTemporaryDirectory();
    final outputPath = '${tmpDir.path}/nobg_${DateTime.now().millisecondsSinceEpoch}.png';
    final result = await Process.run('python3', [
      '/home/a0938/rembg_remove.py',
      inputPath,
      outputPath,
    ]);
    return result.exitCode == 0 ? outputPath : null;
  }

  @override
  Widget build(BuildContext context) {
    final displayPath = _processedPhotoPath ?? widget.photo.photoPath;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Hero(
                  tag: widget.photo.id,
                  child: ColorFiltered(
                    colorFilter: _isWarmFilterEnabled
                        ? ColorFilter.matrix(widget.warmVividMatrix)
                        : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                    child: Image.file(
                      File(displayPath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 關閉按鈕
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 頂部工具列
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                // 美味濾鏡按鈕
                _ToolButton(
                  icon: _isWarmFilterEnabled ? Icons.filter_alt : Icons.filter_alt_outlined,
                  label: '美味濾鏡',
                  isActive: _isWarmFilterEnabled,
                  onPressed: () {
                    setState(() {
                      _isWarmFilterEnabled = !_isWarmFilterEnabled;
                    });
                  },
                ),
                const SizedBox(width: 8),
                // 去背按鈕
                _ToolButton(
                  icon: Icons.person_remove_outlined,
                  label: '去背',
                  isLoading: _isRemovingBg,
                  onPressed: _isRemovingBg ? null : _removeBackground,
                ),
              ],
            ),
          ),

          // 底部資訊列
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.photo.foodName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(widget.photo.takenAt),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  if (widget.photo.notes != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.photo.notes!,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Loading 覆蓋層
          if (_isRemovingBg)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      '移除背景中...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 工具按鈕元件
class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _ToolButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppTheme.primaryColor.withOpacity(0.8) : Colors.black54,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
