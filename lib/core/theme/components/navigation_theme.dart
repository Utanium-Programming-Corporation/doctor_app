import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_typography.dart';

abstract final class NavigationStyles {
  static BottomNavigationBarThemeData get bottomNavigationBar =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.black200,
        selectedLabelStyle: AppTypography.bodyMedium12,
        unselectedLabelStyle: AppTypography.bodyRegular12,
        showUnselectedLabels: true,
      );

  static NavigationBarThemeData get navigationBar => NavigationBarThemeData(
    backgroundColor: AppColors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    height: 60,
    indicatorColor: AppColors.primary50,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTypography.bodyMedium12.copyWith(color: AppColors.primary500);
      }
      return AppTypography.bodyRegular12.copyWith(color: AppColors.black200);
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: AppColors.primary500, size: 24);
      }
      return const IconThemeData(color: AppColors.black200, size: 24);
    }),
  );

  static TabBarThemeData get tabBar => TabBarThemeData(
    labelColor: AppColors.primary500,
    unselectedLabelColor: AppColors.black300,
    labelStyle: AppTypography.bodyBold14,
    unselectedLabelStyle: AppTypography.bodyRegular14,
    indicatorColor: AppColors.primary500,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: AppColors.divider,
  );
}
