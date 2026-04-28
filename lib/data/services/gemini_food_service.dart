import 'dart:convert';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/config/api_keys.dart';

/// Gemini 食物分析服務
/// 使用 Gemini 1.5 Flash 模型分析食物圖片並回傳營養資訊
class GeminiFoodService {
  static const String _modelName = 'models/gemini-1.5-flash';
  static const Duration _timeout = Duration(seconds: 30);

  late final GenerativeModel _model;

  GeminiFoodService() {
    _model = GenerativeModel(
      model: _modelName,
      apiKey: ApiKeys.geminiApiKey,
    );
  }

  /// 分析食物圖片並回傳營養資訊
  ///
  /// [imagePath] 圖片檔案路徑（支援 Android content URI 和檔案路徑）
  /// 回傳 [GeminiFoodResult] 包含食物名稱和營養資訊
  Future<GeminiFoodResult> analyzeFood(String imagePath) async {
    try {
      // XFile.path 在 Android 上可能是 content URI，無法用 File() 直接讀取
      // 使用 XFile.readAsBytes() 可以正確處理所有平台的所有 URI 類型
      final xfile = XFile(imagePath);
      final bytes = await xfile.readAsBytes();

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

      final response = await _model.generateContent(content).timeout(_timeout);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Gemini 回應為空，請重試');
      }

      return _parseGeminiResponse(response.text!);
    } on TimeoutException {
      throw Exception('分析超時，請檢查網路連線後重試');
    } catch (e) {
      if (e.toString().contains('API_KEY')) {
        throw Exception('API 密鑰無效，請聯繫開發者');
      }
      if (e.toString().contains('QUOTA')) {
        throw Exception('API 配額已用完，請明天再試');
      }
      rethrow;
    }
  }

  /// 解析 Gemini 回應的 JSON
  GeminiFoodResult _parseGeminiResponse(String responseText) {
    try {
      // 嘗試提取 JSON 區塊
      String jsonStr = responseText.trim();

      // 移除可能的 markdown 代码块标记
      if (jsonStr.contains('```json')) {
        jsonStr = jsonStr.split('```json')[1].split('```')[0];
      } else if (jsonStr.contains('```')) {
        jsonStr = jsonStr.split('```')[1].split('```')[0];
      }

      jsonStr = jsonStr.trim();

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      return GeminiFoodResult(
        name: json['name'] as String? ?? '未知食物',
        caloriesPer100g: (json['calories_per_100g'] as num?)?.toDouble() ?? 0,
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
      );
    } catch (e) {
      throw Exception('解析回應失敗，請重試：${e.toString()}');
    }
  }
}

/// Gemini 食物分析結果
class GeminiFoodResult {
  final String name;
  final double caloriesPer100g;
  final double protein;
  final double carbs;
  final double fat;

  GeminiFoodResult({
    required this.name,
    required this.caloriesPer100g,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  String toString() {
    return 'GeminiFoodResult(name: $name, calories: $caloriesPer100g, protein: $protein, carbs: $carbs, fat: $fat)';
  }
}
