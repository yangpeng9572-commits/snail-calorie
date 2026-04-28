import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/food_item.dart';
import '../models/hybrid_recognition_result.dart';
import '../../core/config/api_keys.dart';
import 'taiwanese_food_database.dart';

/// 混合食物辨識服務
/// 整合三種辨識來源：
/// 1. Gemini AI（雲端，高精確度）
/// 2. ML Kit（離線，透過文字辨識）
/// 3. 本地資料庫（完全離線，台灣食物為主）
///
/// 優先順序：
/// - 有網路 + API Key → Gemini AI
/// - 無網路 → ML Kit + 本地資料庫
/// - ML Kit 無法辨識 → 本地資料庫關鍵字比對
class HybridFoodRecognitionService {
  static const String _modelName = 'models/gemini-1.5-flash';
  static const Duration _timeout = Duration(seconds: 30);

  late final GenerativeModel? _geminiModel;
  late final TextRecognizer _textRecognizer;
  final TaiwaneseFoodDatabase _localDb = TaiwaneseFoodDatabase();

  bool _isGeminiAvailable = false;

  /// API Key 是否已設定
  bool get isApiKeyConfigured =>
      ApiKeys.geminiApiKey.isNotEmpty &&
      !ApiKeys.geminiApiKey.startsWith('AIzaSy...');

  /// Gemini AI 是否可用（需要 API Key 且有網路）
  bool get isGeminiAvailable => _isGeminiAvailable && isApiKeyConfigured;

  HybridFoodRecognitionService() {
    _textRecognizer = TextRecognizer();
    _initGemini();
  }

  void _initGemini() {
    if (isApiKeyConfigured) {
      try {
        _geminiModel = GenerativeModel(
          model: _modelName,
          apiKey: ApiKeys.geminiApiKey,
        );
        _isGeminiAvailable = true;
      } catch (e) {
        debugPrint('HybridFoodRecognitionService: Failed to init Gemini: $e');
        _geminiModel = null;
        _isGeminiAvailable = false;
      }
    } else {
      _geminiModel = null;
      _isGeminiAvailable = false;
    }
  }

  /// 主要辨識方法：自動選擇最佳可用來源
  ///
  /// [imagePath] 圖片路徑
  /// [diningContext] 用餐情境（breakfast/lunch/dinner/snack），用於 ML Kit 情境推斷
  /// 回傳 [HybridRecognitionResult]，可從 source 屬性判斷資料來源
  Future<HybridRecognitionResult?> recognizeFood(
    String imagePath, {
    String diningContext = 'lunch',
  }) async {
    try {
      // 優先使用 Gemini AI
      if (isGeminiAvailable) {
        final result = await _recognizeWithGemini(imagePath);
        if (result != null) {
          debugPrint('HybridFoodRecognitionService: Using Gemini AI');
          return result;
        }
      }

      // Fallback: ML Kit + 本地資料庫
      debugPrint('HybridFoodRecognitionService: Falling back to ML Kit + Local DB');
      return await _recognizeWithMlKitAndLocal(imagePath, diningContext);
    } catch (e) {
      debugPrint('HybridFoodRecognitionService: Error during recognition: $e');
      // 最後一道防線：嘗試本地資料庫
      return await _recognizeWithLocalDatabaseOnly('食物');
    }
  }

  /// 使用 Gemini AI 進行食物辨識
  Future<HybridRecognitionResult?> _recognizeWithGemini(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('圖片檔案不存在：$imagePath');
      }

      final bytes = await file.readAsBytes();

