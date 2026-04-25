import 'package:uuid/uuid.dart';

/// 餐點照片模型
class MealPhoto {
  final String id;
  final String mealType; // '早餐' | '午餐' | '晚餐' | '點心'
  final String? foodId;
  final String foodName; // 食物名稱（顯示用）
  final String photoPath; // 本地檔案路徑
  final DateTime takenAt; // 拍攝時間
  final String? notes; // 備註

  MealPhoto({
    String? id,
    required this.mealType,
    this.foodId,
    required this.foodName,
    required this.photoPath,
    DateTime? takenAt,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        takenAt = takenAt ?? DateTime.now();

  MealPhoto copyWith({
    String? id,
    String? mealType,
    String? foodId,
    String? foodName,
    String? photoPath,
    DateTime? takenAt,
    String? notes,
  }) {
    return MealPhoto(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      photoPath: photoPath ?? this.photoPath,
      takenAt: takenAt ?? this.takenAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mealType': mealType,
        'foodId': foodId,
        'foodName': foodName,
        'photoPath': photoPath,
        'takenAt': takenAt.toIso8601String(),
        'notes': notes,
      };

  factory MealPhoto.fromJson(Map<String, dynamic> json) => MealPhoto(
        id: json['id'] as String,
        mealType: json['mealType'] as String,
        foodId: json['foodId'] as String?,
        foodName: json['foodName'] as String? ?? '未命名食物',
        photoPath: json['photoPath'] as String,
        takenAt: DateTime.parse(json['takenAt'] as String),
        notes: json['notes'] as String?,
      );

  @override
  String toString() =>
      'MealPhoto($mealType - $foodName, takenAt: $takenAt)';
}
