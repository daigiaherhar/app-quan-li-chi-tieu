import 'package:flutter/material.dart';

extension AppColorsExtension on BuildContext {
  static final Expando<AppColorScheme> _cache = Expando<AppColorScheme>();

  /// Sử dụng: context.colors.primary
  AppColorScheme get colors {
    return _cache[this] ??= AppColorScheme._fromTheme(Theme.of(this));
  }
}

class AppColorScheme {
  AppColorScheme._fromTheme(this._theme);

  final ThemeData _theme;

  bool get isDark => _theme.brightness == Brightness.dark;

  // --- Main Colors ---
  Color get primary => AppColorsStatic.primary;
  Color get secondary => AppColorsStatic.secondary;
  Color get background => isDark ? Colors.black : AppColorsStatic.background;
  Color get surface => isDark ? const Color(0xFF1E1E1E) : AppColorsStatic.surface;
  Color get error => AppColorsStatic.error;

  // --- Text Colors ---
  Color get textPrimary => isDark ? Colors.white : AppColorsStatic.textPrimary;
  Color get textSecondary => isDark ? Colors.white70 : AppColorsStatic.textSecondary;

  // --- Utils ---
  Color get border => AppColorsStatic.border;
  Color get divider => AppColorsStatic.divider;
}

class AppColorsStatic {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFFFFA000);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
}
