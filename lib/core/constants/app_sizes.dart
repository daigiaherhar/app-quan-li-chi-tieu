import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

extension AppSizesExtension on BuildContext {
  static final Expando<AppSizeScheme> _cache = Expando<AppSizeScheme>();

  /// Sử dụng: context.sizes.s16 (Tự động scale & Cache)
  AppSizeScheme get sizes {
    return _cache[this] ??= AppSizeScheme._(this);
  }
}

class AppSizeScheme {
  AppSizeScheme._(this.context);
  final BuildContext context;

  // --- Spacing (Scale theo chiều rộng) ---
  double get s2 => AppSizesStatic.s2.w(context);
  double get s4 => AppSizesStatic.s4.w(context);
  double get s8 => AppSizesStatic.s8.w(context);
  double get s12 => AppSizesStatic.s12.w(context);
  double get s16 => AppSizesStatic.s16.w(context);
  double get s20 => AppSizesStatic.s20.w(context);
  double get s24 => AppSizesStatic.s24.w(context);
  double get s32 => AppSizesStatic.s32.w(context);

  // --- Radius ---
  double get r4 => AppSizesStatic.r4;
  double get r8 => AppSizesStatic.r8;
  double get r12 => AppSizesStatic.r12;
  double get r16 => AppSizesStatic.r16;
  double get rCircle => AppSizesStatic.rCircle;

  // --- Icons ---
  double get i16 => AppSizesStatic.i16.w(context);
  double get i20 => AppSizesStatic.i20.w(context);
  double get i24 => AppSizesStatic.i24.w(context);
  double get i32 => AppSizesStatic.i32.w(context);
}

class AppSizesStatic {
  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;

  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r24 = 24.0;
  static const double rCircle = 99.0;

  static const double i16 = 16.0;
  static const double i20 = 20.0;
  static const double i24 = 24.0;
  static const double i32 = 32.0;
}
