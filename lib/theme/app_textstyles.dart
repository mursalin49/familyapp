import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String pomot = 'Prompt';
  static const TextStyle appName = TextStyle(
    fontSize: 22,
    fontFamily: pomot,
    color: AppColors.primary,
    letterSpacing: 1.2,
  );
  static const TextStyle header = TextStyle(
    fontSize: 14,
    fontFamily: pomot,
    color: AppColors.header,
  );
  static const TextStyle subtitleSmall = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 36,
    fontFamily: pomot,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textDark,
  );
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontFamily: pomot,
    color: AppColors.primary,
  );
  static const TextStyle title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static const TextStyle title2 = TextStyle(
    fontSize: 20,
    fontFamily: pomot,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
    fontFamily: pomot,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontFamily: pomot,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
