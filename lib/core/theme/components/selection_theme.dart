import 'package:flutter/material.dart';

import '../app_colors.dart';

abstract final class SelectionStyles {
  static CheckboxThemeData get checkbox => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary500;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.white),
    side: const BorderSide(color: AppColors.black200, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );

  static SwitchThemeData get switchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.white;
      return AppColors.black200;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary500;
      }
      return AppColors.black50;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return AppColors.black100;
    }),
  );

  static RadioThemeData get radio => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary500;
      }
      return AppColors.black200;
    }),
  );
}
