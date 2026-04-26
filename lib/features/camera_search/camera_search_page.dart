import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/gemini_food_service.dart';
import '../../data/models/food_item.dart';
import '../../providers/app_providers.dart';

class CameraSearchPage extends ConsumerStatefulWidget {
  const CameraSearchPage({super.key});

  @override
  ConsumerState<CameraSearchPage> createState() => _CameraSearchPageState();
}

class _CameraSearchPageState extends ConsumerState<CameraSearchPage> {
  final _picker = ImagePicker();
  final _geminiService = GeminiFoodService();
  bool _isProcessing = false;
  String? _errorMessage;
  GeminiFoodResult? _analysisResult;
  XFile? _capturedPhoto;
  double _portionGrams = 100;

  /// 四大餐選項
  final List<Map<String, dynamic>> _mealOptions = [
    {'key': 'breakfast', 'label': '早餐', 'icon': Icons.wb_sunny_outlined},
    {'key': 'lunch', 'label': '午餐', 'icon': Icons.wb_sunny},
    {'key': 'dinner', 'label': '晚餐', 'icon': Icons.nights_stay_outlined},
    {'key': 'snack', 'label': '點心', 'icon': Icons.cookie_outlined},
  ];

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo == null) return;
    if (!mounted) return;

    setState(() {
      _capturedPhoto = photo;
      _isProcessing = true;
      _errorMessage = null;
      _analysisResult = null;
    });

    try {
      final result = await _geminiService.analyzeFood(photo.path);
      if (!mounted) return;
      setState(() {
        _analysisResult = result;
        _isProcessing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _addToMeal(String mealKey) async {
    if (_analysisResult == null) return;

    final result = _analysisResult!;

    // 建立 FoodItem（用每 100g 的營養素建立）
    final foodItem = FoodItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result.name,
      calories: result.caloriesPer100g,
      protein: result.protein,
      carbs: result.carbs,
      fat: result.fat,
      servingSize: 100,
    );

    // 透過 Riverpod provider 新增到日誌
    await ref.read(dailyLogProvider.notifier).addEntry(
      mealKey,
      foodItem,
      _portionGrams,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已新增「${result.name}」到${_getMealLabel(mealKey)}（${_portionGrams.toInt()}g）'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  String _getMealLabel(String key) {
    return _mealOptions.firstWhere((m) => m['key'] == key)['label'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拍照辨識食物'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_analysisResult != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _analysisResult = null;
                  _capturedPhoto = null;
                  _errorMessage = null;
                });
                _takePhoto();
              },
              tooltip: '重新拍照',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_analysisResult != null) {
      return _buildResultView();
    }

    if (_isProcessing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('正在分析食物...', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Gemini AI 視覺辨識中',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('拍下食物照片', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            'AI 會自動辨識食物名稱與卡路里',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera),
            label: const Text('拍照'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final result = _analysisResult!;
    final factor = _portionGrams / 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 食物名稱標題
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.restaurant, size: 40, color: AppTheme.primaryColor),
                const SizedBox(height: 8),
                Text(
                  result.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Gemini AI 辨識',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 份量調整
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('份量', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(
                      '${_portionGrams.toInt()} 克',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _portionGrams,
                  min: 10,
                  max: 500,
                  divisions: 49,
                  label: '${_portionGrams.toInt()}g',
                  onChanged: (value) {
                    setState(() => _portionGrams = value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10g', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    Text('500g', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 營養資訊卡片
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('營養資訊（每 100g）', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                _buildNutrientRow('熱量', '${result.caloriesPer100g.toStringAsFixed(0)} kcal', Colors.red),
                _buildNutrientRow('蛋白質', '${result.protein.toStringAsFixed(1)} g', Colors.blue),
                _buildNutrientRow('碳水化合物', '${result.carbs.toStringAsFixed(1)} g', Colors.orange),
                _buildNutrientRow('脂肪', '${result.fat.toStringAsFixed(1)} g', Colors.purple),
                const Divider(height: 24),
                Text(
                  '這份（${_portionGrams.toInt()}g）熱量：${(result.caloriesPer100g * factor).toStringAsFixed(0)} kcal',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 新增到餐點按鈕
          const Text(
            '新增到',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: _mealOptions.map((meal) {
              return ElevatedButton.icon(
                onPressed: () => _addToMeal(meal['key']),
                icon: Icon(meal['icon'], size: 20),
                label: Text(meal['label'], style: const TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 取消按鈕
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 15)),
          ),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
