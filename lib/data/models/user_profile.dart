/// 用戶資料模型
class UserProfile {
  final String name;
  final String gender; // 'male' or 'female'
  final int age;
  final double height; // cm (heightCm 相容)
  final double weight; // kg (weightKg 相容)
  final String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  final String goal; // 'lose', 'maintain', 'gain'

  UserProfile({
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
    this.goal = 'maintain',
  });

  /// 工廠方法：從 CalorieWizard 的欄位名稱建立
  factory UserProfile.fromWizard({
    required String name,
    required int age,
    required double heightCm,
    required double weightKg,
    required String gender,
    required String goal,
    required String activityLevel,
  }) {
    return UserProfile(
      name: name,
      age: age,
      height: heightCm,
      weight: weightKg,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );
  }

  /// 基礎代謝率 (BMR) - Mifflin-St Jeor Equation
  double get bmr {
    if (gender == 'male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  /// 活動係數
  double get activityFactor {
    switch (activityLevel) {
      case 'sedentary':
        return 1.2;
      case 'light':
        return 1.375;
      case 'moderate':
        return 1.55;
      case 'active':
        return 1.725;
      case 'very_active':
        return 1.9;
      default:
        return 1.55;
    }
  }

  /// 每日總消耗熱量 (TDEE)
  double get tdee => bmr * activityFactor;

  /// 目標熱量（每日攝取目標，考慮減重/增重）
  double get targetCalories {
    final goalAdjust = {'lose': -500.0, 'maintain': 0.0, 'gain': 300.0};
    return tdee + (goalAdjust[goal] ?? 0.0);
  }
}
