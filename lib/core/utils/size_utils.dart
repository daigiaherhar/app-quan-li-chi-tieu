import 'package:flutter/material.dart';

class SizeUtils {
  SizeUtils._();

  /// Chiều rộng thiết kế gốc (Figma)
  static const double designWidth = 375.0;

  /// Ngưỡng chiều rộng tối đa để scale (Tránh quá to trên Web/Tablet)
  static const double maxMobileWidth = 600.0;

  static double getScaleWidth(BuildContext context, double width) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double effectiveWidth = screenWidth > maxMobileWidth ? maxMobileWidth : screenWidth;
    return (effectiveWidth / designWidth) * width;
  }

  static double getScaleHeight(BuildContext context, double height) {
    // Thường height ít khi cần scale theo tỷ lệ màn hình dài vì dễ gây tràn (overflow)
    // Nhưng nếu dùng, cũng nên giới hạn tương tự
    return (MediaQuery.sizeOf(context).height / 812) * height;
  }
}

extension SizeExtension on num {
  double h(BuildContext context) =>
      SizeUtils.getScaleHeight(context, toDouble());
  double w(BuildContext context) =>
      SizeUtils.getScaleWidth(context, toDouble());
}
