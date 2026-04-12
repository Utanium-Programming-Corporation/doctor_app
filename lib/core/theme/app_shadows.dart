import 'package:flutter/material.dart';

/// Elevation / shadow tokens extracted from the Figma design system.
abstract final class AppShadows {
  /// XSmall — subtle elevation for inputs, chips.
  static const List<BoxShadow> xs = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(13, 13, 18, 0.06),
    ),
  ];

  /// Small — cards at rest.
  static const List<BoxShadow> sm = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      color: Color.fromRGBO(13, 13, 18, 0.05),
    ),
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(13, 13, 18, 0.04),
    ),
  ];

  /// Medium — raised cards, navbar.
  static const List<BoxShadow> md = [
    BoxShadow(
      offset: Offset(0, 5),
      blurRadius: 10,
      spreadRadius: -2,
      color: Color.fromRGBO(13, 13, 18, 0.04),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -1,
      color: Color.fromRGBO(13, 13, 18, 0.02),
    ),
  ];

  /// Large — modals, dropdowns.
  static const List<BoxShadow> lg = [
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 16,
      spreadRadius: -4,
      color: Color.fromRGBO(13, 13, 18, 0.08),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
      color: Color.fromRGBO(13, 13, 18, 0.03),
    ),
  ];

  /// XLarge — dialogs, floating action panels.
  static const List<BoxShadow> xl = [
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
      color: Color.fromRGBO(13, 13, 18, 0.18),
    ),
  ];

  /// XXLarge — full-screen overlays.
  static const List<BoxShadow> xxl = [
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
      color: Color.fromRGBO(13, 13, 18, 0.18),
    ),
  ];

  /// Navbar upward shadow (from Figma navbar_light).
  static const List<BoxShadow> navBar = [
    BoxShadow(
      offset: Offset(0, -5),
      blurRadius: 10,
      color: Color.fromRGBO(13, 13, 18, 0.04),
    ),
    BoxShadow(
      offset: Offset(0, -4),
      blurRadius: 8,
      color: Color.fromRGBO(13, 13, 18, 0.02),
    ),
  ];
}
