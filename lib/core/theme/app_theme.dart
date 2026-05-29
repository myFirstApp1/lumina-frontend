import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Primary Colors (Elegant feminine pink / rose palette)
  static const Color primary = Color(0xFFAB2C5D);
  static const Color primaryContainer = Color(0xFFF06292); // Vibrant rose pink
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF5E002B);

  // Background & Surface
  static const Color background = Color(0xFFFBF9F8); // Soft cream-pink
  static const Color surface = Color(0xFFFBF9F8);
  static const Color cardSurface = Colors.white; // Pure white for interactive cards
  
  // Semantic Colors
  static const Color error = Color(0xFFBA1A1A); // Deep red for urgent SOS
  static const Color success = Color(0xFF2E7D32); // Emerald green for safe status
  static const Color warning = Color(0xFFEF6C00); // Amber for pre-alert warnings
  
  // Neutral Colors
  static const Color textPrimary = Color(0xFF1B1C1C); // Dark charcoal for high contrast
  static const Color textSecondary = Color(0xFF574146); // Muted brown-grey for subtitles
  static const Color outline = Color(0xFF8A7176);
  static const Color outlineVariant = Color(0xFFDDBFC5);
  static const Color transparentWhite = Color(0xB3FFFFFF); // 70% transparent white for glassmorphism
  
  // Soft Rose-tinted Ambient Shadow
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFFF06292).withOpacity(0.08),
      blurRadius: 20.0,
      spreadRadius: 2.0,
      offset: const Offset(0, 8),
    ),
  ];

  // Soft Glassmorphic Highlight Border
  static Border glassBorder = Border.all(
    color: Colors.white.withOpacity(0.4),
    width: 1.0,
  );

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFAB2C5D),
      Color(0xFFF06292),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFBF9F8),
      Color(0xFFFFF0F3), // Ultra-soft light pink glow
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sosGradient = LinearGradient(
    colors: [
      Color(0xFFBA1A1A),
      Color(0xFFE53935),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shapes & Radius
  static BorderRadius radiusSm = BorderRadius.circular(8.0);
  static BorderRadius radiusDefault = BorderRadius.circular(16.0);
  static BorderRadius radiusMd = BorderRadius.circular(24.0);
  static BorderRadius radiusLg = BorderRadius.circular(32.0);
  static BorderRadius radiusXl = BorderRadius.circular(48.0);

  // Light Theme Definition
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        background: background,
        onBackground: textPrimary,
        surface: surface,
        onSurface: textPrimary,
        error: error,
      ),
      scaffoldBackgroundColor: background,
      
      // Typography Mappings using Montserrat & Be Vietnam Pro
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
          fontWeight: FontWeight.w600,
          height: 1.33,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
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
          fontWeight: FontWeight.w600,
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
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusMd,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.05,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: BorderSide(color: outlineVariant, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: BorderSide(color: outlineVariant.withOpacity(0.5), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusDefault,
          borderSide: const BorderSide(color: primary, width: 2.0),
        ),
        labelStyle: GoogleFonts.beVietnamPro(color: textSecondary),
        hintStyle: GoogleFonts.beVietnamPro(color: textSecondary.withOpacity(0.6)),
      ),
    );
  }
}
