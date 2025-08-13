import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';

/// A custom painter that draws dynamic row lines based on writing activity.
/// 
/// This painter shows lines that appear near content areas and fade based
/// on proximity to drawn content.
class DynamicRowLinePainter extends CustomPainter {
  /// Creates a new dynamic row line painter.
  const DynamicRowLinePainter({
    required this.paperWidth,
    required this.paperHeight,
    required this.lineSpacing,
    required this.lineColor,
    required this.lineWidth,
    required this.sketch,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.proximityRadius = 50.0,
    this.fadeDistance = 100.0,
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

  /// The sketch containing drawn content.
  final Sketch? sketch;

  /// Left margin in logical pixels.
  final double leftMargin;

  /// Right margin in logical pixels.
  final double rightMargin;

  /// Top margin in logical pixels.
  final double topMargin;

  /// Bottom margin in logical pixels.
  final double bottomMargin;

  /// Radius around content where lines appear at full opacity.
  final double proximityRadius;

  /// Distance over which lines fade out.
  final double fadeDistance;

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

    // Get all content points from the sketch
    final contentPoints = _getContentPoints();

    // Calculate the number of lines that fit within the drawing area
    final availableHeight = drawingBottom - drawingTop;
    final numberOfLines = (availableHeight / lineSpacing).floor();

    // Draw each row line with dynamic opacity
    for (int i = 0; i < numberOfLines; i++) {
      final y = drawingTop + (i * lineSpacing);
      if (y > drawingBottom) break;

      // Calculate opacity based on proximity to content
      final opacity = _calculateLineOpacity(y, contentPoints);
      
      if (opacity > 0.01) { // Only draw visible lines
        final paint = Paint()
          ..color = lineColor.withValues(alpha: opacity)
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(drawingLeft, y),
          Offset(drawingRight, y),
          paint,
        );
      }
    }
  }

  /// Gets all content points from the sketch.
  List<Offset> _getContentPoints() {
    final points = <Offset>[];
    if (sketch == null) return points;

    for (final line in sketch!.lines) {
      for (final point in line.points) {
        points.add(Offset(point.x, point.y));
      }
    }
    return points;
  }

  /// Calculates the opacity for a line based on proximity to content.
  double _calculateLineOpacity(double lineY, List<Offset> contentPoints) {
    if (contentPoints.isEmpty) return 0.1; // Very faint when no content

    // Find the minimum distance to any content point
    double minDistance = double.infinity;
    for (final point in contentPoints) {
      final distance = (point.dy - lineY).abs();
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    // Calculate opacity based on distance
    if (minDistance <= proximityRadius) {
      return 1.0; // Full opacity near content
    } else if (minDistance <= proximityRadius + fadeDistance) {
      // Fade out over distance
      final fadeProgress = (minDistance - proximityRadius) / fadeDistance;
      return (1.0 - fadeProgress).clamp(0.1, 1.0);
    } else {
      return 0.1; // Minimum visibility for distant lines
    }
  }

  @override
  bool shouldRepaint(DynamicRowLinePainter oldDelegate) {
    return oldDelegate.paperWidth != paperWidth ||
        oldDelegate.paperHeight != paperHeight ||
        oldDelegate.lineSpacing != lineSpacing ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.sketch != sketch ||
        oldDelegate.leftMargin != leftMargin ||
        oldDelegate.rightMargin != rightMargin ||
        oldDelegate.topMargin != topMargin ||
        oldDelegate.bottomMargin != bottomMargin ||
        oldDelegate.proximityRadius != proximityRadius ||
        oldDelegate.fadeDistance != fadeDistance;
  }
}