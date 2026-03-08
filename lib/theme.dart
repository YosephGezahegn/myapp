import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Ethiopian-inspired Colors ──────────────────────────────────────────────
const Color ethiopianGreen = Color(0xFF009A44);
const Color ethiopianYellow = Color(0xFFFFD700);
const Color ethiopianRed = Color(0xFFEF3340);
const Color ethiopianBlue = Color(0xFF0D47A1);
const Color ethiopianDarkBg = Color(0xFF121212);
const Color ethiopianSurfaceDark = Color(0xFF1E1E2E);
const Color ethiopianCardDark = Color(0xFF2A2A3C);

// Category card colors
const List<Color> categoryColors = [
  Color(0xFFE65100), // Food - Deep Orange
  Color(0xFF1565C0), // Cities - Blue
  Color(0xFF6A1B9A), // Celebrities - Purple
  Color(0xFF4E342E), // History - Brown
  Color(0xFF2E7D32), // Animals - Green
  Color(0xFFF57F17), // Culture - Amber
];

// Game result colors
const Color correctColor = Color(0xFF00C853);
const Color skipColor = Color(0xFFFF6D00);

// ── Typography ─────────────────────────────────────────────────────────────
TextTheme get ethiopianTextTheme => TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      bodySmall: GoogleFonts.inter(fontSize: 12),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );

// ── Light Theme ────────────────────────────────────────────────────────────
ThemeData get lightTheme {
  final textTheme = ethiopianTextTheme;
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ethiopianGreen,
      brightness: Brightness.light,
      primary: ethiopianGreen,
      secondary: ethiopianYellow,
      tertiary: ethiopianRed,
      error: ethiopianRed,
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: const Color(0xFFF5F5F0),
    appBarTheme: AppBarTheme(
      backgroundColor: ethiopianGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: ethiopianGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: textTheme.labelLarge,
        elevation: 4,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

// ── Dark Theme ─────────────────────────────────────────────────────────────
ThemeData get darkTheme {
  final textTheme = ethiopianTextTheme;
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ethiopianGreen,
      brightness: Brightness.dark,
      primary: ethiopianGreen,
      secondary: ethiopianYellow,
      tertiary: ethiopianRed,
      error: ethiopianRed,
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: ethiopianDarkBg,
    appBarTheme: AppBarTheme(
      backgroundColor: ethiopianSurfaceDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: ethiopianYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: textTheme.labelLarge,
        elevation: 4,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: ethiopianCardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}