import 'package:flutter/material.dart';

import '../app_colors.dart';

abstract final class DividerStyles {
  static const DividerThemeData theme = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );
}
