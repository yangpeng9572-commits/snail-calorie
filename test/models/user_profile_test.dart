import 'package:flutter_test/flutter_test.dart';
import 'package:snail_calorie/data/models/user_profile.dart';

void main() {
  group('UserProfile BMR', () {
    test('BMR calculation for male (Mifflin-St Jeor)', () {
      final profile = UserProfile(
        name: 'Test',
        gender: 'male',
        age: 25,
        height: 170,
        weight: 65,
        activityLevel: 'moderate',
      );
      // BMR = 10*65 + 6.25*170 - 5*25 + 5 = 650 + 1062.5 - 125 + 5 = 1592.5
      expect(profile.bmr.round(), equals(1593));
    });

    test('BMR calculation for female (Mifflin-St Jeor)', () {
      final profile = UserProfile(
        name: 'Test',
        gender: 'female',
        age: 25,
        height: 160,
        weight: 55,
        activityLevel: 'moderate',
      );
      // BMR = 10*55 + 6.25*160 - 5*25 - 161 = 550 + 1000 - 125 - 161 = 1264
      expect(profile.bmr.round(), equals(1264));
    });
  });
}
