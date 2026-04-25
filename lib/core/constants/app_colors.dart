import 'package:flutter/material.dart';

extension AppColorsExtension on BuildContext {
  /// Sử dụng: context.colors.primary
  AppColorScheme get colors => AppColorScheme._fromTheme(Theme.of(this));
}

class AppColorScheme {
  AppColorScheme._fromTheme(this._theme);

  final ThemeData _theme;

  bool get isDark => _theme.brightness == Brightness.dark;

  // --- Brand ---
  Color get primary => AppColorsStatic.primary;
  Color get primaryLight => AppColorsStatic.primaryLight;
  Color get secondary => AppColorsStatic.secondary;
  Color get background => isDark
      ? AppColorsStatic.scaffoldBackgroundDark
      : AppColorsStatic.background;
  Color get surface =>
      isDark ? AppColorsStatic.surfaceDark : AppColorsStatic.surface;
  Color get error => AppColorsStatic.error;

  // --- Text ---
  Color get textPrimary =>
      isDark ? AppColorsStatic.onPrimary : AppColorsStatic.textPrimary;
  Color get textSecondary =>
      isDark ? AppColorsStatic.dockTabIconMuted : AppColorsStatic.textSecondary;

  // --- Card Gradients ---
  List<Color> get walletGradient => [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)];
  List<Color> get incomeGradient => [const Color(0xFF10B981), const Color(0xFF34D399)];
  List<Color> get expenseGradient => [const Color(0xFFEF4444), const Color(0xFFF87171)];

  // --- Dashboard Hero Card (Light Indigo) ---
  List<Color> get heroGradient => const <Color>[
        Color(0xFF6366F1),
        Color(0xFF8B5CF6),
      ];
  Color get heroAccent => const Color(0xFFA5B4FC);

  // --- Income / Expense semantic ---
  Color get income => const Color(0xFF22C55E);
  Color get expense => const Color(0xFFEF4444);
  Color get incomeSurface => const Color(0xFFE6F9EF);
  Color get expenseSurface => const Color(0xFFFDECEC);

  // --- Quick action pastel surfaces ---
  Color get pastelIndigo => const Color(0xFFEEF2FF);
  Color get pastelAmber => const Color(0xFFFFF7E6);
  Color get pastelPink => const Color(0xFFFFE9F0);
  Color get pastelMint => const Color(0xFFE6F9F2);

  Color get pastelIndigoOn => const Color(0xFF4F46E5);
  Color get pastelAmberOn => const Color(0xFFD97706);
  Color get pastelPinkOn => const Color(0xFFDB2777);
  Color get pastelMintOn => const Color(0xFF059669);

  // --- Dashboard surfaces ---
  Color get dashboardBackground =>
      isDark ? AppColorsStatic.scaffoldBackgroundDark : const Color(0xFFF6F7FB);
  Color get cardSurface =>
      isDark ? AppColorsStatic.surfaceDark : Colors.white;
  Color get cardShadow =>
      isDark ? const Color(0x66000000) : const Color(0x14000000);

  // --- On colors (nội dung trên nền brand / dock) ---
  Color get onPrimary => AppColorsStatic.onPrimary;
  Color get onSecondary => AppColorsStatic.onSecondary;

  // --- Dock tab bar (root) ---
  Color get dockTabBar => AppColorsStatic.dockTabBar;
  Color get dockTabIconMuted => AppColorsStatic.dockTabIconMuted;

  // --- Semantic ---
  Color get incomePositive => AppColorsStatic.incomePositive;

  // --- Chart / category (demo) ---
  Color get chartOrange => AppColorsStatic.chartOrange;

  Color get chartPurple => AppColorsStatic.chartPurple;

  Color get chartBlueGrey => AppColorsStatic.chartBlueGrey;
  Color get white => AppColorsStatic.white;

  // --- Utils ---
  Color get border => AppColorsStatic.border;

  Color get divider => AppColorsStatic.divider;
}

/// Bảng màu tĩnh — dùng trong `AppColorScheme` và chỗ cần `const` (model, default param).
class AppColorsStatic {
  AppColorsStatic._();

  // Brand
  static const Color primary = Color(0xFF34D399); // Soft Mint/Emerald
  static const Color primaryLight = Color(0xFF6EE7B7);
  static const Color secondary = Color(0xFF1F2937); // Dark Blue Grey

  // Surfaces
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color scaffoldBackgroundDark = Color(0xFF000000);

  // Content on primary / secondary (AppBar, gradient card, FAB)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Root dock bar
  static const Color dockTabBar = Color(0xFF0D0B26);
  static const Color dockTabIconMuted = Color(0xB3FFFFFF);

  // Semantic
  static const Color error = Color(0xFFD32F2F);
  static const Color incomePositive = Color(0xFF2E7D32);

  // Text (light)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Chart palette (demo)
  static const Color chartOrange = Color(0xFFF57C00);
  static const Color chartPurple = Color(0xFF6A1B9A);
  static const Color chartBlueGrey = Color(0xFF546E7A);

  // Utils
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  static const Color white = Colors.white;
}
