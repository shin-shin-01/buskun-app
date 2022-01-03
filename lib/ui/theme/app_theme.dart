import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

final appTheme = AppTheme.main();

class AppTheme {
  AppTheme({
    required this.data,
    required this.textTheme,
    required this.appColors,
  });

  factory AppTheme.main() {
    final appColors = AppColors.main();
    final themeData = ThemeData.light().copyWith(
      scaffoldBackgroundColor: appColors.background,
      textTheme: GoogleFonts.notoSansTextTheme(ThemeData.light().textTheme),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );

    return AppTheme(
      data: themeData,
      textTheme: AppTextTheme(),
      appColors: appColors,
    );
  }

  final ThemeData data;
  final AppTextTheme textTheme;
  final AppColors appColors;
}
