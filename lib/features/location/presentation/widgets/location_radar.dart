// features/location/presentation/widgets/location_radar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationRadar extends StatefulWidget {
  final bool active;
  final IconData icon;
  final Color ringColor;
  final Color pinColor;

  const LocationRadar({
    super.key,
    required this.active,
    this.icon = Icons.my_location_rounded,
    required this.ringColor,
    required this.pinColor,
  });

  @override
  State<LocationRadar> createState() => _LocationRadarState();
}

class _LocationRadarState extends State<LocationRadar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200));
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant LocationRadar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 220.w;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _RadarPainter(
              progress: _controller.value,
              active: widget.active,
              ringColor: widget.ringColor,
            ),
            child: Center(
              child: Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.pinColor.withValues(alpha: 0.16),
                  border: Border.all(color: widget.pinColor, width: 2),
                ),
                child: Icon(widget.icon, color: widget.pinColor, size: 32.sp),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  final bool active;
  final Color ringColor;

  _RadarPainter(
      {required this.progress, required this.active, required this.ringColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;

    if (!active) {
      final paint = Paint()
        ..color = ringColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;
      canvas.drawCircle(center, maxRadius * 0.55, paint);
      return;
    }

    for (var i = 0; i < 3; i++) {
      final phase = (progress + i / 3) % 1.0;
      final radius = maxRadius * (0.3 + phase * 0.7);
      final opacity = (1.0 - phase).clamp(0.0, 1.0) * 0.55;
      final paint = Paint()
        ..color = ringColor.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.active != active;
}
