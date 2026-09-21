import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The ring the home page uses to show progress towards a total.
///
/// Drawn rather than exported: the arc's length is the data, so a fixed SVG
/// could only ever show one value. The colours and thicknesses come from the
/// design's own ring assets.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.diameter,
    required this.progress,
    this.thickness,
    this.color = AppColors.olive500,
    this.trackColor = AppColors.moss900,
    this.trackOpacity = 0.04,
    this.startAngle = -math.pi / 2,
    this.sweep = math.pi * 2,
    this.child,
  });

  final double diameter;

  /// 0–1. Values outside are clamped, so an over-achieved goal still reads.
  final double progress;

  /// Defaults to a tenth of the diameter, matching the design's rings.
  final double? thickness;

  final Color color;
  final Color trackColor;
  final double trackOpacity;

  /// Where the arc starts. Twelve o'clock by default.
  final double startAngle;

  /// How far a full ring travels. The passport ring is left open at one side.
  final double sweep;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: diameter,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0, 1).toDouble(),
          thickness: thickness ?? diameter / 10,
          color: color,
          trackColor: trackColor.withValues(alpha: trackOpacity),
          startAngle: startAngle,
          sweep: sweep,
        ),
        child: child == null ? null : Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.thickness,
    required this.color,
    required this.trackColor,
    required this.startAngle,
    required this.sweep,
  });

  final double progress;
  final double thickness;
  final Color color;
  final Color trackColor;
  final double startAngle;
  final double sweep;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = thickness / 2;
    final arcRect = rect.deflate(inset);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(arcRect, startAngle, sweep, false, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(arcRect, startAngle, sweep * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.thickness != thickness ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.startAngle != startAngle ||
      old.sweep != sweep;
}
