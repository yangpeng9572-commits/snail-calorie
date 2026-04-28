import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'recipe_models.dart';

/// Gemini Function Calling 食譜生成服務
///
/// 使用 google_generative_ai ^0.2.2 的 Function Calling 功能
/// 定義 generate_recipe 工具，確保 JSON 結構 100% 穩定
///
/// 使用方式：
/// ```dart
/// final service = GeminiRecipeGenerationService(apiKey: 'YOUR_API_KEY');
/// final recipe = await service.generateRecipe(['雞蛋', '番茄', '蔥', '蒜']);
/// ```
class GeminiRecipeGenerationService {
  final String apiKey;
  late final GenerativeModel _model;

  /// System Prompt（英文最穩定）
  static const String _systemPrompt = '''
You are a professional nutritionist and chef specializing in Taiwanese and Asian cuisine.
You have access to a local database of 1100+ Taiwanese foods with nutrition data.

Your task: Generate a recipe based on the user's available ingredients.

CRITICAL RULES:
1. You MUST call the generate_recipe function with complete data
2. Use JSON format exactly as specified in the function schema
3. For ingredients, try to match items to the local food database by name when possible
4. Nutrition values should be realistic estimates based on typical Taiwanese food compositions
5. Prefer common Taiwanese cooking methods: stir-fry, steaming, boiling, braising
6. If ingredients are ambiguous, make reasonable assumptions and note them
7. Always provide at least 3 ingredients and 4 instruction steps
8. Difficulty: "easy" for <15min prep, "medium" for 15-30min, "hard" for >30min

OUTPUT LANGUAGE:
- Recipe name and description: Traditional Chinese with English in parentheses
- Ingredients: Chinese names
- Instructions: Step-by-step Chinese
- Nutrition: Numbers only
''';

  /// Function Declaration for generate_recipe
  static final FunctionDeclaration _generateRecipeDeclaration = FunctionDeclaration(
    name: 'generate_recipe',
    description: '根據冰箱食材生成一道適合的食譜，回傳結構化的食譜資料',
    parameters: {
      "type": "object",
      "properties": {
        "recipe_name": {
          "type": "string",
          "description": "食譜名稱（繁體中文）"
        },
        "description": {
          "type": "string",
          "description": "食譜簡短描述"
        },
        "servings": {
          "type": "integer",
          "description": "建議份數"
        },
        "prep_time_minutes": {
          "type": "integer",
          "description": "準備時間（分鐘）"
        },
        "cook_time_minutes": {
          "type": "integer",
          "description": "烹飪時間（分鐘）"
        },
        "difficulty": {
          "type": "string",
          "enum": ["easy", "medium", "hard"],
          "description": "難度等級"
        },
        "ingredients": {
          "type": "array",
          "description": "食材清單",
          "items": {
            "type": "object",
            "properties": {
              "name": {"type": "string", "description": "食材名稱"},
              "amount": {"type": "string", "description": "份量"},
              "unit": {"type": "string", "description": "單位 (g, ml, 杯, 個等)"},
              "is_from_fridge": {
                "type": "boolean",
                "description": "是否來自冰箱食材"
              }
            },
            "required": ["name", "amount", "unit"]
          }
        },
        "instructions": {
          "type": "array",
          "description": "烹飪步驟",
          "items": {"type": "string"}
        },
        "nutrition_per_serving": {
          "type": "object",
          "description": "每份營養資訊",
          "properties": {
            "calories": {"type": "number", "description": "熱量 (kcal)"},
            "protein_g": {"type": "number", "description": "蛋白質 (g)"},
            "carbs_g": {"type": "number", "description": "碳水化合物 (g)"},
            "fat_g": {"type": "number", "description": "脂肪 (g)"}
          },
          "required": ["calories", "protein_g", "carbs_g", "fat_g"]
        },
        "tags": {
          "type": "array",
          "description": "標籤（如：台式、早餐葷、晚餐等）",
          "items": {"type": "string"}
        },
        "matched_foods": {
          "type": "array",
          "description": "對應到本地資料庫的食物ID列表",
          "items": {"type": "string"}
        }
      },
      "required": [
        "recipe_name",
        "ingredients",
        "instructions",
        "nutrition_per_serving"
      ]
    },
  );

  GeminiRecipeGenerationService({required this.apiKey}) {
    _model = GenerativeModel(
      modelName: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
      tools: [
        Tool(functionDeclarations: [_generateRecipeDeclaration]),
      ],
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
      // 安全設定（食譜生成通常安全）
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.blockNone),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.blockNone),
        SafetySetting(HarmCategory.sexual, HarmBlockThreshold.blockNone),
        SafetySetting(HarmCategory.dangerous, HarmBlockThreshold.blockNone),
      ],
    );
  }

  /// 生成食譜
  /// 
  /// [availableIngredients] 冰箱中可用的食材列表
  /// 
  /// 返回 [GeneratedRecipe] 或 null（如果生成失敗）
  Future<GeneratedRecipe?> generateRecipe(
    List<String> availableIngredients,
  ) async {
    if (availableIngredients.isEmpty) {
      debugPrint('GeminiRecipeGenerationService: No ingredients provided');
      return null;
    }

    try {
      final userPrompt =
          '冰箱裡有這些食材：\n${availableIngredients.join(", ")}\n\n請幫我生成一道適合的食譜！';

      final content = Content.text(userPrompt);
      final response = await _model.generateContent([content]);

      // 處理 Function Call 回應
      if (response.functionCalls.isNotEmpty) {
        final functionCall = response.functionCalls.first;

        if (functionCall.name == 'generate_recipe' && functionCall.args != null) {
          try {
            return GeneratedRecipe.fromJson(functionCall.args!);
          } catch (e) {
            debugPrint('Recipe generation parse error: $e');
            debugPrint('Args: ${functionCall.args}');
          }
        }
      }

      // Fallback: 嘗試解析 text 回應（不該發生，但做防呆）
      if (response.text != null && response.text!.isNotEmpty) {
        debugPrint('GeminiRecipeGenerationService: No function call, using text fallback');
        return GeneratedRecipe.fromText(response.text!);
      }

      debugPrint('GeminiRecipeGenerationService: Empty response');
      return null;
    } catch (e) {
      debugPrint('GeminiRecipeGenerationService: API error: $e');
      return null;
    }
  }

  /// 批次生成多道食譜（用於推薦多樣化選擇）
  Future<List<GeneratedRecipe>> generateMultipleRecipes(
    List<String> availableIngredients, {
    int count = 3,
  }) async {
    final results = <GeneratedRecipe>[];
    
    for (var i = 0; i < count; i++) {
      final recipe = await generateRecipe(availableIngredients);
      if (recipe != null) {
        results.add(recipe);
      }
      // 避免 Rate Limit，稍微延遲
      if (i < count - 1) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    
    return results;
  }

  /// 測試 API 連線
  Future<bool> testConnection() async {
    try {
      final testContent = Content.text('生成一道簡單的蛋炒飯食譜');
      final response = await _model.generateContent([testContent]);
      return response.functionCalls.isNotEmpty || (response.text?.isNotEmpty ?? false);
    } catch (e) {
      debugPrint('GeminiRecipeGenerationService: Connection test failed: $e');
      return false;
    }
  }

  void dispose() {
    // Gemini AI SDK 不需要 explicit dispose
  }
}
