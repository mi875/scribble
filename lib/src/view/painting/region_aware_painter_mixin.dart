import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/region/region_type.dart';

/// Mixin that provides region-aware functionality for custom painters.
/// 
/// This mixin provides utility methods for painters to detect and handle
/// page regions, allowing them to modify their rendering behavior based on
/// whether they are drawing in structured or free drawing areas.
mixin RegionAwarePainterMixin on CustomPainter {
  /// List of regions on the current page.
  List<PageRegion> get regions;

  /// Checks if a point falls within any free drawing region.
  bool isPointInFreeDrawingRegion(Offset point) {
    return regions
        .where((region) => region.type == RegionType.freeDrawing)
        .any((region) => region.contains(point));
  }

  /// Checks if a horizontal line segment should be drawn or skipped.
  /// 
  /// Returns false if the line segment intersects with any free drawing region,
  /// indicating that the segment should be skipped.
  bool shouldDrawLineSegment({
    required double lineY,
    required double startX,
    required double endX,
  }) {
    final freeDrawingRegions = regions
        .where((region) => region.type == RegionType.freeDrawing);

    for (final region in freeDrawingRegions) {
      // Check if line intersects vertically with the region
      if (lineY >= region.bounds.top && lineY <= region.bounds.bottom) {
        // Check if line intersects horizontally with the region
        if (!(endX < region.bounds.left || startX > region.bounds.right)) {
          return false; // Skip this segment
        }
      }
    }
    return true; // Draw the segment
  }

  /// Gets all free drawing regions that intersect with the given vertical range.
  List<PageRegion> getFreeDrawingRegionsInRange({
    required double minY,
    required double maxY,
  }) {
    return regions
        .where((region) => 
            region.type == RegionType.freeDrawing &&
            !(region.bounds.bottom < minY || region.bounds.top > maxY),)
        .toList();
  }

  /// Checks if a vertical position (like a line number position) falls
  /// within any free drawing region.
  bool isVerticalPositionInFreeDrawingRegion(double y) {
    return regions
        .where((region) => region.type == RegionType.freeDrawing)
        .any((region) => y >= region.bounds.top && y <= region.bounds.bottom);
  }

  /// Gets the horizontal segments of a line that should be drawn,
  /// excluding portions that intersect with free drawing regions.
  /// 
  /// Returns a list of (startX, endX) pairs representing the segments
  /// of the line that should be drawn.
  List<(double, double)> getDrawableLineSegments({
    required double lineY,
    required double fullStartX,
    required double fullEndX,
  }) {
    final segments = <(double, double)>[];
    
    // Get all free drawing regions that intersect with this line
    final intersectingRegions = regions
        .where((region) => 
            region.type == RegionType.freeDrawing &&
            lineY >= region.bounds.top && 
            lineY <= region.bounds.bottom,)
        .toList();

    if (intersectingRegions.isEmpty) {
      // No intersections, draw the full line
      return [(fullStartX, fullEndX)];
    }

    // Sort regions by left position
    intersectingRegions.sort((a, b) => a.bounds.left.compareTo(b.bounds.left));

    var currentX = fullStartX;
    
    for (final region in intersectingRegions) {
      // Add segment before this region (if any)
      if (currentX < region.bounds.left) {
        final segmentEnd = region.bounds.left.clamp(fullStartX, fullEndX);
        if (currentX < segmentEnd) {
          segments.add((currentX, segmentEnd));
        }
      }
      
      // Skip the region area
      currentX = region.bounds.right.clamp(fullStartX, fullEndX);
      
      if (currentX >= fullEndX) {
        break;
      }
    }
    
    // Add final segment after all regions (if any)
    if (currentX < fullEndX) {
      segments.add((currentX, fullEndX));
    }

    return segments;
  }

  /// Gets all structured regions (regions with lines and constraints).
  List<PageRegion> get structuredRegions {
    return regions
        .where((region) => region.type == RegionType.structured)
        .toList();
  }

  /// Gets all free drawing regions.
  List<PageRegion> get freeDrawingRegions {
    return regions
        .where((region) => region.type == RegionType.freeDrawing)
        .toList();
  }

  /// Checks if there are any regions defined on this page.
  bool get hasRegions => regions.isNotEmpty;

  /// Checks if there are any free drawing regions on this page.
  bool get hasFreeDrawingRegions {
    return regions.any((region) => region.type == RegionType.freeDrawing);
  }
}