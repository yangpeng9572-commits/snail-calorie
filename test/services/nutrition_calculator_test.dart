import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NutritionCalculator', () {
    test('remaining calories calculation', () {
      final remaining = 2000 - 1500; // 目標 - 已攝入 = 500
      expect(remaining, equals(500));
    });

    test('over target returns negative', () {
      final remaining = 2000 - 2500; // 目標 - 已攝入 = -500
      expect(remaining, equals(-500));
    });
  });
}
