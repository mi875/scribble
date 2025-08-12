import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';
import 'package:scribble/src/view/painting/region_aware_painter_mixin.dart';

/// A custom painter that draws dynamic row lines based on writing activity.
/// 
/// This painter shows lines that appear near content areas and fade based
/// on proximity to drawn content. It can skip lines in free drawing regions.
class DynamicRowLinePainter extends CustomPainter with RegionAwarePainterMixin {
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
    this.regions = const <PageRegion>[],
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
  final Sketch sketch;

  /// Left margin where lines should not be drawn.
  final double leftMargin;

  /// Right margin where lines should not be drawn.
  final double rightMargin;

  /// Top margin where lines should not be drawn.
  final double topMargin;

  /// Bottom margin where lines should not be drawn.
  final double bottomMargin;

  /// Radius around content where lines appear at full opacity.
  final double proximityRadius;

  /// Distance over which lines fade out.
  final double fadeDistance;

  /// List of regions on the page that affect line rendering.
  @override
  final List<PageRegion> regions;

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

    // Draw horizontal lines with dynamic opacity
    for (int i = 0; i <= numberOfLines; i++) {
      final y = drawingTop + (i * lineSpacing);
      
      // Don't draw lines beyond the bottom margin
      if (y > drawingBottom) break;

      // Calculate opacity based on proximity to content and line progression
      final opacity = _calculateLineOpacity(y, contentPoints, i);
      
      if (opacity > 0.01) {  // Only draw if visible enough
        final paint = Paint()
          ..color = lineColor.withValues(alpha: opacity)
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;
        
        // If there are no free drawing regions, draw the full line
        if (!hasFreeDrawingRegions) {
          canvas.drawLine(
            Offset(drawingLeft, y),
            Offset(drawingRight, y),
            paint,
          );
        } else {
          // Draw line segments that don't intersect with free drawing regions
          final segments = getDrawableLineSegments(
            lineY: y,
            fullStartX: drawingLeft,
            fullEndX: drawingRight,
          );
          
          for (final (startX, endX) in segments) {
            if (endX > startX) {
              canvas.drawLine(
                Offset(startX, y),
                Offset(endX, y),
                paint,
              );
            }
          }
        }
      }
    }
  }

  /// Extracts all points from the sketch for proximity calculations.
  List<Offset> _getContentPoints() {
    final points = <Offset>[];
    
    for (final line in sketch.lines) {
      for (final point in line.points) {
        points.add(Offset(point.x, point.y));
      }
    }
    
    return points;
  }

  /// Calculates line opacity based on proximity to content and progressive appearance.
  double _calculateLineOpacity(double lineY, List<Offset> contentPoints, int lineIndex) {
    // Always show the first two row lines at full opacity initially
    if (lineIndex == 0) {
      return 1.0;
    }
    if (lineIndex == 1) {
      return 1.0;
    }

    if (contentPoints.isEmpty) {
      // If no content, only show the first two lines
      return 0.0;
    }

    // Find the lowest content point (highest Y value) to determine progression
    double maxContentY = contentPoints.isEmpty ? 0.0 : contentPoints.first.dy;
    for (final point in contentPoints) {
      if (point.dy > maxContentY) {
        maxContentY = point.dy;
      }
    }

    // Calculate which line this content has reached based on progression
    final contentLineIndex = ((maxContentY - topMargin) / lineSpacing).floor();
    
    // Show lines progressively: if content has reached line N, show lines 0 through N+2
    if (lineIndex <= contentLineIndex + 2) {
      // Find the closest content point to this specific line
      double minDistance = double.infinity;
      
      for (final point in contentPoints) {
        final distance = (point.dy - lineY).abs();
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      // Calculate opacity based on distance for visible lines
      if (minDistance <= proximityRadius) {
        // Full opacity near content
        return 1.0;
      } else if (minDistance <= proximityRadius + fadeDistance) {
        // Fade out over distance
        final fadeProgress = (minDistance - proximityRadius) / fadeDistance;
        return (1.0 - fadeProgress).clamp(0.3, 1.0);
      } else {
        // Medium opacity for distant but revealed lines
        return 0.3;
      }
    } else {
      // Lines beyond the progression are not shown
      return 0.0;
    }
  }

  @override
  bool shouldRepaint(DynamicRowLinePainter oldDelegate) {
    return paperWidth != oldDelegate.paperWidth ||
           paperHeight != oldDelegate.paperHeight ||
           lineSpacing != oldDelegate.lineSpacing ||
           lineColor != oldDelegate.lineColor ||
           lineWidth != oldDelegate.lineWidth ||
           sketch != oldDelegate.sketch ||
           leftMargin != oldDelegate.leftMargin ||
           rightMargin != oldDelegate.rightMargin ||
           topMargin != oldDelegate.topMargin ||
           bottomMargin != oldDelegate.bottomMargin ||
           proximityRadius != oldDelegate.proximityRadius ||
           fadeDistance != oldDelegate.fadeDistance ||
           regions != oldDelegate.regions;
  }
}
