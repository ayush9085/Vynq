import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VynkColors {
  // Core palette — dark, intimate, dating-forward
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceLight = Color(0xFF252542);
  static const card = Color(0xFF16162A);

  // Accent colors
  static const primary = Color(0xFFFF4D67); // hot coral-pink
  static const primaryLight = Color(0xFFFF7B93);
  static const accent = Color(0xFF7C3AED); // electric violet
  static const accentLight = Color(0xFFA78BFA);
  static const gold = Color(0xFFFFD700);
  static const superLike = Color(0xFF3B82F6);
  static const like = Color(0xFFFF4D67);
  static const pass = Color(0xFF6B7280);
  static const nope = Color(0xFFEF4444);

  // Text
  static const textPrimary = Color(0xFFF9FAFB);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);

  // Gradients
  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF4D67), Color(0xFF7C3AED)],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );

  static const sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF6B6B), Color(0xFFFF4D67), Color(0xFF7C3AED)],
  );

  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
  );

  // Shadows
  static List<BoxShadow> primaryGlow({double opacity = 0.3}) => [
    BoxShadow(
      color: primary.withValues(alpha: opacity),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> accentGlow({double opacity = 0.25}) => [
    BoxShadow(
      color: accent.withValues(alpha: opacity),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: VynkColors.background,
    colorScheme: const ColorScheme.dark(
      primary: VynkColors.primary,
      secondary: VynkColors.accent,
      surface: VynkColors.surface,
      onSurface: VynkColors.textPrimary,
    ),
    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w900,
          color: VynkColors.textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w800,
          color: VynkColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w800,
          color: VynkColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w700,
          color: VynkColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w700,
          color: VynkColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          color: VynkColors.textPrimary,
        ),
        bodyLarge: TextStyle(color: VynkColors.textPrimary),
        bodyMedium: TextStyle(color: VynkColors.textSecondary),
        bodySmall: TextStyle(color: VynkColors.textMuted),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          color: VynkColors.textPrimary,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: VynkColors.surfaceLight.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: VynkColors.textMuted.withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: VynkColors.textMuted.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: VynkColors.primary, width: 1.5),
      ),
      hintStyle: TextStyle(
        color: VynkColors.textMuted.withValues(alpha: 0.6),
      ),
      prefixIconColor: VynkColors.textMuted,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: VynkColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        side: BorderSide(color: VynkColors.primary.withValues(alpha: 0.5)),
        foregroundColor: VynkColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: VynkColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: VynkColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: VynkColors.textPrimary),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: VynkColors.surfaceLight,
      selectedColor: VynkColors.primary.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: VynkColors.textPrimary, fontSize: 13),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: VynkColors.surface,
      contentTextStyle: const TextStyle(color: VynkColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: VynkColors.primary,
      unselectedItemColor: VynkColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}

/// Glass-effect container decoration
BoxDecoration glassDecoration({
  double opacity = 0.08,
  double borderRadius = 20,
  Color borderColor = Colors.white,
  double borderOpacity = 0.1,
}) {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: opacity),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: borderColor.withValues(alpha: borderOpacity),
    ),
  );
}
