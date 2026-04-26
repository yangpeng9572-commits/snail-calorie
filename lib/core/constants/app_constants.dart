/// 應用程式常數
class AppConstants {
  AppConstants._();

  static const String appName = '食刻輕卡';
  static const String appVersion = '1.0.0';

  // Open Food Facts API
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org';

  // 營養素熱量係數（kcal per gram）
  static const double caloriesPerGramCarbs = 4.0;
  static const double caloriesPerGramProtein = 4.0;
  static const double caloriesPerGramFat = 9.0;

  // 預設營養目標
  static const int defaultCalorieTarget = 2000;
  static const double defaultCarbsRatio = 0.50; // 50%
  static const double defaultProteinRatio = 0.20; // 20%
  static const double defaultFatRatio = 0.30; // 30%

  // 餐次分類
  static const List<String> mealTypes = ['早餐', '午餐', '晚餐', '點心'];
}

/// 營養目標資料模型
class NutritionTarget {
  final int calories;
  final double carbsGrams;
  final double proteinGrams;
  final double fatGrams;

  const NutritionTarget({
    required this.calories,
    required this.carbsGrams,
    required this.proteinGrams,
    required this.fatGrams,
  });

  factory NutritionTarget.defaultTarget() {
    return const NutritionTarget(
      calories: AppConstants.defaultCalorieTarget,
      carbsGrams: 250,
      proteinGrams: 100,
      fatGrams: 67,
    );
  }

  /// 根據 BMR 和目標計算
  factory NutritionTarget.calculate({
    required double bmr,
    required double activityMultiplier,
    required double deficit, // 熱量缺口，0 = 維持，-500 = 減重
  }) {
    final maintenance = (bmr * activityMultiplier).round();
    final target = maintenance + deficit.round();

    final carbsGrams = (target * AppConstants.defaultCarbsRatio / AppConstants.caloriesPerGramCarbs);
    final proteinGrams = (target * AppConstants.defaultProteinRatio / AppConstants.caloriesPerGramProtein);
    final fatGrams = (target * AppConstants.defaultFatRatio / AppConstants.caloriesPerGramFat);

    return NutritionTarget(
      calories: target,
      carbsGrams: carbsGrams.roundToDouble(),
      proteinGrams: proteinGrams.roundToDouble(),
      fatGrams: fatGrams.roundToDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'carbsGrams': carbsGrams,
    'proteinGrams': proteinGrams,
    'fatGrams': fatGrams,
  };

  factory NutritionTarget.fromJson(Map<String, dynamic> json) => NutritionTarget(
    calories: json['calories'] as int,
    carbsGrams: (json['carbsGrams'] as num).toDouble(),
    proteinGrams: (json['proteinGrams'] as num).toDouble(),
    fatGrams: (json['fatGrams'] as num).toDouble(),
  );
}

/// 用戶資料
class UserProfile {
  final String name;
  final int age;
  final double heightCm;
  final double weightKg;
  final String gender; // 'male' | 'female'
  final String goal; // 'lose' | 'maintain' | 'gain'
  final double activityLevel; // 1.2~1.9

  const UserProfile({
    required this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.activityLevel,
  });

  factory UserProfile.defaultProfile() {
    return const UserProfile(
      name: '使用者',
      age: 25,
      heightCm: 170,
      weightKg: 65,
      gender: 'male',
      goal: 'maintain',
      activityLevel: 1.375, // 輕度活動
    );
  }

  /// 計算基礎代謝率（BMR）using Mifflin-St Jeor Equation
  double get bmr {
    if (gender == 'male') {
      return 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      return 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
  }

  /// 取得熱量目標
  NutritionTarget get nutritionTarget {
    double deficit;
    switch (goal) {
      case 'lose':
        deficit = -500;
        break;
      case 'gain':
        deficit = 300;
        break;
      default:
        deficit = 0;
    }
    return NutritionTarget.calculate(
      bmr: bmr,
      activityMultiplier: activityLevel,
      deficit: deficit,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'gender': gender,
    'goal': goal,
    'activityLevel': activityLevel,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String,
    age: json['age'] as int,
    heightCm: (json['heightCm'] as num).toDouble(),
    weightKg: (json['weightKg'] as num).toDouble(),
    gender: json['gender'] as String,
    goal: json['goal'] as String,
    activityLevel: (json['activityLevel'] as num).toDouble(),
  );

  UserProfile copyWith({
    String? name,
    int? age,
    double? heightCm,
    double? weightKg,
    String? gender,
    String? goal,
    double? activityLevel,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
