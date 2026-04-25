import 'package:flutter/material.dart';

/// Nền bo góc + lõm giữa cho FAB (theo path từ reference `RPSCustomPainter`).
class RootTabBarPainter extends CustomPainter {
  RootTabBarPainter({
    required this.fillColor,
  });

  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    const double hAll = 0.0;
    const double hGiotNuoc = -0.9;
    const double heSo = 0.0;
    const double wGiotNuoc = 2;
    final Path path0 = Path();

    path0.moveTo(size.width, size.height * hAll);
    path0.cubicTo(
      size.width,
      size.height * hAll,
      size.width,
      size.height * 0.2661356,
      size.width,
      size.height * 0.2937500,
    );
    path0.lineTo(size.width, size.height);
    path0.cubicTo(
      size.width,
      size.height,
      size.width,
      size.height,
      size.width,
      size.height,
    );
    path0.lineTo(0, size.height);
    path0.cubicTo(0, size.height, 0, size.height, 0, size.height);
    path0.lineTo(0, size.height * 0.2937500);
    path0.cubicTo(
      0,
      size.height * 0.2661356,
      0,
      size.height * hAll,
      0,
      size.height * hAll,
    );

    path0.lineTo(
      (size.width * 0.4129555 + heSo) / wGiotNuoc,
      size.height * hAll * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.4409049 + heSo) / (wGiotNuoc * 0.55),
      size.height * hAll * hGiotNuoc,
      (size.width * 0.4659089 + heSo) / (wGiotNuoc * 0.55),
      size.height * 0.3388869 * hGiotNuoc,
      (size.width * 0.4934028 + heSo),
      size.height * 0.3544106 * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.4955425 + heSo),
      size.height * 0.3556187 * hGiotNuoc,
      (size.width * 0.4977470 + heSo),
      size.height * 0.3562500 * hGiotNuoc,
      (size.width * 0.5000000 + heSo),
      size.height * 0.3562500 * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.5022530 + heSo),
      size.height * 0.3562500 * hGiotNuoc,
      size.width * 0.5044575 + heSo,
      size.height * 0.3556187 * hGiotNuoc,
      size.width * 0.5065972 + heSo,
      size.height * 0.3544106 * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.5340911 + heSo) / (wGiotNuoc * 0.46),
      size.height * 0.3388869 * hGiotNuoc,
      (size.width * 0.5590951 + heSo) / (wGiotNuoc * 0.499),
      size.height * hAll * hGiotNuoc,
      (size.width * 0.5870445 + heSo) * (wGiotNuoc * 0.8),
      size.height * hAll * hGiotNuoc,
    );
    path0.lineTo(size.width * 0.9028340 * heSo, size.height * hAll);
    path0.close();

    final Paint paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.8),
          Colors.white.withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path0, paint0Fill);

    // Thêm viền trắng mờ phía trên
    final Paint paintBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawPath(path0, paintBorder);
  }

  @override
  bool shouldRepaint(covariant RootTabBarPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor;
  }
}
