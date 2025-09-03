import 'package:flutter/material.dart';
import '../models/tutorial_step.dart';

/// Custom painter for rendering the tutorial overlay with spotlight effect
class TutorialOverlayPainter extends CustomPainter {
  final Rect? spotlightRect;
  final TutorialStep step;
  final Animation<double> animation;

  TutorialOverlayPainter({
    this.spotlightRect,
    required this.step,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (spotlightRect == null) {
      // No spotlight, just paint the overlay
      _paintOverlay(canvas, size);
      return;
    }

    // Create the overlay with spotlight cutout
    _paintOverlayWithSpotlight(canvas, size);

    // Paint the spotlight border if specified
    if (step.borderColor != null && step.borderWidth > 0) {
      _paintSpotlightBorder(canvas);
    }
  }

  void _paintOverlay(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = step.overlayColor.withOpacity(
        step.overlayColor.opacity * animation.value,
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintOverlayWithSpotlight(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = step.overlayColor.withOpacity(
        step.overlayColor.opacity * animation.value,
      );

    // Create the full overlay path
    final overlayPath = Path()..addRect(Offset.zero & size);

    // Create the spotlight path based on shape
    final spotlightPath = _createSpotlightPath();

    // Subtract the spotlight from the overlay
    final finalPath = Path.combine(
      PathOperation.difference,
      overlayPath,
      spotlightPath,
    );

    canvas.drawPath(finalPath, overlayPaint);
  }

  Path _createSpotlightPath() {
    final rect = spotlightRect!;
    final path = Path();

    switch (step.shape) {
      case SpotlightShape.circle:
        final center = rect.center;
        final radius = (rect.width + rect.height) / 4;
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;

      case SpotlightShape.roundedRectangle:
        path.addRRect(
          RRect.fromRectAndRadius(
            rect,
            Radius.circular(step.borderRadius),
          ),
        );
        break;

      case SpotlightShape.rectangle:
        path.addRect(rect);
        break;
    }

    return path;
  }

  void _paintSpotlightBorder(Canvas canvas) {
    if (spotlightRect == null) return;

    final borderPaint = Paint()
      ..color = (step.borderColor ?? Colors.white).withOpacity(animation.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = step.borderWidth;

    final rect = spotlightRect!;

    switch (step.shape) {
      case SpotlightShape.circle:
        final center = rect.center;
        final radius = (rect.width + rect.height) / 4;
        canvas.drawCircle(center, radius, borderPaint);
        break;

      case SpotlightShape.roundedRectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect,
            Radius.circular(step.borderRadius),
          ),
          borderPaint,
        );
        break;

      case SpotlightShape.rectangle:
        canvas.drawRect(rect, borderPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(TutorialOverlayPainter oldDelegate) {
    return oldDelegate.spotlightRect != spotlightRect ||
        oldDelegate.step != step ||
        oldDelegate.animation != animation;
  }
}
