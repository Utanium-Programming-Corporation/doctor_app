import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class ButtonStyles {
  static ElevatedButtonThemeData get elevatedButton => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.buttonDisabled,
      disabledForegroundColor: AppColors.white,
      elevation: 0,
      textStyle: AppTypography.button,
      minimumSize: const Size(78, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: const StadiumBorder(),
    ),
  );

  static FilledButtonThemeData get filledButton => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.buttonDisabled,
      disabledForegroundColor: AppColors.white,
      textStyle: AppTypography.button,
      minimumSize: const Size(78, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: const StadiumBorder(),
    ),
  );

  static OutlinedButtonThemeData get outlinedButton => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.buttonSecondary,
      disabledForegroundColor: AppColors.buttonDisabled,
      textStyle: AppTypography.button,
      minimumSize: const Size(78, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: const StadiumBorder(),
      side: const BorderSide(color: AppColors.buttonSecondary),
    ),
  );

  static TextButtonThemeData get textButton => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary500,
      disabledForegroundColor: AppColors.buttonDisabled,
      textStyle: AppTypography.button,
      minimumSize: const Size(78, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: const StadiumBorder(),
    ),
  );

  static IconButtonThemeData get iconButton => IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: AppColors.black300,
      minimumSize: const Size(40, 40),
      iconSize: 24,
    ),
  );

  static FloatingActionButtonThemeData get fab => FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary500,
    foregroundColor: AppColors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
