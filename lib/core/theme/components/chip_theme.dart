import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class ChipStyles {
  static ChipThemeData get theme => ChipThemeData(
    backgroundColor: AppColors.black50,
    disabledColor: AppColors.black50,
    selectedColor: AppColors.primary50,
    labelStyle: AppTypography.bodyMedium14.copyWith(color: AppColors.black900),
    side: BorderSide.none,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  );
}
