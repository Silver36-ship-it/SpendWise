import 'package:flutter/material.dart';

import 'app_theme.dart';

extension ThemeContextExtension on BuildContext {
  Color get accent =>
      Theme.of(this).colorScheme.primary;

  Color get surfaceCard =>
      Theme.of(this)
          .extension<AppThemeColors>()!
          .surfaceCard;

  Color get textPrimary =>
      Theme.of(this)
          .extension<AppThemeColors>()!
          .textPrimary;

  Color get mutedText =>
      Theme.of(this)
          .extension<AppThemeColors>()!
          .mutedText;

  Color get income =>
      Theme.of(this)
          .extension<AppThemeColors>()!
          .income;

  Color get expense =>
      Theme.of(this)
          .extension<AppThemeColors>()!
          .expense;
}