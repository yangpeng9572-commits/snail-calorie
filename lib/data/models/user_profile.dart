/// 用戶資料模型
class UserProfile {
  final String name;
  final String gender; // 'male' or 'female'
  final int age;
  final double height; // cm
  final double weight; // kg
  final String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'

  UserProfile({
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

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
}
