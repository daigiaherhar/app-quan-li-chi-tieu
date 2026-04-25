import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/constants/app_sizes.dart';

extension AppGapExtension on BuildContext {
  static final Expando<AppGapScheme> _cache = Expando<AppGapScheme>();

  /// Sử dụng: context.gap.h16 (Tự động scale & Cache)
  AppGapScheme get gap {
    return _cache[this] ??= AppGapScheme._(this);
  }
}

class AppGapScheme {
  AppGapScheme._(this.context);
  final BuildContext context;

  // Vertical Gaps (Scale theo width để giữ tỷ lệ)
  Widget get h2 => SizedBox(height: AppSizesStatic.s2.w(context));
  Widget get h4 => SizedBox(height: AppSizesStatic.s4.w(context));
  Widget get h8 => SizedBox(height: AppSizesStatic.s8.w(context));
  Widget get h12 => SizedBox(height: AppSizesStatic.s12.w(context));
  Widget get h16 => SizedBox(height: AppSizesStatic.s16.w(context));
  Widget get h20 => SizedBox(height: AppSizesStatic.s20.w(context));
  Widget get h24 => SizedBox(height: AppSizesStatic.s24.w(context));
  Widget get h32 => SizedBox(height: AppSizesStatic.s32.w(context));

  // Horizontal Gaps (Width)
  Widget get w2 => SizedBox(width: AppSizesStatic.s2.w(context));
  Widget get w4 => SizedBox(width: AppSizesStatic.s4.w(context));
  Widget get w8 => SizedBox(width: AppSizesStatic.s8.w(context));
  Widget get w12 => SizedBox(width: AppSizesStatic.s12.w(context));
  Widget get w16 => SizedBox(width: AppSizesStatic.s16.w(context));
  Widget get w20 => SizedBox(width: AppSizesStatic.s20.w(context));
  Widget get w24 => SizedBox(width: AppSizesStatic.s24.w(context));
  Widget get w32 => SizedBox(width: AppSizesStatic.s32.w(context));
}
