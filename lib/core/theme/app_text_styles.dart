import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 40 / 32,
    letterSpacing: -0.02 * 32,
  );

  static const displayMobile = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 36 / 28,
    letterSpacing: -0.02 * 28,
  );

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 32 / 24,
    letterSpacing: -0.01 * 24,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 28 / 20,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 24 / 16,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 20 / 14,
  );

  static const caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 20 / 14,
  );

  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 16 / 12,
    letterSpacing: 0.02 * 12,
  );
}
