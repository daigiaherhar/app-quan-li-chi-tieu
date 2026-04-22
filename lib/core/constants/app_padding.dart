import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/constants/app_sizes.dart';

extension AppPaddingExtension on BuildContext {
  static final Expando<AppPaddingScheme> _cache = Expando<AppPaddingScheme>();

  /// Sử dụng: context.padding.all16 (Tự động scale & Cache)
  AppPaddingScheme get padding {
    return _cache[this] ??= AppPaddingScheme._(this);
  }
}

class AppPaddingScheme {
  AppPaddingScheme._(this.context);
  final BuildContext context;

  EdgeInsets get all4 => EdgeInsets.all(AppSizesStatic.s4.w(context));
  EdgeInsets get all8 => EdgeInsets.all(AppSizesStatic.s8.w(context));
  EdgeInsets get all12 => EdgeInsets.all(AppSizesStatic.s12.w(context));
  EdgeInsets get all16 => EdgeInsets.all(AppSizesStatic.s16.w(context));
  EdgeInsets get all20 => EdgeInsets.all(AppSizesStatic.s20.w(context));
  EdgeInsets get all24 => EdgeInsets.all(AppSizesStatic.s24.w(context));

  EdgeInsets get h8 => EdgeInsets.symmetric(horizontal: AppSizesStatic.s8.w(context));
  EdgeInsets get h12 => EdgeInsets.symmetric(horizontal: AppSizesStatic.s12.w(context));
  EdgeInsets get h16 => EdgeInsets.symmetric(horizontal: AppSizesStatic.s16.w(context));

  EdgeInsets get v8 => EdgeInsets.symmetric(vertical: AppSizesStatic.s8.h(context));
  EdgeInsets get v12 => EdgeInsets.symmetric(vertical: AppSizesStatic.s12.h(context));
  EdgeInsets get v16 => EdgeInsets.symmetric(vertical: AppSizesStatic.s16.h(context));
}
