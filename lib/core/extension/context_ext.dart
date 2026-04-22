import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  // --- Theme & Media Queries ---
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Lưu ý: Các thuộc tính .colors, .sizes, .padding, .gap, .textStyles 
  // hiện đã được cung cấp trực tiếp qua các extension riêng biệt 
  // nằm trong thư mục lib/core/constants/.
}
