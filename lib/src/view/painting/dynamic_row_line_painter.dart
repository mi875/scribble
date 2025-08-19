import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/free_drawing_space/free_drawing_space.dart';
import 'package:scribble/src/domain/model/image_row/image_row.dart';
import 'package:scribble/src/domain/model/row/row.dart';
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
    required this.rows,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.proximityRadius = 50.0,
    this.fadeDistance = 100.0,
    this.regions = const [],
    this.freeDrawingSpaces = const [],
    this.imageRows = const [],
    this.highlightedRows = const {},
    this.highlightColor = const Color(0xFFFFEB3B),
    this.highlightOpacity = 0.3,
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

  /// Radius around content where lines appear at full opacity.
  final double proximityRadius;

  /// Distance over which lines fade out.
  final double fadeDistance;

  /// List of regions (unused in simplified version, kept for compatibility).
  final List regions;

  /// List of free drawing spaces where lines should not be drawn.
  final List<FreeDrawingSpace> freeDrawingSpaces;

  /// List of image rows where lines should not be drawn.
  final List<ImageRow> imageRows;

  /// Set of highlighted row indices.
  final Set<int> highlightedRows;

  /// Color for highlighted row backgrounds.
  final Color highlightColor;

  /// Opacity for highlighted row backgrounds.
  final double highlightOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (lineSpacing <= 0) return;

    // Calculate drawing bounds with margins
    final drawingLeft = leftMargin;
    final drawingRight = paperWidth - rightMargin;

    // Don't draw if margins make drawing area invalid
    if (drawingLeft >= drawingRight) return;

    // Paint row highlights first (behind everything else)
    _paintRowHighlights(canvas, drawingLeft, drawingRight);

    // Get all content points from the sketch
    final contentPoints = _getContentPoints();

    // Create dashed paint for free space borders
    final dashedPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.6)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw each row line with dynamic opacity
    for (final row in rows) {
      final y = row.startY;

      // Draw dashed lines within free drawing spaces instead of regular lines
      if (_isLineInFreeDrawingSpace(y)) {
        _drawDashedLine(
          canvas,
          Offset(drawingLeft, y),
          Offset(drawingRight, y),
          dashedPaint,
        );
        continue;
      }
      
      // Skip drawing lines within image rows
      if (_isLineInImageRow(y)) {
        continue;
      }

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

    // Note: Free space boundaries are now indicated by the dashed row lines
    // No need for additional top/bottom borders as they create visual clutter
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

  /// Gets the row index for a given Y coordinate.
  int _getRowIndexForY(double y) {
    if (y < topMargin) return -1;
    return ((y - topMargin) / lineSpacing).floor();
  }

  /// Gets the visible line number for a given Y coordinate, counting only text lines.
  /// Returns 0 if the Y coordinate is within an image row or before the first text line.
  int _getVisibleLineNumberForY(double y) {
    // Check if this Y coordinate is within an image row
    if (_isLineInImageRow(y)) {
      return 0; // Not a visible text line
    }
    
    // Calculate the raw row index
    final rowIndex = _getRowIndexForY(y);
    if (rowIndex < 0) return 0;
    
    // Count how many visible text lines come before this row
    int visibleLineCount = 0;
    
    // Iterate through all rows up to this row index
    for (int i = 0; i <= rowIndex; i++) {
      final rowY = topMargin + (i * lineSpacing);
      
      // Skip this row if it's within an image row
      if (_isLineInImageRow(rowY)) {
        continue;
      }
      
      // This is a visible text line
      visibleLineCount++;
      
      // If this is the row we're asking about, return the line number
      if (i == rowIndex) {
        return visibleLineCount;
      }
    }
    
    return visibleLineCount;
  }

  /// Paints row highlights for highlighted rows.
  void _paintRowHighlights(Canvas canvas, double drawingLeft, double drawingRight) {
    if (highlightedRows.isEmpty) return;

    final highlightPaint = Paint()
      ..color = highlightColor.withValues(alpha: highlightOpacity)
      ..style = PaintingStyle.fill;

    for (final row in rows) {
      if (highlightedRows.contains(row.index)) {
        // Calculate extended highlight area including free spaces
        double highlightStartY = row.startY;
        double highlightEndY = row.endY;
        
        // Find free spaces that belong to this row and extend the highlight
        for (final freeSpace in freeDrawingSpaces) {
          if (_freeSpaceBelongsToRow(freeSpace, row)) {
            // Extend highlight to include this free space
            highlightStartY = math.min(highlightStartY, freeSpace.startY);
            highlightEndY = math.max(highlightEndY, freeSpace.endY);
          }
        }
        
        // Find any chained free spaces that should also be included
        // (free spaces that start where the previous one ended)
        bool foundMoreSpaces = true;
        while (foundMoreSpaces) {
          foundMoreSpaces = false;
          for (final freeSpace in freeDrawingSpaces) {
            // Check if this free space is chained to our current highlight area
            const tolerance = 2.0;
            if (freeSpace.startY >= highlightEndY - tolerance && 
                freeSpace.startY <= highlightEndY + tolerance) {
              if (freeSpace.endY > highlightEndY) {
                highlightEndY = freeSpace.endY;
                foundMoreSpaces = true;
              }
            }
          }
        }
        
        // Paint the extended highlight area
        final highlightRect = Rect.fromLTRB(
          drawingLeft,
          highlightStartY,
          drawingRight,
          highlightEndY,
        );
        canvas.drawRect(highlightRect, highlightPaint);
      }
    }
  }

  /// Calculates the opacity for a line based on proximity to content.
  double _calculateLineOpacity(double lineY, List<Offset> contentPoints) {
    // Calculate which visible line number this corresponds to (ignoring image rows)
    final visibleLineNumber = _getVisibleLineNumberForY(lineY);
    
    // Always show first two visible text lines at full opacity (matching line numbers)
    if (visibleLineNumber == 1 || visibleLineNumber == 2) {
      return 1.0;
    }
    
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

  /// Checks if a line Y coordinate is within any free drawing space.
  bool _isLineInFreeDrawingSpace(double lineY) {
    return freeDrawingSpaces.any((space) => space.containsY(lineY));
  }

  /// Checks if a line Y coordinate is within any image row.
  bool _isLineInImageRow(double lineY) {
    return imageRows.any((imageRow) => imageRow.containsY(lineY));
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
        oldDelegate.fadeDistance != fadeDistance ||
        !_rowsEqual(oldDelegate.rows) ||
        !_freeDrawingSpacesEqual(oldDelegate.freeDrawingSpaces) ||
        !_imageRowsEqual(oldDelegate.imageRows) ||
        !_highlightedRowsEqual(oldDelegate.highlightedRows) ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.highlightOpacity != highlightOpacity;
  }

  /// Compares two lists of rows for equality.
  bool _rowsEqual(List<NotebookRow> other) {
    if (rows.length != other.length) return false;
    for (var i = 0; i < rows.length; i++) {
      if (rows[i] != other[i]) return false;
    }
    return true;
  }

  /// Compares two lists of free drawing spaces for equality.
  bool _freeDrawingSpacesEqual(List<FreeDrawingSpace> other) {
    if (freeDrawingSpaces.length != other.length) return false;
    for (int i = 0; i < freeDrawingSpaces.length; i++) {
      if (freeDrawingSpaces[i] != other[i]) return false;
    }
    return true;
  }

  /// Compares two lists of image rows for equality.
  bool _imageRowsEqual(List<ImageRow> other) {
    if (imageRows.length != other.length) return false;
    for (int i = 0; i < imageRows.length; i++) {
      if (imageRows[i] != other[i]) return false;
    }
    return true;
  }

  /// Compares two sets of highlighted rows for equality.
  bool _highlightedRowsEqual(Set<int> other) {
    if (highlightedRows.length != other.length) return false;
    return highlightedRows.every(other.contains);
  }

  /// Determines if a free drawing space belongs to a specific row.
  /// 
  /// A free space belongs to a row if:
  /// 1. The free space starts within the row bounds, OR
  /// 2. The free space starts immediately after the row ends (within small tolerance)
  bool _freeSpaceBelongsToRow(FreeDrawingSpace freeSpace, NotebookRow row) {
    const tolerance = 2.0; // Small tolerance for floating point precision
    
    // Case 1: Free space starts within row bounds
    if (freeSpace.startY >= row.startY && freeSpace.startY <= row.endY) {
      return true;
    }
    
    // Case 2: Free space starts immediately after row ends
    if (freeSpace.startY >= row.endY && 
        freeSpace.startY <= row.endY + tolerance) {
      return true;
    }
    
    return false;
  }


  /// Draws a dashed line between two points.
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    
    final direction = (end - start) / distance;
    
    for (int i = 0; i < dashCount; i++) {
      final dashStart = start + direction * (i * (dashWidth + dashSpace));
      final dashEnd = dashStart + direction * dashWidth;
      
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }
}
