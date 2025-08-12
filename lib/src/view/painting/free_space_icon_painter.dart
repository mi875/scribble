import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/region/region_type.dart';

/// A custom painter that draws free space icons on the left margin
/// for free drawing regions.
///
/// This painter renders small icons in the left margin area to indicate
/// free drawing regions and provides visual feedback for user interaction.
class FreeSpaceIconPainter extends CustomPainter {
  /// Creates a new free space icon painter.
  const FreeSpaceIconPainter({
    required this.regions,
    required this.leftMargin,
    required this.iconColor,
    this.iconSize = 16.0,
    this.iconOpacity = 0.6,
    this.highlightedRegion,
    this.highlightColor = Colors.blue,
  });

  /// List of regions to render icons for.
  final List<PageRegion> regions;

  /// Left margin width where icons should be positioned.
  final double leftMargin;

  /// Base color for the icons.
  final Color iconColor;

  /// Size of the icons in logical pixels.
  final double iconSize;

  /// Default opacity for the icons.
  final double iconOpacity;

  /// The region that should be highlighted (e.g., on hover/tap).
  final PageRegion? highlightedRegion;

  /// Color to use for highlighting.
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Only render icons for free drawing regions
    final freeDrawingRegions = regions
        .where((region) => region.type == RegionType.freeDrawing)
        .toList();

