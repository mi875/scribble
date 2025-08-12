import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/region/region_settings.dart';
import 'package:scribble/src/domain/model/region/region_type.dart';

/// A custom painter that draws visual indicators for page regions.
/// 
/// This painter renders backgrounds, borders, and grids for free drawing
/// regions to provide visual feedback to users about different drawing areas.
class RegionPainter extends CustomPainter {
  /// Creates a new region painter.
  const RegionPainter({
    required this.regions,
    this.showBackgrounds = true,
    this.showBorders = true,
    this.showGrids = false,
  });

  /// List of regions to render.
  final List<PageRegion> regions;

  /// Whether to show region backgrounds.
  final bool showBackgrounds;

  /// Whether to show region borders.
  final bool showBorders;

  /// Whether to show grid overlays for applicable regions.
  final bool showGrids;

  @override
  void paint(Canvas canvas, Size size) {
    // Only render free drawing regions
    final freeDrawingRegions = regions
        .where((region) => region.type == RegionType.freeDrawing)
        .toList();

    for (final region in freeDrawingRegions) {
      _paintRegion(canvas, region);
    }
  }

  /// Paints a single region with its visual indicators.
  void _paintRegion(Canvas canvas, PageRegion region) {
    final bounds = region.bounds;
    final settings = region.settings;

    // Draw background if enabled
    if (showBackgrounds && settings.showBackground && settings.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = settings.backgroundColor!.withValues(alpha: settings.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawRect(bounds, backgroundPaint);
    }

    // Draw grid if enabled for this region
    if (showGrids && settings.showGrid) {
      _paintGrid(canvas, bounds, settings);
    }

    // Draw borders if enabled
    if (showBorders && settings.showBorder) {
      // Draw prominent top and bottom border lines
      final prominentBorderPaint = Paint()
        ..color = settings.borderColor.withValues(alpha: settings.opacity * 1.5)
        ..strokeWidth = settings.borderWidth * 2
        ..style = PaintingStyle.stroke;
      
      // Top border line
      canvas
        ..drawLine(
          Offset(bounds.left, bounds.top),
          Offset(bounds.right, bounds.top),
          prominentBorderPaint,
        )
        // Bottom border line
        ..drawLine(
          Offset(bounds.left, bounds.bottom),
          Offset(bounds.right, bounds.bottom),
          prominentBorderPaint,
        );
      
      // Optional: Draw subtle side borders if desired
      final subtleBorderPaint = Paint()
        ..color = settings.borderColor.withValues(alpha: settings.opacity * 0.3)
        ..strokeWidth = settings.borderWidth * 0.5
        ..style = PaintingStyle.stroke;
      
      // Left border line
      canvas
        ..drawLine(
          Offset(bounds.left, bounds.top),
          Offset(bounds.left, bounds.bottom),
          subtleBorderPaint,
        )
        // Right border line
        ..drawLine(
          Offset(bounds.right, bounds.top),
          Offset(bounds.right, bounds.bottom),
          subtleBorderPaint,
        );
    }
  }

  /// Paints a grid overlay within the specified bounds.
  void _paintGrid(Canvas canvas, Rect bounds, RegionSettings settings) {
    final gridPaint = Paint()
      ..color = settings.gridColor.withValues(alpha: settings.opacity * 0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final spacing = settings.gridSpacing;

    // Draw vertical grid lines
    for (var x = bounds.left; x <= bounds.right; x += spacing) {
      if (x > bounds.left && x < bounds.right) {
        canvas.drawLine(
          Offset(x, bounds.top),
          Offset(x, bounds.bottom),
          gridPaint,
        );
      }
    }

    // Draw horizontal grid lines
    for (var y = bounds.top; y <= bounds.bottom; y += spacing) {
      if (y > bounds.top && y < bounds.bottom) {
        canvas.drawLine(
          Offset(bounds.left, y),
          Offset(bounds.right, y),
          gridPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(RegionPainter oldDelegate) {
    return regions != oldDelegate.regions ||
        showBackgrounds != oldDelegate.showBackgrounds ||
        showBorders != oldDelegate.showBorders ||
        showGrids != oldDelegate.showGrids;
  }
}
