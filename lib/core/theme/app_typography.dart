import 'package:flutter/material.dart';

/// Typography tokens extracted from the Figma design system.
///
/// Font families:
///   - SF Pro Display → headings (H1–H4)
///   - SF Pro Text    → headings (H5–H6), body, labels
///
/// On Android / web the closest system fallback is used automatically.
/// To ship the exact fonts, add them to `assets/fonts/` and register
/// in `pubspec.yaml`, then update [_fontDisplay] / [_fontText].
abstract final class AppTypography {
  static const String _fontDisplay = 'SF Pro Display';
  static const String _fontText = 'SF Pro Text';

  // ── Headings ─────────────────────────────────────────────────────────

  static const TextStyle h1 = TextStyle(
    fontFamily: _fontDisplay,
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.2, // 57.6 px
    letterSpacing: -2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontDisplay,
    fontWeight: FontWeight.w700,
    fontSize: 40,
    height: 1.2, // 48 px
    letterSpacing: -2,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontDisplay,
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.4, // 44.8 px
    letterSpacing: -2,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontDisplay,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.33, // 32 px
    letterSpacing: 0,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.4, // 28 px
    letterSpacing: 0,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.4, // 25.2 px
    letterSpacing: 0,
  );

  // ── Body Large (18 px) ──────────────────────────────────────────────

  static const TextStyle bodyBold18 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium18 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyRegular18 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 1.55,
    letterSpacing: 0,
  );

  // ── Body Medium (16 px) ─────────────────────────────────────────────

  static const TextStyle bodyBold16 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium16 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.6,
    letterSpacing: 0,
  );

  static const TextStyle bodyRegular16 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.6,
    letterSpacing: 0,
  );

  // ── Body Small (14 px) ──────────────────────────────────────────────

  static const TextStyle bodyBold14 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium14 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyRegular14 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.55,
    letterSpacing: 0,
  );

  // ── Body XSmall (12 px) ─────────────────────────────────────────────

  static const TextStyle bodyBold12 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium12 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.55,
    letterSpacing: 0,
  );

  static const TextStyle bodyRegular12 = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.55,
    letterSpacing: 0,
  );

  // ── Button ──────────────────────────────────────────────────────────

  static const TextStyle button = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5, // 24 px
    letterSpacing: 0.16,
  );

  // ── Label / Caption ─────────────────────────────────────────────────

  static const TextStyle label = TextStyle(
    fontFamily: _fontText,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.55,
    letterSpacing: 0,
  );
}
