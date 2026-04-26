import 'package:flutter/material.dart';

/// 深色主題
class AppThemeDark {
  AppThemeDark._();

  // 品牌色彩（淡藍運動深色版）
  static const Color primaryColor = Color(0xFF4DD0E5); // 運動淺藍
  static const Color secondaryColor = Color(0xFF80CBC4); // 淺青
  static const Color accentColor = Color(0xFFFFAB40); // 活力橙
  static const Color errorColor = Color(0xFFFF5252);

  // 營養素色彩（深色版）
  static const Color calorieColor = Color(0xFFFFAB40); // 橙
  static const Color carbsColor = Color(0xFF4DD0E5); // 藍
  static const Color proteinColor = Color(0xFF69F0AE); // 綠
  static const Color fatColor = Color(0xFFFFD740); // 琥珀

  // 深色背景色彩（參考 FatSecret 深色主題 #1C1C1E）
  static const Color backgroundColor = Color(0xFF1C1C1E); // 改為 #1C1C1E 更護眼
  static const Color cardColor = Color(0xFF2C2C2E); // 卡片較背景淡一點
  static const Color surfaceColor = Color(0xFF2C2C2E);
  static const Color textPrimary = Color(0xFFF5F5F5); // 改為護眼白
  static const Color textSecondary = Color(0xFFA0A0A0); // 次要文字

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansTC',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: surfaceColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2C2C2E),
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2C2C2E),
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textPrimary),
        labelSmall: TextStyle(color: textSecondary),
      ),
    );
  }
}
