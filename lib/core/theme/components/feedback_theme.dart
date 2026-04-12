import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class FeedbackStyles {
  static SnackBarThemeData get snackBar => SnackBarThemeData(
    backgroundColor: AppColors.black500,
    contentTextStyle: AppTypography.bodyRegular14.copyWith(
      color: AppColors.white,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
  );

  static TooltipThemeData get tooltip => TooltipThemeData(
    textStyle: AppTypography.bodyRegular12.copyWith(color: AppColors.white),
    decoration: BoxDecoration(
      color: AppColors.black500,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static const ProgressIndicatorThemeData progressIndicator =
      ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.primary50,
        circularTrackColor: AppColors.primary50,
      );
}
