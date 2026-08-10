// core/widgets/app_gradient_background.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;
  final bool showAmbientGlow;

  const AppGradientBackground({
    super.key,
    required this.child,
    this.showAmbientGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
        ),
      ),
      child: Stack(
        children: [
          if (showAmbientGlow) ...[
            Positioned(
              top: -90,
              right: -60,
              child: _glow(AppColors.accent.withValues(alpha: 0.22), 220),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: _glow(AppColors.primary.withValues(alpha: 0.28), 260),
            ),
          ],
          child,
        ],
      ),
    );
  }

  Widget _glow(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
