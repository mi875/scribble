import 'package:flutter/material.dart';

/// A basic custom painter that draws row lines on paper.
/// 
/// This painter draws evenly spaced horizontal lines across the paper,
/// useful for lined notebook paper effects.
class RowLinePainter extends CustomPainter {
  /// Creates a new row line painter.
  const RowLinePainter({
    required this.paperWidth,
    required this.paperHeight,
    required this.lineSpacing,
    required this.lineColor,
    required this.lineWidth,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.regions = const [],
  });

  /// Width of the paper in logical pixels.
  final double paperWidth;

  /// Height of the paper in logical pixels.
  final double paperHeight;

  /// Spacing between row lines in logical pixels.
  final double lineSpacing;

  /// Color of the row lines.
  final Color lineColor;

  /// Width of the row lines in logical pixels.
  final double lineWidth;

  /// Left margin in logical pixels.
  final double leftMargin;

  /// Right margin in logical pixels.
  final double rightMargin;

  /// Top margin in logical pixels.
  final double topMargin;

  /// Bottom margin in logical pixels.
  final double bottomMargin;

  /// List of regions (unused in simplified version, kept for compatibility).
  final List regions;

  @override
  void paint(Canvas canvas, Size size) {
    if (lineSpacing <= 0) return;

    // Calculate drawing bounds with margins
    final drawingLeft = leftMargin;
    final drawingRight = paperWidth - rightMargin;
    final drawingTop = topMargin;
    final drawingBottom = paperHeight - bottomMargin;

    // Don't draw if margins make drawing area invalid
    if (drawingLeft >= drawingRight || drawingTop >= drawingBottom) return;

    // Create paint for the lines
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Calculate the number of lines that fit within the drawing area
    final availableHeight = drawingBottom - drawingTop;
    final numberOfLines = (availableHeight / lineSpacing).floor();

    // Draw each row line
    for (int i = 0; i < numberOfLines; i++) {
      final y = drawingTop + (i * lineSpacing);
      if (y > drawingBottom) break;

      canvas.drawLine(
        Offset(drawingLeft, y),
        Offset(drawingRight, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RowLinePainter oldDelegate) {
    return oldDelegate.paperWidth != paperWidth ||
        oldDelegate.paperHeight != paperHeight ||
        oldDelegate.lineSpacing != lineSpacing ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.leftMargin != leftMargin ||
        oldDelegate.rightMargin != rightMargin ||
        oldDelegate.topMargin != topMargin ||
        oldDelegate.bottomMargin != bottomMargin;
  }
}