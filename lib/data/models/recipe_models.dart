/// 食譜生成 - Dart 資料模型
/// 配合 Gemini Function Calling 使用

import 'dart:convert';

/// 食材項目
class RecipeIngredient {
  final String name;
  final String amount;
  final String unit;
  final bool isFromFridge;

  const RecipeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
    this.isFromFridge = true,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'unit': unit,
        'is_from_fridge': isFromFridge,
      };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      unit: json['unit'] as String? ?? 'g',
      isFromFridge: json['is_from_fridge'] as bool? ?? true,
    );
  }
}

/// 營養資訊（每份）
class NutritionPerServing {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const NutritionPerServing({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
      };

  factory NutritionPerServing.fromJson(Map<String, dynamic> json) {
    return NutritionPerServing(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fatG: (json['fat_g'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// 完整食譜
class GeneratedRecipe {
  final String recipeName;
  final String description;
  final int servings;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final String difficulty; // easy, medium, hard
  final List<RecipeIngredient> ingredients;
  final List<String> instructions;
  final NutritionPerServing nutritionPerServing;
  final List<String> tags;
  final List<String> matchedFoodIds; // 對應本地資料庫的食物ID

  const GeneratedRecipe({
    required this.recipeName,
    required this.description,
    required this.servings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.nutritionPerServing,
    this.tags = const [],
    this.matchedFoodIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'recipe_name': recipeName,
        'description': description,
        'servings': servings,
        'prep_time_minutes': prepTimeMinutes,
        'cook_time_minutes': cookTimeMinutes,
        'difficulty': difficulty,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'instructions': instructions,
        'nutrition_per_serving': nutritionPerServing.toJson(),
        'tags': tags,
        'matched_foods': matchedFoodIds,
      };

  factory GeneratedRecipe.fromJson(Map<String, dynamic> json) {
    return GeneratedRecipe(
      recipeName: json['recipe_name'] as String? ?? '未知食譜',
      description: json['description'] as String? ?? '',
      servings: (json['servings'] as num?)?.toInt() ?? 2,
      prepTimeMinutes: (json['prep_time_minutes'] as num?)?.toInt() ?? 10,
      cookTimeMinutes: (json['cook_time_minutes'] as num?)?.toInt() ?? 20,
      difficulty: json['difficulty'] as String? ?? 'easy',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((i) => RecipeIngredient.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((s) => s as String)
              .toList() ??
          [],
      nutritionPerServing: json['nutrition_per_serving'] != null
          ? NutritionPerServing.fromJson(
              json['nutrition_per_serving'] as Map<String, dynamic>)
          : const NutritionPerServing(
              calories: 0, proteinG: 0, carbsG: 0, fatG: 0),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((t) => t as String)
              .toList() ??
          [],
      matchedFoodIds: (json['matched_foods'] as List<dynamic>?)
              ?.map((m) => m as String)
              .toList() ??
          [],
    );
  }

  /// 從 Gemini text 回應解析（Fallback）
  factory GeneratedRecipe.fromText(String text) {
    try {
      String cleaned = text.trim();
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.replaceFirst(RegExp(r'^```json?\s*'), '');
        cleaned = cleaned.replaceFirst(RegExp(r'```\s*$'), '');
      }
      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) {
        return GeneratedRecipe.fromJson(decoded);
      }
    } catch (_) {}
    return const GeneratedRecipe(
      recipeName: '解析失敗',
      description: '無法解析食譜，請重試',
      servings: 1,
      prepTimeMinutes: 0,
      cookTimeMinutes: 0,
      difficulty: 'easy',
      ingredients: [],
      instructions: [],
      nutritionPerServing: NutritionPerServing(
        calories: 0,
        proteinG: 0,
        carbsG: 0,
        fatG: 0,
      ),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static GeneratedRecipe fromJsonString(String jsonString) {
    return GeneratedRecipe.fromJson(jsonDecode(jsonString));
  }
}
