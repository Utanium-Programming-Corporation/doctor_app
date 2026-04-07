import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'components/app_bar_theme.dart';
import 'components/button_theme.dart';
import 'components/card_theme.dart';
import 'components/chip_theme.dart';
import 'components/dialog_theme.dart';
import 'components/divider_theme.dart';
import 'components/feedback_theme.dart';
import 'components/input_theme.dart';
import 'components/navigation_theme.dart';
import 'components/selection_theme.dart';

/// Assembles the app-wide [ThemeData] for light mode.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
/// )
/// ```
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary500,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primary50,
      onPrimaryContainer: AppColors.primary900,
      secondary: AppColors.secondary500,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondary50,
      onSecondaryContainer: AppColors.secondary900,
      tertiary: AppColors.accent500,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.accent50,
      onTertiaryContainer: AppColors.accent900,
      error: AppColors.danger300,
      onError: AppColors.white,
      errorContainer: AppColors.danger50,
      onErrorContainer: AppColors.danger500,
      surface: AppColors.white,
      onSurface: AppColors.black900,
      onSurfaceVariant: AppColors.black300,
      outline: AppColors.black200,
      outlineVariant: AppColors.black50,
      shadow: const Color(0xFF0D0D12),
      scrim: const Color(0xFF0D0D12),
      inverseSurface: AppColors.black500,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.primary200,
      surfaceContainerHighest: AppColors.black50,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      dividerColor: AppColors.divider,

      // ── Typography ────────────────────────────────────────────────────
      textTheme: _textTheme(colorScheme),

      // ── Components ────────────────────────────────────────────────────
      appBarTheme: AppBarStyles.theme,
      elevatedButtonTheme: ButtonStyles.elevatedButton,
      filledButtonTheme: ButtonStyles.filledButton,
      outlinedButtonTheme: ButtonStyles.outlinedButton,
      textButtonTheme: ButtonStyles.textButton,
      iconButtonTheme: ButtonStyles.iconButton,
      floatingActionButtonTheme: ButtonStyles.fab,
      inputDecorationTheme: InputStyles.theme,
      cardTheme: CardStyles.theme,
      bottomNavigationBarTheme: NavigationStyles.bottomNavigationBar,
      navigationBarTheme: NavigationStyles.navigationBar,
      tabBarTheme: NavigationStyles.tabBar,
      chipTheme: ChipStyles.theme,
      dividerTheme: DividerStyles.theme,
      dialogTheme: DialogStyles.dialog,
      bottomSheetTheme: DialogStyles.bottomSheet,
      snackBarTheme: FeedbackStyles.snackBar,
      tooltipTheme: FeedbackStyles.tooltip,
      progressIndicatorTheme: FeedbackStyles.progressIndicator,
      checkboxTheme: SelectionStyles.checkbox,
      switchTheme: SelectionStyles.switchTheme,
      radioTheme: SelectionStyles.radio,
    );
  }

  // ── Private helpers ──────────────────────────────────────────────────

  static TextTheme _textTheme(ColorScheme cs) {
    return TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: cs.onSurface),
      displayMedium: AppTypography.h2.copyWith(color: cs.onSurface),
      displaySmall: AppTypography.h3.copyWith(color: cs.onSurface),
      headlineLarge: AppTypography.h3.copyWith(color: cs.onSurface),
      headlineMedium: AppTypography.h4.copyWith(color: cs.onSurface),
      headlineSmall: AppTypography.h5.copyWith(color: cs.onSurface),
      titleLarge: AppTypography.h5.copyWith(color: cs.onSurface),
      titleMedium: AppTypography.bodyBold16.copyWith(color: cs.onSurface),
      titleSmall: AppTypography.bodyBold14.copyWith(color: cs.onSurface),
      bodyLarge: AppTypography.bodyRegular18.copyWith(color: cs.onSurface),
      bodyMedium: AppTypography.bodyRegular16.copyWith(color: cs.onSurface),
      bodySmall: AppTypography.bodyRegular14.copyWith(color: cs.onSurface),
      labelLarge: AppTypography.button.copyWith(color: cs.onSurface),
      labelMedium: AppTypography.bodyMedium12.copyWith(color: cs.onSurface),
      labelSmall: AppTypography.bodyRegular12.copyWith(color: cs.onSurface),
    );
  }
}
