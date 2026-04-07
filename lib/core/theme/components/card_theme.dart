import 'package:flutter/material.dart';

import '../app_colors.dart';

abstract final class CardStyles {
  static CardThemeData get theme => CardThemeData(
    elevation: 0,
    color: AppColors.cardBackground,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    margin: EdgeInsets.zero,
  );
}
