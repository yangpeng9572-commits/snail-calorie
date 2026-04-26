import 'dart:collection';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/food_item.dart';
import 'taiwanese_food_database.dart';
import 'open_food_facts_service.dart';

/// 食物圖片辨識結果
class FoodRecognitionResult {
  final String matchedFoodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double confidence;
  final String primaryLabel;
  final bool isExactMatch;
  final bool isFromOcr;
  final String? errorMessage;

  const FoodRecognitionResult({
    required this.matchedFoodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.confidence,
    required this.primaryLabel,
    required this.isExactMatch,
    this.isFromOcr = false,
    this.errorMessage,
  });

  /// 是否成功取得營養資料
  bool get hasNutritionData => isExactMatch && !isFromOcr;

  /// 是否是從 OCR 回退取得
  bool get isOcrFallback => isFromOcr;

  @override
  String toString() =>
      'FoodRecognitionResult(name: $matchedFoodName, calories: $calories, '
      'protein: $protein, carbs: $carbs, fat: $fat, '
      'confidence: $confidence, primaryLabel: $primaryLabel, '
      'isExactMatch: $isExactMatch, isFromOcr: $isFromOcr)';
}

/// 食物圖片辨識服務
/// 雙軌制：ML Kit ImageLabeler（主要）→ OCR 回退（失敗時）
class FoodRecognitionService {
  static const double _confidenceThreshold = 0.3;
  static const int _maxCacheEntries = 50;
  static const Duration _cacheDuration = Duration(minutes: 30);

  final OpenFoodFactsService _openFoodFactsService;
  late final ImageLabeler _imageLabeler;

  // 快取：使用 LinkedHashMap 保持插入順序
  final LinkedHashMap<String, _CacheEntry> _cache = LinkedHashMap();

  FoodRecognitionService({
    OpenFoodFactsService? openFoodFactsService,
  })  : _openFoodFactsService = openFoodFactsService ?? OpenFoodFactsService() {
    final options = ImageLabelerOptions(confidenceThreshold: _confidenceThreshold);
    _imageLabeler = ImageLabeler(options: options);
  }

  /// 從圖片檔案路徑辨識食物（雙軌制）
  /// 先嘗試 ImageLabeler，失敗時回退到 OCR
  Future<FoodRecognitionResult?> recognizeFromImageFile(String imagePath) async {
    final cacheKey = _getCacheKey(imagePath);
    final cached = _getFromCache(cacheKey);
    if (cached != null) return cached;

    // Step 1: 嘗試 ImageLabeler（主要追蹤）
    final labelResult = await _recognizeWithImageLabeler(imagePath, cacheKey);
    if (labelResult != null && labelResult.hasNutritionData) {
      _addToCache(cacheKey, labelResult);
      return labelResult;
    }

    // Step 2: ImageLabeler 失敗或無營養資料，回退到 OCR
    final ocrResult = await _recognizeWithOcr(imagePath);
    if (ocrResult != null) {
      _addToCache(cacheKey, ocrResult);
    }
    return ocrResult;
  }

  /// 從 InputImage 物件辨識食物
  Future<FoodRecognitionResult?> recognizeFromInputImage(InputImage inputImage) async {
    final cacheKey = _hashString(inputImage.filePath ?? inputImage.hashCode.toString());
    final cached = _getFromCache(cacheKey);
    if (cached != null) return cached;

    return _recognizeFromInputImageInternal(inputImage, cacheKey);
  }

