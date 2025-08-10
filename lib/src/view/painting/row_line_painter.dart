import 'package:flutter/material.dart';

/// A custom painter that draws horizontal row lines on notebook pages.
/// 
/// This painter is designed to render evenly spaced horizontal lines
/// across the width of the paper, similar to ruled notebook paper.
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

  /// Left margin where lines should not be drawn.
  final double leftMargin;

  /// Right margin where lines should not be drawn.
  final double rightMargin;

  /// Top margin where lines should not be drawn.
  final double topMargin;

  /// Bottom margin where lines should not be drawn.
  final double bottomMargin;

  @override
  void paint(Canvas canvas, Size size) {
    if (lineSpacing <= 0) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Calculate drawing bounds with margins
    final drawingLeft = leftMargin;
    final drawingRight = paperWidth - rightMargin;
    final drawingTop = topMargin;
    final drawingBottom = paperHeight - bottomMargin;

    // Don't draw if margins make drawing area invalid
    if (drawingLeft >= drawingRight || drawingTop >= drawingBottom) return;

    // Calculate the number of lines that fit within the drawing area
    final availableHeight = drawingBottom - drawingTop;
    final numberOfLines = (availableHeight / lineSpacing).floor();

    // Draw horizontal lines
    for (int i = 0; i <= numberOfLines; i++) {
      final y = drawingTop + (i * lineSpacing);
      
      // Don't draw lines beyond the bottom margin
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
    return paperWidth != oldDelegate.paperWidth ||
           paperHeight != oldDelegate.paperHeight ||
           lineSpacing != oldDelegate.lineSpacing ||
           lineColor != oldDelegate.lineColor ||
           lineWidth != oldDelegate.lineWidth ||
           leftMargin != oldDelegate.leftMargin ||
           rightMargin != oldDelegate.rightMargin ||
           topMargin != oldDelegate.topMargin ||
           bottomMargin != oldDelegate.bottomMargin;
  }
}
