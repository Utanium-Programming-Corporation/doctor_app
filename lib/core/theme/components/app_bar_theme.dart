import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class AppBarStyles {
  static AppBarTheme get theme => AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 1,
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.black900,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    titleTextStyle: AppTypography.h6.copyWith(color: AppColors.black900),
  );
}
