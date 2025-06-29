import 'package:flutter/material.dart';

/// A custom painter that draws a dot grid background.
/// The dots help users visualize the zoom level and provide spatial reference.
class DotGridPainter extends CustomPainter {
  /// Creates a dot grid painter.
  const DotGridPainter({
    this.scaleFactor = 1.0,
    this.panOffset = Offset.zero,
    this.canvasSize,
    this.dotSpacing = 20.0,
    this.dotColor = const Color(0x1A000000), // 10% opacity black
    this.dotRadius = 1.0,
  });

  /// The current zoom scale factor.
  final double scaleFactor;

  /// The current pan offset.
  final Offset panOffset;

  /// The size of the canvas. If null, dots fill the entire paint area.
  final Size? canvasSize;

  /// The spacing between dots in logical pixels (at 100% zoom).
  final double dotSpacing;

  /// The color of the dots.
  final Color dotColor;

  /// The radius of each dot in logical pixels.
  final double dotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // If we have a canvas size constraint, clip to it
    if (canvasSize != null) {
      canvas
          .clipRect(Rect.fromLTWH(0, 0, canvasSize!.width, canvasSize!.height));
    }

    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Calculate the effective canvas size for dot placement
    final effectiveSize = canvasSize ?? size;

    // Instead of applying transformations to the canvas, we'll calculate
    // the dot positions in screen space to maintain correct zoom centering

    // Calculate the visible area in logical canvas coordinates
    final viewBounds = Rect.fromLTWH(
      -panOffset.dx / scaleFactor,
      -panOffset.dy / scaleFactor,
      size.width / scaleFactor,
      size.height / scaleFactor,
    );

    // Expand bounds slightly to ensure dots at edges are drawn
    final expandedBounds = viewBounds.inflate(dotSpacing);

    // Calculate the grid bounds within the effective canvas
    final gridBounds =
        Rect.fromLTWH(0, 0, effectiveSize.width, effectiveSize.height)
            .intersect(expandedBounds);

    // Calculate starting positions to align dots with grid
    final startX = (gridBounds.left / dotSpacing).floor() * dotSpacing;
    final startY = (gridBounds.top / dotSpacing).floor() * dotSpacing;

    // Draw the dot grid by transforming each dot position to screen coordinates
    for (double x = startX; x <= gridBounds.right; x += dotSpacing) {
      for (double y = startY; y <= gridBounds.bottom; y += dotSpacing) {
        // Only draw dots within the effective canvas bounds
        if (x >= 0 &&
            x <= effectiveSize.width &&
            y >= 0 &&
            y <= effectiveSize.height) {
          // Transform the logical dot position to screen coordinates
          final screenX = x * scaleFactor + panOffset.dx;
          final screenY = y * scaleFactor + panOffset.dy;

          // Only draw if the transformed position is within the visible area
          if (screenX >= -dotRadius &&
              screenX <= size.width + dotRadius &&
              screenY >= -dotRadius &&
              screenY <= size.height + dotRadius) {
            canvas.drawCircle(
                Offset(screenX, screenY), dotRadius * scaleFactor, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(DotGridPainter oldDelegate) {
    return scaleFactor != oldDelegate.scaleFactor ||
        panOffset != oldDelegate.panOffset ||
        canvasSize != oldDelegate.canvasSize ||
        dotSpacing != oldDelegate.dotSpacing ||
        dotColor != oldDelegate.dotColor ||
        dotRadius != oldDelegate.dotRadius;
  }
}
