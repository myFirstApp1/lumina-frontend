import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Lumina Guardian visual identity — aligned with the Edit Profile screen.
  static const Color primary = Color(0xFFD95791);
  static const Color primaryContainer = Color(0xFFAA91D8);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF393044);

  // Background & surfaces.
  static const Color background = Color(0xFFFFF7FA);
  static const Color surface = Color(0xFFFFF7FA);
  static const Color cardSurface = Colors.white;

  // Semantic colors — intentionally separate from the decorative pink palette.
  // Keep SOS red, safe green and warning amber visually recognizable.
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFEF6C00);

  // Neutral colors from the Edit Profile screen.
  static const Color textPrimary = Color(0xFF393044);
  static const Color textSecondary = Color(0xFF898193);
  static const Color outline = Color(0xFFB7AAB5);
  static const Color outlineVariant = Color(0xFFE8DCE5);
  static const Color transparentWhite = Color(0xB3FFFFFF);

  // Soft ambient shadow.
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: primary.withOpacity(0.06),
      blurRadius: 20,
      spreadRadius: 1,
      offset: const Offset(0, 7),
    ),
  ];

  // Frosted-glass border.
  static Border glassBorder = Border.all(
    color: Colors.white.withOpacity(0.9),
    width: 1.2,
  );

  // Main action gradient: the same rose-to-lavender treatment as Edit Profile.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFD95791),
      Color(0xFFAA91D8),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Shared soft background gradient.
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFFE5EF),
      Color(0xFFFFF5F6),
      Color(0xFFF0EAFF),
      Color(0xFFFFF9F3),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Emergency gradient remains red — never blend it into the normal app theme.
  static const LinearGradient sosGradient = LinearGradient(
    colors: [
      Color(0xFFBA1A1A),
      Color(0xFFE53935),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shared shapes and radii.
  static BorderRadius radiusSm = BorderRadius.circular(8);
  static BorderRadius radiusDefault = BorderRadius.circular(18);
  static BorderRadius radiusMd = BorderRadius.circular(23);
  static BorderRadius radiusLg = BorderRadius.circular(26);
  static BorderRadius radiusXl = BorderRadius.circular(32);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        surface: surface,
        onSurface: textPrimary,
        error: error,
      ),
      scaffoldBackgroundColor: background,

      // Typography: Montserrat for headings, Be Vietnam Pro for body text.
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          height: 1.16,
          letterSpacing: -0.02,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.25,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.33,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.beVietnamPro(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1.55,
          color: textSecondary,
        ),
        bodyMedium: GoogleFonts.beVietnamPro(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.beVietnamPro(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
          color: textPrimary,
        ),
        labelSmall: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      cardTheme: CardThemeData(
        color: cardSurface.withOpacity(0.67),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusMd,
          side: BorderSide(
            color: Colors.white.withOpacity(0.9),
            width: 1.2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: primary.withOpacity(0.45),
          disabledForegroundColor: onPrimary.withOpacity(0.8),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8EFF5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: BorderSide(
            color: outlineVariant,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: BorderSide(
            color: outlineVariant.withOpacity(0.9),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: const BorderSide(
            color: error,
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: const BorderSide(
            color: error,
            width: 1.5,
          ),
        ),
        labelStyle: GoogleFonts.beVietnamPro(color: textSecondary),
        hintStyle: GoogleFonts.beVietnamPro(
          color: textSecondary.withOpacity(0.7),
        ),
      ),
    );
  }
}

