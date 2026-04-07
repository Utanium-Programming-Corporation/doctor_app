import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class InputStyles {
  static InputDecorationTheme get theme => InputDecorationTheme(
    filled: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    enabledBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.black200, width: 1),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.primary500, width: 2),
    ),
    errorBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.danger300, width: 2),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.danger300, width: 2),
    ),
    disabledBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.black200, width: 1),
    ),
    labelStyle: AppTypography.label.copyWith(color: AppColors.black900),
    floatingLabelStyle: AppTypography.label.copyWith(
      color: AppColors.primary500,
    ),
    hintStyle: AppTypography.bodyRegular16.copyWith(color: AppColors.black200),
    errorStyle: AppTypography.bodyRegular12.copyWith(
      color: AppColors.danger300,
    ),
    helperStyle: AppTypography.bodyRegular12.copyWith(
      color: AppColors.black300,
    ),
    helperMaxLines: 2,
    errorMaxLines: 2,
    iconColor: AppColors.black300,
    prefixIconColor: AppColors.black300,
    suffixIconColor: AppColors.black300,
  );
}
