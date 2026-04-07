import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class DialogStyles {
  static DialogThemeData get dialog => DialogThemeData(
    backgroundColor: AppColors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    titleTextStyle: AppTypography.h5.copyWith(color: AppColors.black900),
    contentTextStyle: AppTypography.bodyRegular16.copyWith(
      color: AppColors.black300,
    ),
  );

  static const BottomSheetThemeData bottomSheet = BottomSheetThemeData(
    backgroundColor: AppColors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  );
}
