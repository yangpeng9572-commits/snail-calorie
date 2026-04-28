import 'package:uuid/uuid.dart';

/// 運動項目模型
class ExerciseEntry {
  final String id;
  final String name;
  final int duration; // 持續時間（分鐘）
  final double caloriesBurned; // 燃燒卡路里
  final String date; // 日期字串 (yyyy-MM-dd)

  ExerciseEntry({
    String? id,
    required this.name,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
  }) : id = id ?? Uuid().v4();

  /// 從 JSON 建立
  factory ExerciseEntry.fromJson(Map<String, dynamic> json) {
    return ExerciseEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: json['duration'] as int,
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      date: json['date'] as String,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'date': date,
    };
  }

  /// 複製並修改
  ExerciseEntry copyWith({
    String? id,
    String? name,
    int? duration,
    double? caloriesBurned,
    String? date,
  }) {
    return ExerciseEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'ExerciseEntry(id: $id, name: $name, duration: $duration, caloriesBurned: $caloriesBurned, date: $date)';
  }
}

/// 預定義運動類型（含 MET 值）
class PredefinedExercise {
  final String name;
  final String icon;
  final double met; // 代謝當量

  const PredefinedExercise({
    required this.name,
    required this.icon,
    required this.met,
  });

  /// 計算卡路里燃燪
  /// [weight] 體重（公斤）
  /// [durationMinutes] 運動時間（分鐘）
  double calculateCalories(double weight, int durationMinutes) {
    // 卡路里 = MET × 體重(kg) × 時間(小時)
    return met * weight * (durationMinutes / 60);
  }
}

/// 預定義運動列表
class PredefinedExercises {
  static const List<PredefinedExercise> all = [
    PredefinedExercise(name: '跑步', icon: '🏃', met: 8.0),
    PredefinedExercise(name: '快走', icon: '🚶', met: 5.0),
    PredefinedExercise(name: '游泳', icon: '🏊', met: 7.0),
    PredefinedExercise(name: '健身', icon: '🏋️', met: 6.0),
    PredefinedExercise(name: '瑜珈', icon: '🧘', met: 3.0),
    PredefinedExercise(name: '騎單車', icon: '🚴', met: 7.0),
    PredefinedExercise(name: '跳舞', icon: '💃', met: 6.0),
    PredefinedExercise(name: '爬山', icon: '⛰️', met: 8.0),
    PredefinedExercise(name: '跳繩', icon: '🪢', met: 12.0),
    PredefinedExercise(name: '伸展', icon: '🤸', met: 2.5),
  ];

  static PredefinedExercise? findByName(String name) {
    try {
      return all.firstWhere((e) => e.name == name);
    } catch (_) {
      return null;
    }
  }
}
