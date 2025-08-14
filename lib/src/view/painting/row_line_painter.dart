import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/row/row.dart';

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
    required this.rows,
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

  /// List of row objects with fixed positions.
  final List<NotebookRow> rows;

  /// Left margin in logical pixels.
  final double leftMargin;

  /// Right margin in logical pixels.
  final double rightMargin;

  /// Top margin in logical pixels.
  final double topMargin;

  /// Bottom margin in logical pixels.
  final double bottomMargin;

  /// List of regions (unused in simplified version, kept for compatibility).
  final List<dynamic> regions;

  @override
  void paint(Canvas canvas, Size size) {
    if (lineSpacing <= 0) return;

    // Calculate drawing bounds with margins
    final drawingLeft = leftMargin;
    final drawingRight = paperWidth - rightMargin;

    // Don't draw if margins make drawing area invalid
    if (drawingLeft >= drawingRight) return;

    // Create paint for the lines
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw each row line using Row objects
    for (final row in rows) {
      final y = row.startY;

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
        oldDelegate.bottomMargin != bottomMargin ||
        !_rowsEqual(oldDelegate.rows);
  }

  /// Compares two lists of rows for equality.
  bool _rowsEqual(List<NotebookRow> other) {
    if (rows.length != other.length) return false;
    for (var i = 0; i < rows.length; i++) {
      if (rows[i] != other[i]) return false;
    }
    return true;
  }
}