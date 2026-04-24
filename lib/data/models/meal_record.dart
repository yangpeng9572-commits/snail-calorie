import 'package:uuid/uuid.dart';
import 'food_item.dart';

/// 單筆食物記錄（掛在某餐下）
class MealEntry {
  final String id;
  final FoodItem food;
  final double grams;
  final DateTime loggedAt;

  MealEntry({
    String? id,
    required this.food,
    required this.grams,
    DateTime? loggedAt,
  })  : id = id ?? const Uuid().v4(),
        loggedAt = loggedAt ?? DateTime.now();

  double get calories => food.caloriesForServing(grams);
  double get carbs => food.carbsForServing(grams);
  double get protein => food.proteinForServing(grams);
  double get fat => food.fatForServing(grams);

  Map<String, dynamic> toJson() => {
    'id': id,
    'food': food.toJson(),
    'grams': grams,
    'loggedAt': loggedAt.toIso8601String(),
  };

  factory MealEntry.fromJson(Map<String, dynamic> json) => MealEntry(
    id: json['id'] as String,
    food: FoodItem.fromJson(json['food'] as Map<String, dynamic>),
    grams: (json['grams'] as num).toDouble(),
    loggedAt: DateTime.parse(json['loggedAt'] as String),
  );
}

/// 單餐記錄（早餐/午餐/晚餐/點心）
class MealRecord {
  final String type; // '早餐' | '午餐' | '晚餐' | '點心'
  final List<MealEntry> entries;

  MealRecord({
    required this.type,
    List<MealEntry>? entries,
  }) : entries = entries ?? [];

  double get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);
  double get totalCarbs => entries.fold(0, (sum, e) => sum + e.carbs);
  double get totalProtein => entries.fold(0, (sum, e) => sum + e.protein);
  double get totalFat => entries.fold(0, (sum, e) => sum + e.fat);

  MealRecord addEntry(MealEntry entry) {
    return MealRecord(type: type, entries: [...entries, entry]);
  }

  MealRecord removeEntry(String entryId) {
    return MealRecord(type: type, entries: entries.where((e) => e.id != entryId).toList());
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  factory MealRecord.fromJson(Map<String, dynamic> json) => MealRecord(
    type: json['type'] as String,
    entries: (json['entries'] as List)
        .map((e) => MealEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
