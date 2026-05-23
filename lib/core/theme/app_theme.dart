import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.red,
        onPrimary: Colors.white,
        surface: AppColors.darkBg2,
        onSurface: AppColors.darkText,
        surfaceVariant: AppColors.darkBg3,
        onSurfaceVariant: AppColors.darkText2,
        outline: AppColors.darkBorder,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.notoSans(color: AppColors.darkText),
        bodyMedium: GoogleFonts.notoSans(color: AppColors.darkText),
        labelMedium: GoogleFonts.notoSans(color: AppColors.darkText3),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkText),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.red,
        onPrimary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
        surfaceVariant: AppColors.lightBg2,
        onSurfaceVariant: AppColors.lightText2,
        outline: AppColors.lightBorder,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.notoSans(color: AppColors.lightText),
        bodyMedium: GoogleFonts.notoSans(color: AppColors.lightText),
        labelMedium: GoogleFonts.notoSans(color: AppColors.lightText3),
      ),
      iconTheme: const IconThemeData(color: AppColors.lightText),
    );
  }
}