  /// 主要追蹤：使用 ML Kit ImageLabeler 辨識食物
  Future<FoodRecognitionResult?> _recognizeWithImageLabeler(
    String imagePath,
    String cacheKey,
  ) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      return await _recognizeFromInputImageInternal(inputImage, cacheKey);
    } catch (e) {
      return null;
    }
  }

  /// 從 InputImage 內部處理
  Future<FoodRecognitionResult?> _recognizeFromInputImageInternal(
    InputImage inputImage,
    String cacheKey,
  ) async {
    try {
      final labels = await _imageLabeler.processImage(inputImage);
      if (labels.isEmpty) return null;

      // 取最高的 3 個標籤
      final topLabels = labels.take(3).toList();

      // 嘗試在資料庫中匹配
      final result = await _matchLabelsWithDatabase(topLabels);
      if (result != null) {
        return result;
      }

      // 無匹配時，使用最高置信度的標籤回傳部分結果
      final topLabel = topLabels.first;
      final estimatedResult = _createPartialResult(topLabel);
      return estimatedResult;
    } catch (e) {
      return null;
    }
  }

  /// 回退追蹤：使用 OCR 文字辨識提取食物名稱
  Future<FoodRecognitionResult?> _recognizeWithOcr(String imagePath) async {
    try {
      final textRecognizer = TextRecognizer();
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognized = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      // 提取所有非空行並選擇最長的行（通常是食物名稱）
      final lines = recognized.text
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        return const FoodRecognitionResult(
          matchedFoodName: '',
          calories: 0,
          protein: 0,
          carbs: 0,
          fat: 0,
          confidence: 0,
          primaryLabel: '',
          isExactMatch: false,
          isFromOcr: true,
          errorMessage: '找不到文字，請拍攝食物包裝上的文字或標籤',
        );
      }

      // 選擇最長的行通常是最完整的食物名稱
      final foodName = lines.reduce((a, b) => a.length > b.length ? a : b).trim();

      // 嘗試搜尋 API
      final searchResults = await _openFoodFactsService.searchFoods(foodName, pageSize: 5);

      if (searchResults.isNotEmpty) {
        final food = searchResults.first;
        return FoodRecognitionResult(
          matchedFoodName: food.name,
          calories: food.calories,
          protein: food.protein,
          carbs: food.carbs,
          fat: food.fat,
          confidence: 0.5, // OCR 沒有置信度
          primaryLabel: foodName,
          isExactMatch: true,
          isFromOcr: true,
        );
      }

      // 找不到營養資料，回傳食物名稱供手動搜尋
      return FoodRecognitionResult(
        matchedFoodName: foodName,
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
        confidence: 0,
        primaryLabel: foodName,
        isExactMatch: false,
        isFromOcr: true,
        errorMessage: '找不到營養資料，建議搜尋: $foodName',
      );
    } catch (e) {
      return null;
    }
  }

  /// 將標籤與資料庫進行匹配
  Future<FoodRecognitionResult?> _matchLabelsWithDatabase(
    List<ImageLabel> labels,
  ) async {
    FoodItem? bestMatch;
    double bestConfidence = 0.0;
    String bestLabel = '';

    for (final label in labels) {
      final labelText = label.label.toLowerCase();

      // 先在台灣食物資料庫中搜尋
      final twMatch = _findBestMatchInTaiwaneseDb(labelText, label.confidence);
      if (twMatch != null && twMatch.$2 > bestConfidence) {
        bestMatch = twMatch.$1;
        bestConfidence = twMatch.$2;
        bestLabel = label.label;
      }

      // 在 Open Food Facts 中搜尋
      final offMatch = await _findBestMatchInOpenFoodFacts(labelText, label.confidence);
      if (offMatch != null && offMatch.$2 > bestConfidence) {
        bestMatch = offMatch.$1;
        bestConfidence = offMatch.$2;
        bestLabel = label.label;
      }
    }

    if (bestMatch != null) {
      return FoodRecognitionResult(
        matchedFoodName: bestMatch.name,
        calories: bestMatch.calories,
        protein: bestMatch.protein,
        carbs: bestMatch.carbs,
        fat: bestMatch.fat,
        confidence: bestConfidence,
        primaryLabel: bestLabel,
        isExactMatch: true,
        isFromOcr: false,
      );
    }

    return null;
  }

  /// 在台灣食物資料庫中找最佳匹配
  (FoodItem, double)? _findBestMatchInTaiwaneseDb(String labelText, double baseConfidence) {
    FoodItem? bestMatch;
    double bestScore = 0.0;

    final foods = TaiwaneseFoodDatabase.getAll();

    for (final food in foods) {
      final foodName = food.name.toLowerCase();
      final score = _calculateMatchScore(labelText, foodName);

      if (score > bestScore) {
        bestScore = score;
        bestMatch = food;
      }
    }

    // 只有當匹配分數超過閾值時才回傳
    if (bestMatch != null && bestScore >= 0.4) {
      // 結合原始置信度與匹配分數
      final combinedConfidence = (baseConfidence + bestScore) / 2;
      return (bestMatch, combinedConfidence);
    }

    return null;
  }

  /// 在 Open Food Facts 中找最佳匹配
  Future<(FoodItem, double)?> _findBestMatchInOpenFoodFacts(
    String labelText,
    double baseConfidence,
  ) async {
    try {
      final results = await _openFoodFactsService.searchFoods(labelText, pageSize: 10);
      if (results.isEmpty) return null;

      FoodItem? bestMatch;
      double bestScore = 0.0;

      for (final food in results) {
        final foodName = food.name.toLowerCase();
        final score = _calculateMatchScore(labelText, foodName);

        if (score > bestScore) {
          bestScore = score;
          bestMatch = food;
        }
      }

      if (bestMatch != null && bestScore >= 0.4) {
        final combinedConfidence = (baseConfidence + bestScore) / 2;
        return (bestMatch, combinedConfidence);
      }
    } catch (_) {
      // 忽略錯誤
    }

    return null;
  }

  /// 計算匹配分數（模糊匹配）
  double _calculateMatchScore(String label, String foodName) {
    // 精確包含
    if (foodName.contains(label)) return 0.9;
    if (label.contains(foodName)) return 0.85;

    // 標籤是食物名稱的一部分
    if (foodName.contains(label)) return 0.8;

    // 單詞級別匹配
    final labelWords = label.split(RegExp(r'[\s\-_,;]+'));
    final foodWords = foodName.split(RegExp(r'[\s\-_,;]+'));

    int matchedWords = 0;
    for (final lw in labelWords) {
      for (final fw in foodWords) {
        if (lw.isNotEmpty && (fw.contains(lw) || lw.contains(fw))) {
          matchedWords++;
          break;
        }
      }
    }

    if (labelWords.isNotEmpty) {
      final wordScore = matchedWords / labelWords.length;
      if (wordScore > 0) return 0.4 + (wordScore * 0.3);
    }

    // 簡單的編輯距離
    final distanceScore = 1 - (_levenshteinDistance(label, foodName) / foodName.length);
    if (distanceScore > 0.6) return distanceScore * 0.5;

    return 0.0;
  }

  /// 計算 Levenshtein 編輯距離
  int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final rows = s1.length + 1;
    final cols = s2.length + 1;

    List<int> prevRow = List.generate(cols, (j) => j);
    List<int> currRow = List.filled(cols, 0);

    for (int i = 1; i < rows; i++) {
      currRow[0] = i;
      for (int j = 1; j < cols; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        currRow[j] = [
          prevRow[j] + 1,
          currRow[j - 1] + 1,
          prevRow[j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
      final temp = prevRow;
      prevRow = currRow;
      currRow = temp;
    }

    return prevRow[s2.length];
  }

  /// 當沒有匹配時，建立部分結果
  FoodRecognitionResult _createPartialResult(ImageLabel topLabel) {
    return FoodRecognitionResult(
      matchedFoodName: topLabel.label,
      calories: 200.0, // 預設估算
      protein: 10.0,
      carbs: 25.0,
      fat: 8.0,
      confidence: topLabel.confidence,
      primaryLabel: topLabel.label,
      isExactMatch: false,
      isFromOcr: false,
      errorMessage: '找不到營養資料，建議搜尋: ${topLabel.label}',
    );
  }

  // ==================== 快取機制 ====================

  String _getCacheKey(String filePath) => _hashString(filePath);

  String _hashString(String input) {
    int hash = 5381;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) + hash) + input.codeUnitAt(i);
    }
    return hash.toUnsigned(32).toRadixString(16);
  }

  FoodRecognitionResult? _getFromCache(String cacheKey) {
    final entry = _cache[cacheKey];
    if (entry == null) return null;

    if (DateTime.now().difference(entry.timestamp) > _cacheDuration) {
      _cache.remove(cacheKey);
      return null;
    }

    return entry.result;
  }

  void _addToCache(String cacheKey, FoodRecognitionResult result) {
    if (_cache.length >= _maxCacheEntries) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }

    _cache[cacheKey] = _CacheEntry(
      result: result,
      timestamp: DateTime.now(),
    );
  }

  /// 清除所有快取
  void clearCache() => _cache.clear();

  /// 釋放資源
  void dispose() {
    _imageLabeler.close();
    _openFoodFactsService.dispose();
  }
}

class _CacheEntry {
  final FoodRecognitionResult result;
  final DateTime timestamp;

  _CacheEntry({required this.result, required this.timestamp});
}