      const prompt = '''
請分析這張食物圖片，並以 JSON 格式回傳營養資訊。

回應格式：
{
  "name": "食物名稱",
  "calories_per_100g": 熱量(大卡),
  "protein": 蛋白質(克),
  "carbs": 碳水化合物(克),
  "fat": 脂肪(克)
}

注意：
1. 熱量單位是每100克的「大卡」
2. 如果無法確定，請根據常見食物類型提供合理估算
3. 只回傳 JSON，不要有其他文字
''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ]),
      ];

      final response =
          await _geminiModel!.generateContent(content).timeout(_timeout);

      if (response.text == null || response.text!.isEmpty) {
        return null;
      }

      return _parseGeminiResponse(response.text!);
    } on TimeoutException {
      throw Exception('分析超時，請檢查網路連線後重試');
    } catch (e) {
      debugPrint('HybridFoodRecognitionService: Gemini error: $e');
      return null;
    }
  }

  /// 解析 Gemini 回應
  HybridRecognitionResult? _parseGeminiResponse(String responseText) {
    try {
      String jsonStr = responseText.trim();

      // 移除可能的 markdown 代码块标记
      if (jsonStr.contains('```json')) {
        jsonStr = jsonStr.split('```json')[1].split('```')[0];
      } else if (jsonStr.contains('```')) {
        jsonStr = jsonStr.split('```')[1].split('```')[0];
      }

      jsonStr = jsonStr.trim();

      final json = Map<String, dynamic>.from(
        jsonDecode(jsonStr) as Map,
      );

      return HybridRecognitionResult.fromGeminiResult(
        name: json['name'] as String? ?? '未知食物',
        caloriesPer100g: (json['calories_per_100g'] as num?)?.toDouble() ?? 0,
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
      );
    } catch (e) {
      debugPrint('HybridFoodRecognitionService: JSON parse error: $e');
      return null;
    }
  }

  /// 使用 ML Kit 文字辨識 + 本地資料庫
  Future<HybridRecognitionResult?> _recognizeWithMlKitAndLocal(
    String imagePath,
    String diningContext,
  ) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        debugPrint('HybridFoodRecognitionService: No text recognized by ML Kit');
        return _recognizeWithLocalDatabaseOnly('食物');
      }

      debugPrint('HybridFoodRecognitionService: ML Kit recognized: ${recognizedText.text}');

      // 尝试在本地数据库中查找匹配的食物
      final matchedFood = _findBestMatchInLocalDb(recognizedText.text);
      if (matchedFood != null) {
        return matchedFood;
      }

      // 如果没找到匹配，返回本地数据库中的默认推荐
      return _getDefaultRecommendation(diningContext);
    } catch (e) {
      debugPrint('HybridFoodRecognitionService: ML Kit error: $e');
      return _recognizeWithLocalDatabaseOnly('食物');
    }
  }

  /// 在本地資料庫中查找最佳匹配
  HybridRecognitionResult? _findBestMatchInLocalDb(String recognizedText) {
    final lowerText = recognizedText.toLowerCase();

    // 常用食物關鍵詞對應
    final keywordMappings = <String, List<String>>{
      '雞腿': ['雞腿便當', '炸雞腿', '滷雞腿'],
      '排骨': ['排骨便當', '炸排骨'],
      '爌肉': ['爌肉飯', '控肉便當'],
      '滷肉': ['滷肉飯', '肉燥飯'],
      '牛肉麵': ['牛肉麵', '紅燒牛肉麵', '番茄牛肉麵'],
      '陽春麵': ['陽春麵', '陽春湯麵'],
      '蛋餅': ['蛋餅', '火腿蛋餅', '玉米蛋餅', '肉鬆蛋餅', '鮪魚蛋餅'],
      '吐司': ['烤吐司', '法式吐司', '肉蛋吐司'],
      '三明治': ['三明治', '火腿蛋三明治', '雞蛋沙拉三明治'],
      '便當': ['雞腿便當', '排骨便當', '控肉便當', '雞排便當'],
      '麵線': ['蚵仔麵線'],
      '小籠包': ['小籠包'],
      '珍珠奶茶': ['珍珠奶茶'],
      '蚵仔': ['蚵仔麵線', '蚵仔煎', '蚵仔炒麵'],
      '水煎包': ['水煎包'],
      '蔥油餅': ['蔥油餅'],
      '臭豆腐': ['臭豆腐'],
      '滷味': ['滷味'],
      '鹹酥雞': ['鹹酥雞'],
      '炸雞': ['炸雞', '炸雞腿'],
      '炒飯': ['炒飯'],
      '炒麵': ['炒麵', '海鮮炒麵'],
      '燴飯': ['燴飯'],
      '咖哩': ['咖哩飯', '咖哩麵'],
      '鍋貼': ['鍋貼', '水餃'],
      '水餃': ['水餃', '鍋貼'],
      '餛飩': ['餛飩麵', '餛飩湯'],
      '粥': ['皮蛋瘦肉粥', '地瓜粥', '吻仔魚粥'],
      '飯糰': ['飯糰'],
      '漢堡': ['漢堡'],
      '薯條': ['薯條', '薯餅'],
      '披薩': ['披薩'],
      '義大利麵': ['義大利麵', '義麵'],
      '沙拉': ['沙拉'],
      '湯': ['玉米濃湯', '蛋花湯'],
    };

    // 遍歷關鍵詞找匹配
    for (final entry in keywordMappings.entries) {
      if (lowerText.contains(entry.key)) {
        // 嘗試在本地資料庫找第一個匹配的食物
        for (final foodName in entry.value) {
          final food = TaiwaneseFoodDatabase.searchByName(foodName);
          if (food != null) {
            return HybridRecognitionResult.fromFoodItem(
              name: food.name,
              caloriesPer100g: food.calories,
              protein: food.protein,
              carbs: food.carbs,
              fat: food.fat,
              notes: 'ML Kit 文字辨識 "${entry.key}" 匹配',
            );
          }
        }
      }
    }

    // 尝试直接搜索
    final allWords = lowerText.split(RegExp(r'[\s,，。、]+'));
    for (final word in allWords) {
      if (word.length >= 2) {
        final food = TaiwaneseFoodDatabase.searchByName(word);
        if (food != null) {
          return HybridRecognitionResult.fromFoodItem(
            name: food.name,
            caloriesPer100g: food.calories,
            protein: food.protein,
            carbs: food.carbs,
            fat: food.fat,
            notes: 'ML Kit 關鍵字 "$word" 匹配',
          );
        }
      }
    }

    return null;
  }

  /// 純本地資料庫辨識（無網路、無 ML Kit 結果）
  Future<HybridRecognitionResult?> _recognizeWithLocalDatabaseOnly(
    String fallbackQuery,
  ) async {
    // 根據用餐情境返回推薦
    return _getDefaultRecommendation('lunch');
  }

  /// 根據用餐情境取得預設推薦
  HybridRecognitionResult _getDefaultRecommendation(String diningContext) {
    // 返回一個通用的高熱量食物作為預設
    const defaultFood = FoodItem(
      id: 'default_001',
      name: '便當',
      brand: '混合主食',
      calories: 650,
      protein: 25,
      carbs: 70,
      fat: 28,
      servingSize: 700,
    );

    return HybridRecognitionResult.fromFoodItem(
      name: defaultFood.name,
      caloriesPer100g: defaultFood.calories,
      protein: defaultFood.protein,
      carbs: defaultFood.carbs,
      fat: defaultFood.fat,
      notes: '根據情境推薦（無網路模式）',
    );
  }

  /// 測試 Gemini API 連線
  Future<bool> testGeminiConnection() async {
    if (!isApiKeyConfigured) return false;

    try {
      final testContent = Content.multi([
        TextPart('回傳 {"status": "ok"}'),
      ]);
      final response =
          await _geminiModel!.generateContent([testContent]).timeout(_timeout);
      return response.text != null && response.text!.contains('ok');
    } catch (e) {
      debugPrint('HybridFoodRecognitionService: Connection test failed: $e');
      return false;
    }
  }

  /// 釋放資源
  void dispose() {
    _textRecognizer.close();
  }
}
