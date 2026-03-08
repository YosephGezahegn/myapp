import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Ethiopian-inspired colors
const Color ethiopianGreen = Color(0xFF009A44);
const Color ethiopianYellow = Color(0xFFFFD700);
const Color ethiopianRed = Color(0xFFEF3340);
const Color ethiopianBlue = Color(0xFF1976D2); // A complementary color for accents

final TextTheme ethiopianTextTheme = TextTheme(
  displayLarge: GoogleFonts.zillaSlab(
      fontSize: 57, fontWeight: FontWeight.bold, color: Colors.black),
  displayMedium: GoogleFonts.zillaSlab(
      fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black),
  displaySmall: GoogleFonts.zillaSlab(
      fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
  headlineLarge: GoogleFonts.oswald(
      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
  headlineMedium: GoogleFonts.oswald(
      fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
  headlineSmall: GoogleFonts.oswald(
      fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
  titleLarge: GoogleFonts.roboto(
      fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
  titleMedium: GoogleFonts.roboto(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
  titleSmall: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
  bodyLarge: GoogleFonts.openSans(fontSize: 16, color: Colors.black87),
  bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.black87),
  bodySmall: GoogleFonts.openSans(fontSize: 12, color: Colors.black54),
  labelLarge: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
  labelMedium: GoogleFonts.roboto(
      fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
  labelSmall: GoogleFonts.roboto(
      fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
);

// Light Theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ethiopianGreen,
    brightness: Brightness.light,
    primary: ethiopianGreen,
    onPrimary: Colors.white,
    secondary: ethiopianYellow,
    onSecondary: Colors.black,
    tertiary: ethiopianRed,
    error: ethiopianRed,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  textTheme: ethiopianTextTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: ethiopianGreen,
    foregroundColor: Colors.white,
    titleTextStyle:
        ethiopianTextTheme.headlineMedium?.copyWith(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: ethiopianGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: ethiopianTextTheme.labelLarge,
    ),
  ),
  // Add other component themes as needed
);

// Dark Theme (optional, but good for completeness)
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ethiopianGreen,
    brightness: Brightness.dark,
    primary: ethiopianGreen,
    onPrimary: Colors.white,
    secondary: ethiopianYellow,
    onSecondary: Colors.black,
    tertiary: ethiopianRed,
    error: ethiopianRed,
    onError: Colors.white,
    background: Colors.grey[900],
    onBackground: Colors.white,
    surface: Colors.grey[800],
    onSurface: Colors.white,
  ),
  textTheme: ethiopianTextTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white), // Apply white color for dark theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
    titleTextStyle:
        ethiopianTextTheme.headlineMedium?.copyWith(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: ethiopianYellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: ethiopianTextTheme.labelLarge,
    ),
  ),
  // Add other component themes as needed
);