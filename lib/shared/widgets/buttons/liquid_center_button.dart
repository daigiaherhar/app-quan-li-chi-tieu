import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';

class LiquidCenterButton extends StatelessWidget {
  const LiquidCenterButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.size = 56,
    this.isOpen = false,
  });

  final VoidCallback onPressed;
  final IconData? icon;
  final double size;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final IconData effectiveIcon = icon ?? (isOpen ? Icons.remove : Icons.add);
    final Color buttonColor = isOpen ? context.colors.expense : context.colors.primary;

    return AnimatedContainer(
      duration: 300.ms,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: buttonColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: 300.ms,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  buttonColor.withValues(alpha: 0.9),
                  buttonColor.withValues(alpha: 0.7),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: AnimatedSwitcher(
                  duration: 250.ms,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: Icon(
                    effectiveIcon,
                    key: ValueKey(isOpen),
                    color: Colors.white,
                    size: size * 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
