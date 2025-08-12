import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';
import 'package:scribble/src/view/painting/region_aware_painter_mixin.dart';

/// A custom painter that draws row lines for constraint modes.
/// It can skip lines in free drawing regions when regions are provided.
class ConstrainedRowLinePainter extends CustomPainter with RegionAwarePainterMixin {
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
    this.proximityRadius = 50,
    this.fadeDistance = 100,
    this.isDynamic = false,
    this.regions = const <PageRegion>[],
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

  /// List of regions on the page that affect line rendering.
  @override
  final List<PageRegion> regions;

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

      // If there are no free drawing regions, draw the full line
      if (!hasFreeDrawingRegions) {
        canvas.drawLine(
          Offset(leftMargin, y),
          Offset(paperWidth - rightMargin, y),
          linePaint,
        );
      } else {
        // Draw line segments that don't intersect with free drawing regions
        final segments = getDrawableLineSegments(
          lineY: y,
          fullStartX: leftMargin,
          fullEndX: paperWidth - rightMargin,
        );
        
        for (final (startX, endX) in segments) {
          if (endX > startX) {
            canvas.drawLine(
              Offset(startX, y),
              Offset(endX, y),
              linePaint,
            );
          }
        }
      }
    }
  }

  /// Calculates the opacity of a line based on proximity to drawing content.
  double _calculateLineOpacity(double lineY) {
    if (sketch == null) return 1.0;

    // Calculate line index to implement first-lines logic
    final lineIndex = ((lineY - topMargin) / lineSpacing).round();
    
    // Always show the first two lines at full opacity
    if (lineIndex == 0 || lineIndex == 1) {
      return 1.0;
    }

    var minDistance = double.infinity;

    // Find the minimum distance to any drawn point
    for (final line in sketch!.lines) {
      for (final point in line.points) {
        final distance = (point.y - lineY).abs();
        if (distance < minDistance) {
          minDistance = distance;
        }
      }
    }

    // If no content exists, show lines with medium opacity (matching DynamicRowLinePainter)
    if (minDistance == double.infinity) {
      return 0.3;
    }

    // Calculate opacity based on proximity
    if (minDistance <= proximityRadius) {
      return 1.0;
    } else if (minDistance <= proximityRadius + fadeDistance) {
      final fadeProgress = 
          (minDistance - proximityRadius) / fadeDistance;
      return ui.lerpDouble(1, 0.3, fadeProgress) ?? 0.3;
    } else {
      return 0.3;
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
        isDynamic != oldDelegate.isDynamic ||
        regions != oldDelegate.regions;
  }
}
