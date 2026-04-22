import 'package:flutter/material.dart';

class SizeUtils {
  SizeUtils._();

  static double getScaleWidth(BuildContext context, double width) {
    return (MediaQuery.of(context).size.width / 375) * width;
  }

  static double getScaleHeight(BuildContext context, double height) {
    return (MediaQuery.of(context).size.height / 812) * height;
  }
}

extension SizeExtension on num {
  double h(BuildContext context) =>
      SizeUtils.getScaleHeight(context, toDouble());
  double w(BuildContext context) =>
      SizeUtils.getScaleWidth(context, toDouble());
}