    for (final region in freeDrawingRegions) {
      _paintRegionIcon(canvas, region);
    }
  }

  /// Paints an icon for a single free drawing region.
  void _paintRegionIcon(Canvas canvas, PageRegion region) {
    final bounds = region.bounds;
    final isHighlighted = region == highlightedRegion;
    
    // Calculate icon position - center vertically in the region,
    // positioned in the left margin
    final iconX = leftMargin / 2 - iconSize / 2;
    final iconY = bounds.center.dy - iconSize / 2;
    
    // Create icon bounds
    final iconBounds = Rect.fromLTWH(iconX, iconY, iconSize, iconSize);
    
    // Determine colors based on highlight state
    final currentIconColor = isHighlighted 
        ? highlightColor 
        : iconColor.withValues(alpha: iconOpacity);
    final currentBackgroundColor = isHighlighted
        ? highlightColor.withValues(alpha: 0.1)
        : Colors.transparent;
    
    // Draw background circle if highlighted
    if (isHighlighted) {
      final backgroundPaint = Paint()
        ..color = currentBackgroundColor
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        iconBounds.center,
        iconSize * 0.7,
        backgroundPaint,
      );
    }
    
    // Draw the free space icon based on the preset type
    _drawFreeSpaceIcon(canvas, iconBounds, currentIconColor, region.preset);
  }

  /// Draws the specific icon for a free drawing region.
  void _drawFreeSpaceIcon(
    Canvas canvas, 
    Rect iconBounds, 
    Color color,
    FreeDrawingPreset? preset,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (preset) {
      case FreeDrawingPreset.math:
        _drawMathIcon(canvas, iconBounds, paint);
      case FreeDrawingPreset.graph:
        _drawGraphIcon(canvas, iconBounds, paint);
      case FreeDrawingPreset.diagram:
        _drawDiagramIcon(canvas, iconBounds, paint);
      case FreeDrawingPreset.sketch:
        _drawSketchIcon(canvas, iconBounds, paint);
      case FreeDrawingPreset.custom:
        _drawDefaultIcon(canvas, iconBounds, paint, fillPaint);
      case null:
        _drawDefaultIcon(canvas, iconBounds, paint, fillPaint);
    }
  }

  /// Draws a math formula icon (Σ symbol).
  void _drawMathIcon(Canvas canvas, Rect bounds, Paint paint) {
    final path = Path();
    final centerX = bounds.center.dx;
    final centerY = bounds.center.dy;
    final size = bounds.width * 0.6;
    
    // Draw a simplified Σ (sigma) symbol
    path
      ..moveTo(centerX - size * 0.3, centerY - size * 0.4)
      ..lineTo(centerX + size * 0.3, centerY - size * 0.4)
      ..lineTo(centerX - size * 0.1, centerY)
      ..lineTo(centerX + size * 0.3, centerY + size * 0.4)
      ..lineTo(centerX - size * 0.3, centerY + size * 0.4);
    
    canvas.drawPath(path, paint);
  }

  /// Draws a graph/chart icon (line graph).
  void _drawGraphIcon(Canvas canvas, Rect bounds, Paint paint) {
    final centerX = bounds.center.dx;
    final centerY = bounds.center.dy;
    final size = bounds.width * 0.6;
    
    // Draw axes
    canvas
      ..drawLine(
        Offset(centerX - size * 0.4, centerY + size * 0.4),
        Offset(centerX + size * 0.4, centerY + size * 0.4),
        paint,
      )
      ..drawLine(
        Offset(centerX - size * 0.4, centerY + size * 0.4),
        Offset(centerX - size * 0.4, centerY - size * 0.4),
        paint,
      );
    
    // Draw a simple line graph
    final path = Path()
      ..moveTo(centerX - size * 0.3, centerY + size * 0.2)
      ..lineTo(centerX - size * 0.1, centerY - size * 0.1)
      ..lineTo(centerX + size * 0.1, centerY + size * 0.1)
      ..lineTo(centerX + size * 0.3, centerY - size * 0.3);
    
    canvas.drawPath(path, paint);
  }

  /// Draws a diagram icon (connected nodes).
  void _drawDiagramIcon(Canvas canvas, Rect bounds, Paint paint) {
    final centerX = bounds.center.dx;
    final centerY = bounds.center.dy;
    final size = bounds.width * 0.5;
    
    // Draw connecting lines first
    canvas
      ..drawLine(
        Offset(centerX - size * 0.3, centerY - size * 0.3),
        Offset(centerX + size * 0.3, centerY + size * 0.3),
        paint,
      )
      ..drawLine(
        Offset(centerX + size * 0.3, centerY - size * 0.3),
        Offset(centerX - size * 0.3, centerY + size * 0.3),
        paint,
      );
    
    // Draw nodes
    final nodePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;
    
    canvas
      ..drawCircle(
          Offset(centerX - size * 0.3, centerY - size * 0.3), 2, nodePaint,)
      ..drawCircle(
          Offset(centerX + size * 0.3, centerY - size * 0.3), 2, nodePaint,)
      ..drawCircle(
          Offset(centerX - size * 0.3, centerY + size * 0.3), 2, nodePaint,)
      ..drawCircle(
          Offset(centerX + size * 0.3, centerY + size * 0.3), 2, nodePaint,);
  }

  /// Draws a sketch/freehand icon (wavy line).
  void _drawSketchIcon(Canvas canvas, Rect bounds, Paint paint) {
    final centerX = bounds.center.dx;
    final centerY = bounds.center.dy;
    final size = bounds.width * 0.6;
    
    // Draw a wavy/sketchy line
    final path = Path()
      ..moveTo(centerX - size * 0.4, centerY + size * 0.1)
      ..quadraticBezierTo(
        centerX - size * 0.2, centerY - size * 0.2,
        centerX, centerY + size * 0.1,
      )
      ..quadraticBezierTo(
        centerX + size * 0.2, centerY + size * 0.4,
        centerX + size * 0.4, centerY - size * 0.1,
      );
    
    canvas.drawPath(path, paint);
  }

  /// Draws a default free space icon (rectangle with corner marks).
  void _drawDefaultIcon(
    Canvas canvas, 
    Rect bounds, 
    Paint paint, 
    Paint fillPaint,
  ) {
    final centerX = bounds.center.dx;
    final centerY = bounds.center.dy;
    final size = bounds.width * 0.6;
    
    // Draw a rectangle outline
    final rect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: size * 0.8,
      height: size * 0.6,
    );
    
    canvas.drawRect(rect, paint);
    
    // Draw corner marks to indicate free drawing area
    final cornerSize = size * 0.1;
    canvas
      ..drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.left + cornerSize, rect.top),
        paint,
      )
      ..drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.left, rect.top + cornerSize),
        paint,
      )
      ..drawLine(
        Offset(rect.right, rect.bottom),
        Offset(rect.right - cornerSize, rect.bottom),
        paint,
      )
      ..drawLine(
        Offset(rect.right, rect.bottom),
        Offset(rect.right, rect.bottom - cornerSize),
        paint,
      );
  }

  /// Checks if a point is within an icon's hit area.
  bool isPointInIcon(Offset point, PageRegion region) {
    final bounds = region.bounds;
    final iconX = leftMargin / 2 - iconSize / 2;
    final iconY = bounds.center.dy - iconSize / 2;
    final iconBounds = Rect.fromLTWH(iconX, iconY, iconSize, iconSize);
    
    // Add some padding for easier tapping
    final hitBounds = iconBounds.inflate(8);
    return hitBounds.contains(point);
  }

  /// Finds the region for an icon at the given point.
  PageRegion? getRegionAtPoint(Offset point) {
    final freeDrawingRegions = regions
        .where((region) => region.type == RegionType.freeDrawing)
        .toList();
    
    for (final region in freeDrawingRegions) {
      if (isPointInIcon(point, region)) {
        return region;
      }
    }
    
    return null;
  }

  @override
  bool shouldRepaint(FreeSpaceIconPainter oldDelegate) {
    return regions != oldDelegate.regions ||
        leftMargin != oldDelegate.leftMargin ||
        iconColor != oldDelegate.iconColor ||
        iconSize != oldDelegate.iconSize ||
        iconOpacity != oldDelegate.iconOpacity ||
        highlightedRegion != oldDelegate.highlightedRegion ||
        highlightColor != oldDelegate.highlightColor;
  }
}
