import 'package:flutter/material.dart';

class VynkColors {
  // Primary color
  static const Color primary = Color(0xFFD4AF37); // Gold

  // Lavender palette
  static const Color lavender = Color(0xFFE6E6FA); // Light lavender
  static const Color lavenderDeep = Color(0xFFB19CD9); // Deep lavender
  static const Color lavenderAccent = Color(0xFF9D7FB8); // Accent lavender
  static const Color secondary = Color(0xFFE6E6FA); // Lavender

  // Background
  static const Color background = Color(0xFFFFFFFF); // White

  // Text colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF6B6B6B);
  static const Color textGrey = Color(0xFFB0B0B0);

  // Action colors (dating app)
  static const Color like = Color(0xFFFF6B9D); // Pink for like
  static const Color superLike = Color(0xFF00BCD4); // Cyan for super like
  static const Color pass = Color(0xFF9E9E9E); // Grey for pass

  // Gradients
  static const LinearGradient lavenderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lavender, background],
  );

  static const LinearGradient deepLavenderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lavenderDeep, lavender],
  );

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
}

class VynkTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: VynkColors.primary,
      scaffoldBackgroundColor: VynkColors.lavender,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: VynkColors.primary,
        secondary: VynkColors.lavender,
        surface: VynkColors.lavender,
        onSurface: VynkColors.textDark,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: VynkColors.lavender,
        foregroundColor: VynkColors.textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VynkColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: VynkColors.primary.withValues(alpha: 0.4),
        ),
      ),

      // Text theme
      textTheme: textTheme,

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: VynkColors.primary,
            width: 2.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: VynkColors.primary,
            width: 2.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: VynkColors.primary,
            width: 2.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(
          color: VynkColors.textGrey.withValues(alpha: 0.7),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: VynkColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: VynkColors.primary,
            width: 1,
          ),
        ),
      ),
    );
  }

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: VynkColors.textDark,
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: VynkColors.textDark,
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: VynkColors.textDark,
      ),
      headlineSmall: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: VynkColors.textDark,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: VynkColors.textDark,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: VynkColors.textDark,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: VynkColors.textDark,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: VynkColors.textDark,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: VynkColors.textLight,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: VynkColors.textGrey,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: VynkColors.primary.withValues(alpha: 0.8),
      ),
    );
  }
}
