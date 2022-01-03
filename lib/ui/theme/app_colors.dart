import 'package:flutter/material.dart';

class AppColors {
  AppColors({
    required this.primary,
    required this.accent,
    required this.background,
    required this.error,
  });

  factory AppColors.main() {
    final Color black = Color(0xff353537);
    final Color white = Color(0xffFFFAFA);
    final Color grey = Color(0xffEEEEEE);
    final Color red = Color(0xffD32431);

    return AppColors(
      primary: black,
      accent: white,
      background: grey,
      error: red,
    );
  }
  final Color primary;
  final Color accent;
  final Color background;
  final Color error;
}
