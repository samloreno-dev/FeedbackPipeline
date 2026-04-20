import 'package:flutter/material.dart';

class MobileTheme {
  // Navy corporate - matching admin
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryDark = Color(0xFF1E2067);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color goldLight = Color(0xFFFCD34D);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      secondary: accentGold,
      surface: surfaceLight,
      onSurface: Color(0xFF111827),
    ),
    scaffoldBackgroundColor: surfaceLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData get theme => lightTheme;
}
