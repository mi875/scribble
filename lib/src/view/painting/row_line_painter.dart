import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/view/painting/region_aware_painter_mixin.dart';

/// A custom painter that draws horizontal row lines on notebook pages.
/// 
/// This painter is designed to render evenly spaced horizontal lines
/// across the width of the paper, similar to ruled notebook paper.
/// It can skip lines in free drawing regions when regions are provided.
class RowLinePainter extends CustomPainter with RegionAwarePainterMixin {
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

  /// Left margin where lines should not be drawn.
  final double leftMargin;

  /// Right margin where lines should not be drawn.
  final double rightMargin;

  /// Top margin where lines should not be drawn.
  final double topMargin;

  /// Bottom margin where lines should not be drawn.
  final double bottomMargin;

  /// List of regions on the page that affect line rendering.
  @override
  final List<PageRegion> regions;

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
      
      // If there are no regions or no free drawing regions, draw the full line
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
           bottomMargin != oldDelegate.bottomMargin ||
           regions != oldDelegate.regions;
  }
}
