import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/food_recognition_service.dart';

/// 拍照搜尋頁面
/// 雙軌 ML Kit 食物辨識：
/// 1. ImageLabeler（主要）→ 營養卡片
/// 2. OCR 回退（失敗時）→ 搜尋建議
class CameraSearchPage extends ConsumerStatefulWidget {
  const CameraSearchPage({super.key});

  @override
  ConsumerState<CameraSearchPage> createState() => _CameraSearchPageState();
}

class _CameraSearchPageState extends ConsumerState<CameraSearchPage> {
  final _picker = ImagePicker();
  final _recognitionService = FoodRecognitionService();

  bool _isProcessing = false;
  String? _errorMessage;
  FoodRecognitionResult? _result;

  /// 拍照取得圖片
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo == null) return;
    await _processImage(photo.path);
  }

  /// 從相簿選擇圖片
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;
    await _processImage(image.path);
  }

  /// 處理圖片：雙軌辨識
  Future<void> _processImage(String filePath) async {
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await _recognitionService.recognizeFromImageFile(filePath);

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _result = result;

        if (result != null && result.errorMessage != null) {
          _errorMessage = result.errorMessage;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = '無法分析圖片，請重試';
      });
    }
  }

  /// 新增到餐次
  void _addToMeal() {
    if (_result != null) {
      // 回傳食物名稱，讓上層決定如何處理
      Navigator.of(context).pop(_result!.matchedFoodName);
    }
  }

  /// 手動搜尋
  void _manualSearch() {
    if (_result != null) {
      Navigator.of(context).pop(_result!.matchedFoodName);
    }
  }

  @override
  void dispose() {
    _recognitionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('拍照搜尋'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 載入中
    if (_isProcessing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              '正在分析食物...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '請稍候',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    // 營養卡片結果（成功）
    if (_result != null && _result!.hasNutritionData) {
      return _buildNutritionCard();
    }

    // 錯誤/回退狀態
    return _buildDefaultOrErrorState();
  }

  /// 營養卡片
  Widget _buildNutritionCard() {
    final result = _result!;
    final confidence = result.confidence;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 營養卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 食物名稱
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        result.matchedFoodName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (confidence > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(confidence * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
                if (result.primaryLabel.isNotEmpty &&
                    result.primaryLabel != result.matchedFoodName) ...[
                  const SizedBox(height: 4),
                  Text(
                    result.primaryLabel,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // 熱量（大卡）
                _buildNutrientRow(
                  '熱量',
                  '${result.calories.toStringAsFixed(0)} kcal',
                  AppTheme.calorieColor,
                  Icons.local_fire_department,
                ),
                const SizedBox(height: 12),

                // 三大營養素
                Row(
                  children: [
                    Expanded(
                      child: _buildNutrientChip(
                        '碳水',
                        '${result.carbs.toStringAsFixed(1)}g',
                        AppTheme.carbsColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildNutrientChip(
                        '蛋白',
                        '${result.protein.toStringAsFixed(1)}g',
                        AppTheme.proteinColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildNutrientChip(
                        '脂肪',
                        '${result.fat.toStringAsFixed(1)}g',
                        AppTheme.fatColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '每 100g',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 新增到餐次按鈕
          ElevatedButton.icon(
            onPressed: _addToMeal,
            icon: const Icon(Icons.add),
            label: const Text('新增到餐次'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 返回按鈕
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 營養素 row
  Widget _buildNutrientRow(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  /// 營養素晶片
  Widget _buildNutrientChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 預設 / 錯誤狀態
  Widget _buildDefaultOrErrorState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 頂部按鈕區
          const SizedBox(height: 24),

          // 兩個按鈕：拍照 / 從相簿選擇
          Row(
            children: [
              Expanded(
                child: _buildSourceButton(
                  icon: Icons.camera_alt,
                  label: '拍照',
                  onPressed: _takePhoto,
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSourceButton(
                  icon: Icons.photo_library,
                  label: '從相簿選擇',
                  onPressed: _pickFromGallery,
                  isPrimary: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 說明文字
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.grey.shade600,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  '使用方式',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '拍攝食物包裝、營養標示或食物照片',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // OCR Fallback：搜尋建議
          if (_result != null && _result!.isOcrFallback) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.orange.shade700,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '找不到營養資料',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '建議搜尋: ${_result!.matchedFoodName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _manualSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('搜尋'),
                  ),
                ],
              ),
            ),
          ],

          // 錯誤訊息
          if (_errorMessage != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],

          // 重試按鈕（錯誤時）
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _result = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重試'),
            ),
          ],

          const SizedBox(height: 16),

          // 返回按鈕
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 圖片來源按鈕
  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppTheme.primaryColor : Colors.white,
        foregroundColor: isPrimary ? Colors.white : AppTheme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
