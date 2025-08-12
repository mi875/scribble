import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';

/// A custom painter that draws row lines for constraint modes.
class ConstrainedRowLinePainter extends CustomPainter {
  /// Creates a new constrained row line painter.
  const ConstrainedRowLinePainter({
    required this.paperWidth,
    required this.paperHeight,
    required this.lineSpacing,
    required this.lineColor,
    required this.lineWidth,
    required this.leftMargin,
    required this.rightMargin,
    required this.topMargin,
    required this.bottomMargin,
    this.sketch,
    this.proximityRadius = 40,
    this.fadeDistance = 80,
    this.isDynamic = false,
  });

  /// The width of the paper.
  final double paperWidth;

  /// The height of the paper.
  final double paperHeight;

  /// The spacing between row lines.
  final double lineSpacing;

  /// The color of the row lines.
  final Color lineColor;

  /// The width of the row lines.
  final double lineWidth;

  /// The left margin for the row lines.
  final double leftMargin;

  /// The right margin for the row lines.
  final double rightMargin;

  /// The top margin for the row lines.
  final double topMargin;

  /// The bottom margin for the row lines.
  final double bottomMargin;


  /// Optional sketch for dynamic line behavior.
  final Sketch? sketch;

  /// The radius around drawing points that affects line visibility.
  final double proximityRadius;

  /// The distance over which lines fade in/out.
  final double fadeDistance;

  /// Whether to use dynamic line behavior.
  final bool isDynamic;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Calculate the number of lines that can fit
    final availableHeight = paperHeight - topMargin - bottomMargin;
    final numberOfLines = (availableHeight / lineSpacing).floor();

    // Draw row lines
    for (int i = 0; i < numberOfLines; i++) {
      final y = topMargin + (i * lineSpacing);
      
      double opacity = 1.0;
      
      // Apply dynamic behavior if sketch is provided
      if (isDynamic && sketch != null) {
        opacity = _calculateLineOpacity(y);
      }

      linePaint.color = lineColor.withValues(alpha: opacity);
      linePaint.strokeWidth = lineWidth;

      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(paperWidth - rightMargin, y),
        linePaint,
      );
    }
  }

  /// Calculates the opacity of a line based on proximity to drawing content.
  double _calculateLineOpacity(double lineY) {
    if (sketch == null) return 1.0;

    double minDistance = double.infinity;

    // Find the minimum distance to any drawn point
    for (final line in sketch!.lines) {
      for (final point in line.points) {
        final distance = (point.y - lineY).abs();
        if (distance < minDistance) {
          minDistance = distance;
        }
      }
    }

    // If no content exists, show lines with low opacity
    if (minDistance == double.infinity) {
      return 0.1;
    }

    // Calculate opacity based on proximity
    if (minDistance <= proximityRadius) {
      return 1.0;
    } else if (minDistance <= proximityRadius + fadeDistance) {
      final fadeProgress = (minDistance - proximityRadius) / fadeDistance;
      return ui.lerpDouble(1.0, 0.1, fadeProgress) ?? 0.1;
    } else {
      return 0.1;
    }
  }

  @override
  bool shouldRepaint(ConstrainedRowLinePainter oldDelegate) {
    return paperWidth != oldDelegate.paperWidth ||
        paperHeight != oldDelegate.paperHeight ||
        lineSpacing != oldDelegate.lineSpacing ||
        lineColor != oldDelegate.lineColor ||
        lineWidth != oldDelegate.lineWidth ||
        leftMargin != oldDelegate.leftMargin ||
        rightMargin != oldDelegate.rightMargin ||
        topMargin != oldDelegate.topMargin ||
        bottomMargin != oldDelegate.bottomMargin ||
        sketch != oldDelegate.sketch ||
        proximityRadius != oldDelegate.proximityRadius ||
        fadeDistance != oldDelegate.fadeDistance ||
        isDynamic != oldDelegate.isDynamic;
  }
}