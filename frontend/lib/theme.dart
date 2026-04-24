import 'package:flutter/material.dart';

class VynkColors {
  static const primary = Color(0xFFD4AF37);
  static const secondary = Color(0xFFE6E6FA);
  static const background = Color(0xFFF9F7FF);
  static const textDark = Color(0xFF1E1E1E);
  static const textMuted = Color(0xFF696A73);
  static const like = Color(0xFFFF6A95);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF4EFFF), Color(0xFFFFF6DF)],
  );
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: VynkColors.background,
    colorScheme: const ColorScheme.light(
      primary: VynkColors.primary,
      secondary: VynkColors.secondary,
      surface: Colors.white,
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontWeight: FontWeight.w800,
        color: VynkColors.textDark,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w700,
        color: VynkColors.textDark,
      ),
      bodyLarge: TextStyle(color: VynkColors.textDark),
      bodyMedium: TextStyle(color: VynkColors.textMuted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: VynkColors.secondary.withValues(alpha: 0.8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: VynkColors.secondary.withValues(alpha: 0.8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: VynkColors.primary, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: VynkColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
