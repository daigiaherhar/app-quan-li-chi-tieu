import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/constants/app_colors.dart';

extension AppStylesExtension on BuildContext {
  static final Expando<AppStyleScheme> _cache = Expando<AppStyleScheme>();

  /// Sử dụng: context.textStyles.h1
  AppStyleScheme get textStyles {
    return _cache[this] ??= AppStyleScheme._(this);
  }
}

class AppStyleScheme {
  AppStyleScheme._(this.context);
  final BuildContext context;

  // --- Headings ---
  TextStyle get h1 => TextStyle(
        fontSize: 32.w(context),
        fontWeight: FontWeight.bold,
        color: AppColorsStatic.textPrimary,
      );

  TextStyle get h2 => TextStyle(
        fontSize: 24.w(context),
        fontWeight: FontWeight.bold,
        color: AppColorsStatic.textPrimary,
      );

  TextStyle get h3 => TextStyle(
        fontSize: 20.w(context),
        fontWeight: FontWeight.bold,
        color: AppColorsStatic.textPrimary,
      );

  // --- Body Text ---
  TextStyle get bodyLarge => TextStyle(
        fontSize: 16.w(context),
        fontWeight: FontWeight.normal,
        color: AppColorsStatic.textPrimary,
      );

  TextStyle get bodyMedium => TextStyle(
        fontSize: 14.w(context),
        fontWeight: FontWeight.normal,
        color: AppColorsStatic.textPrimary,
      );

  TextStyle get bodySmall => TextStyle(
        fontSize: 12.w(context),
        fontWeight: FontWeight.normal,
        color: AppColorsStatic.textSecondary,
      );

  // --- Specialized ---
  TextStyle get label => TextStyle(
        fontSize: 10.w(context),
        fontWeight: FontWeight.w500,
        color: AppColorsStatic.textSecondary,
      );
}
