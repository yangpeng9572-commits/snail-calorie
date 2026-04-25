import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/food_item.dart';
import '../../providers/app_providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';

/// 餐次照片牆頁面
class MealPhotoGallery extends ConsumerStatefulWidget {
  const MealPhotoGallery({super.key});

  @override
  ConsumerState<MealPhotoGallery> createState() => _MealPhotoGalleryState();
}

class _MealPhotoGalleryState extends ConsumerState<MealPhotoGallery>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final List<DateTime> _dates = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _pageController = PageController(initialPage: 3);
    
    // Generate 7 days centered around today
    final today = DateTime.now();
    for (int i = -3; i <= 3; i++) {
      _dates.add(today.add(Duration(days: i)));
    }

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
        _updateSelectedDate(_dates[_tabController.index]);
      }
    });
  }

  void _updateSelectedDate(DateTime date) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedDateProvider.notifier).state = date;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📷 拍照記錄'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _dates.map((date) {
            final isToday = AppDateUtils.isToday(date);
            return Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppDateUtils.weekday(date),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? AppTheme.accentColor : null,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _dates.map((date) => _PhotoGrid(date: date)).toList(),
      ),
    );
  }
}

class _PhotoGrid extends ConsumerWidget {
  final DateTime date;

  const _PhotoGrid({required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogProvider);

    // Get photos from all meals for this date
    final List<_MealPhoto> allPhotos = [];
    for (final mealType in AppConstants.mealTypes) {
      final meal = log.getMeal(mealType);
      for (final entry in meal.entries) {
        if (entry.photoPath != null) {
          allPhotos.add(_MealPhoto(
            mealType: mealType,
            photoPath: entry.photoPath!,
            foodName: entry.food.name,
            entryId: entry.id,
            loggedAt: entry.loggedAt,
          ));
        }
      }
    }

    if (allPhotos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_camera, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '${AppDateUtils.formatDate(date)} 尚無照片',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '點擊下方按鈕拍攝餐點照片',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showMealSelectionForPhoto(context, ref),
              icon: const Icon(Icons.camera_alt),
              label: const Text('拍攝餐點'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: allPhotos.length,
            itemBuilder: (context, index) {
              final photo = allPhotos[index];
              return _PhotoTile(photo: photo, date: date);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showMealSelectionForPhoto(context, ref),
            icon: const Icon(Icons.camera_alt),
            label: const Text('拍攝餐點'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }

  void _showMealSelectionForPhoto(BuildContext context, WidgetRef ref) {
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
            const Text(
              '選擇餐次拍攝',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppConstants.mealTypes.map((mealType) => ListTile(
              leading: Icon(_getMealIcon(mealType), color: AppTheme.primaryColor),
              title: Text(mealType),
              onTap: () {
                Navigator.pop(ctx);
                _takePhoto(context, ref, mealType);
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

  Future<void> _takePhoto(BuildContext context, WidgetRef ref, String mealType) async {
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

      // Show dialog to add food entry with photo
      if (context.mounted) {
        _showAddFoodWithPhotoDialog(context, ref, mealType, savedPath);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('無法開啟相機：$e')),
        );
      }
    }
  }

  void _showAddFoodWithPhotoDialog(BuildContext context, WidgetRef ref, String mealType, String photoPath) {
    showDialog(
      context: context,
      builder: (ctx) => _AddFoodWithPhotoDialog(
        mealType: mealType,
        photoPath: photoPath,
      ),
    );
  }
}

class _MealPhoto {
  final String mealType;
  final String photoPath;
  final String foodName;
  final String entryId;
  final DateTime loggedAt;

  _MealPhoto({
    required this.mealType,
    required this.photoPath,
    required this.foodName,
    required this.entryId,
    required this.loggedAt,
  });
}

class _PhotoTile extends StatelessWidget {
  final _MealPhoto photo;
  final DateTime date;

  const _PhotoTile({required this.photo, required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreen(context),
      child: Hero(
        tag: photo.photoPath,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                      bottom: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        photo.mealType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        photo.foodName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Hero(
                    tag: photo.photoPath,
                    child: Image.file(
                      File(photo.photoPath),
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
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
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
                      photo.mealType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      photo.foodName,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(photo.loggedAt),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFoodWithPhotoDialog extends ConsumerStatefulWidget {
  final String mealType;
  final String photoPath;

  const _AddFoodWithPhotoDialog({
    required this.mealType,
    required this.photoPath,
  });

  @override
  ConsumerState<_AddFoodWithPhotoDialog> createState() =>
      _AddFoodWithPhotoDialogState();
}

class _AddFoodWithPhotoDialogState
    extends ConsumerState<_AddFoodWithPhotoDialog> {
  String _searchQuery = '';
  List<FoodItem> _searchResults = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Photo preview
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.file(
                File(widget.photoPath),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
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
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '搜尋食物...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _search();
                    },
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isNotEmpty && _searchResults.isEmpty && !_isSearching)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('找不到食物'),
                    )
                  else if (_isSearching)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    )
                  else
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final food = _searchResults[index];
                          return ListTile(
                            title: Text(food.name),
                            subtitle: Text('${food.calories.round()} kcal'),
                            onTap: () {
                              ref.read(dailyLogProvider.notifier).addEntryWithPhoto(
                                widget.mealType,
                                food,
                                food.servingSize,
                                widget.photoPath,
                              );
                              Navigator.pop(context);
                              Navigator.pop(context); // Close gallery
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('已新增 ${food.name} 到 ${widget.mealType}')),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Delete the photo if cancelled
                      File(widget.photoPath).deleteSync();
                      Navigator.pop(context);
                    },
                    child: const Text('取消'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    if (_searchQuery.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    ref.read(searchQueryProvider.notifier).state = _searchQuery;
    // 直接等待 provider 的未來結果
    try {
      final results = await ref.read(searchResultsProvider.future);
      if (mounted) {
        setState(() {
          _searchResults = results.take(5).toList();
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }
}
