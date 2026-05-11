import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF8B6914);
  static const Color primaryLight = Color(0xFFD4A843);
  static const Color secondary = Color(0xFF5C6B3C);
  static const Color accent = Color(0xFFC17B3A);
  static const Color background = Color(0xFFF5F0E8);
  static const Color surface = Color(0xFFFFFDF7);
  static const Color cardBg = Color(0xFFF9F4EC);
  static const Color textDark = Color(0xFF2D2416);
  static const Color textMuted = Color(0xFF6B5B4E);
  static const Color divider = Color(0xFFE8DFD3);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: surface,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          iconTheme: const IconThemeData(color: textDark),
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          titleLarge: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          titleMedium: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
          bodyLarge: GoogleFonts.lato(fontSize: 16, color: textDark),
          bodyMedium: GoogleFonts.lato(fontSize: 14, color: textMuted),
          labelLarge: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primary,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: divider),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textMuted,
        ),
      );
}
