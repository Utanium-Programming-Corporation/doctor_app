import 'package:flutter/material.dart';

/// Design-system color palette extracted from Figma.
/// Light-mode only.
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────────────────
  static const Color primary50 = Color(0xFFE6ECF4);
  static const Color primary100 = Color(0xFFB0C5DC);
  static const Color primary200 = Color(0xFF8AA9CB);
  static const Color primary300 = Color(0xFF5481B4);
  static const Color primary400 = Color(0xFF3369A5);
  static const Color primary500 = Color(0xFF00438F);
  static const Color primary600 = Color(0xFF003D82);
  static const Color primary700 = Color(0xFF003066);
  static const Color primary800 = Color(0xFF00254F);
  static const Color primary900 = Color(0xFF001C3C);

  static const MaterialColor primarySwatch = MaterialColor(0xFF00438F, {
    50: primary50,
    100: primary100,
    200: primary200,
    300: primary300,
    400: primary400,
    500: primary500,
    600: primary600,
    700: primary700,
    800: primary800,
    900: primary900,
  });

  // ── Secondary ────────────────────────────────────────────────────────
  static const Color secondary50 = Color(0xFFF3F6FB);
  static const Color secondary100 = Color(0xFFD9E4F1);
  static const Color secondary200 = Color(0xFFC6D7EA);
  static const Color secondary300 = Color(0xFFACC4E1);
  static const Color secondary400 = Color(0xFF9CB9DB);
  static const Color secondary500 = Color(0xFF83A7D2);
  static const Color secondary600 = Color(0xFF7798BF);
  static const Color secondary700 = Color(0xFF5D7795);
  static const Color secondary800 = Color(0xFF485C74);
  static const Color secondary900 = Color(0xFF374658);

  // ── Accent ───────────────────────────────────────────────────────────
  static const Color accent50 = Color(0xFFE7F8F8);
  static const Color accent100 = Color(0xFFB3EBEB);
  static const Color accent200 = Color(0xFF8EE1E1);
  static const Color accent300 = Color(0xFF5BD3D3);
  static const Color accent400 = Color(0xFF3BCACA);
  static const Color accent500 = Color(0xFF0ABDBD);
  static const Color accent600 = Color(0xFF09ACAC);
  static const Color accent700 = Color(0xFF078686);
  static const Color accent800 = Color(0xFF066868);
  static const Color accent900 = Color(0xFF044F4F);

  // ── Success ──────────────────────────────────────────────────────────
  static const Color success50 = Color(0xFFEAF6EC);
  static const Color success75 = Color(0xFFA7DBB3);
  static const Color success100 = Color(0xFF82CC93);
  static const Color success200 = Color(0xFF4DB665);
  static const Color success300 = Color(0xFF28A745);
  static const Color success400 = Color(0xFF1C7530);
  static const Color success500 = Color(0xFF18662A);

  // ── Warning ──────────────────────────────────────────────────────────
  static const Color warning50 = Color(0xFFFFF9E6);
  static const Color warning75 = Color(0xFFFFE699);
  static const Color warning100 = Color(0xFFFFDB6F);
  static const Color warning200 = Color(0xFFFFCC31);
  static const Color warning300 = Color(0xFFFFC107);
  static const Color warning400 = Color(0xFFB38705);
  static const Color warning500 = Color(0xFF9C7604);

  // ── Info ─────────────────────────────────────────────────────────────
  static const Color info50 = Color(0xFFE8F6F8);
  static const Color info75 = Color(0xFFA0D9E2);
  static const Color info100 = Color(0xFF78C9D6);
  static const Color info200 = Color(0xFF3EB2C4);
  static const Color info300 = Color(0xFF17A2B8);
  static const Color info400 = Color(0xFF107181);
  static const Color info500 = Color(0xFF0E6370);

  // ── Danger ───────────────────────────────────────────────────────────
  static const Color danger50 = Color(0xFFFCEBEC);
  static const Color danger75 = Color(0xFFF1ACB3);
  static const Color danger100 = Color(0xFFEB8A93);
  static const Color danger200 = Color(0xFFE25765);
  static const Color danger300 = Color(0xFFDC3545);
  static const Color danger400 = Color(0xFF9A2530);
  static const Color danger500 = Color(0xFF86202A);

  // ── Neutral (Black) ─────────────────────────────────────────────────
  static const Color black50 = Color(0xFFE6E7E7);
  static const Color black100 = Color(0xFFB0B4B6);
  static const Color black200 = Color(0xFF8A8F92);
  static const Color black300 = Color(0xFF555C61);
  static const Color black400 = Color(0xFF343D42);
  static const Color black500 = Color(0xFF010C13);
  static const Color black600 = Color(0xFF010B11);
  static const Color black700 = Color(0xFF01090D);
  static const Color black800 = Color(0xFF01070A);
  static const Color black900 = Color(0xFF000508);

  // ── Surface / Background ────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  // ── Button colors (from Figma) ──────────────────────────────────────
  static const Color buttonPrimary = Color(0xFF0D3E87);
  static const Color buttonPrimaryHovered = Color(0xFF83A7D2);
  static const Color buttonPrimaryFocused = Color(0xFF5D7795);
  static const Color buttonDisabled = Color(0xFFB0B4B6);

  static const Color buttonDanger = Color(0xFFDC3545);
  static const Color buttonDangerHovered = Color(0xFFEB8A93);

  static const Color buttonAccent = Color(0xFF4DB665);
  static const Color buttonAccentHovered = Color(0xFF83D28A);

  static const Color buttonSecondary = Color(0xFF5D7795);
  static const Color buttonSecondaryHovered = Color(0xFF83A7D2);
}
