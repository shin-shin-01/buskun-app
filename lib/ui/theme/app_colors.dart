import 'package:flutter/material.dart';

class AppColors {
  AppColors({
    required this.primary,
    required this.accent,
    required this.background,
    required this.firstLine,
    required this.secondLine,
    required this.thirdLine,
    required this.blue,
    required this.error,
  });

  factory AppColors.main() {
    final Color black = Color(0xff353537);
    final Color white = Color(0xffFFFAFA);
    final Color grey = Color(0xffEEEEEE);
    final Color red = Color(0xffD32431);
    final Color blue = Colors.blue;
    // バス停カード色分け
    final Color green = Color(0xFF50998F);
    final Color pink = Color(0xFFC67B82);
    final Color darkBlue = Color(0xFF5B5E7A);

    return AppColors(
      primary: black,
      accent: white,
      background: grey,
      firstLine: green,
      secondLine: pink,
      thirdLine: darkBlue,
      blue: blue,
      error: red,
    );
  }
  final Color primary;
  final Color accent;
  final Color background;
  final Color firstLine;
  final Color secondLine;
  final Color thirdLine;
  final Color blue;

  final Color error;
}
