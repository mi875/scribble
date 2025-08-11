import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';

/// A custom painter that draws line numbers on the left margin of 
/// notebook pages.
///
/// This painter renders sequential line numbers in a vertical column on the 
/// left side. In dynamic mode, line numbers appear only near content areas 
/// and fade based on proximity.
class LineNumberPainter extends CustomPainter {
  /// Creates a new line number painter.
  const LineNumberPainter({
    required this.paperWidth,
    required this.paperHeight,
    required this.textColor,
    required this.fontSize,
    this.leftMargin = 0.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.numberWidth = 40.0,
    this.startLineNumber = 1,
    this.rowLineSpacing,
    this.sketch,
    this.isDynamic = false,
    this.proximityRadius = 50.0,
    this.fadeDistance = 100.0,
  });

  /// Width of the paper in logical pixels.
  final double paperWidth;

  /// Height of the paper in logical pixels.
  final double paperHeight;

  /// Color of the line numbers.
  final Color textColor;

  /// Font size for the line numbers.
  final double fontSize;

  /// Left margin where numbers should start.
  final double leftMargin;

  /// Top margin where numbers should not be drawn.
  final double topMargin;

  /// Bottom margin where numbers should not be drawn.
  final double bottomMargin;

  /// Width allocated for line numbers.
  final double numberWidth;

  /// Starting line number (usually 1).
  final int startLineNumber;

  /// Spacing between row lines (if available) to synchronize numbering.
  final double? rowLineSpacing;

  /// The sketch containing drawn content (for dynamic mode).
  final Sketch? sketch;

  /// Whether to use dynamic visibility based on content proximity.
  final bool isDynamic;

  /// Radius around content where numbers appear at full opacity.
  final double proximityRadius;

  /// Distance over which numbers fade out.
  final double fadeDistance;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the drawing area height for line numbers
    final drawingTop = topMargin;
    final drawingBottom = paperHeight - bottomMargin;
    final availableHeight = drawingBottom - drawingTop;

    // Don't draw if margins make drawing area invalid
    if (drawingTop >= drawingBottom || availableHeight <= 0) return;

    // Use row line spacing if available, otherwise use default spacing
    final lineSpacing = rowLineSpacing ?? 32.0;
    final maxLines = (availableHeight / lineSpacing).floor();

    // Get content points for dynamic mode
    final contentPoints = isDynamic && sketch != null 
        ? _getContentPoints() : <Offset>[];

    // Draw all line numbers between the row lines
    for (num i = 0; i < maxLines; i++) {
      final currentLine = startLineNumber + i;
      // Position number between current and next row line
      final betweenRowsY = drawingTop + (i * lineSpacing) + (lineSpacing / 2);

      // Don't draw numbers beyond the bottom margin
      if (betweenRowsY > drawingBottom) break;

      // Calculate opacity for dynamic mode
      final opacity = isDynamic 
          ? _calculateNumberOpacity(betweenRowsY, contentPoints, i.toInt())
          : 1.0;

      // Skip drawing if too transparent
      if (opacity < 0.01) continue;

      // Set up text style with calculated opacity
      final textStyle = TextStyle(
        color: textColor.withValues(alpha: opacity),
        fontSize: fontSize,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w400,
      );

      // Create text painter for the line number
      final textPainter = TextPainter(
        text: TextSpan(text: currentLine.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: numberWidth - 4);

      // Position number in the left margin, right-aligned with some padding
      final textX = leftMargin + numberWidth - textPainter.width - 4;
      // Center the text vertically between row lines
      final textY = betweenRowsY - (textPainter.height / 2);

      // Draw the line number
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  /// Extracts all points from the sketch for proximity calculations.
  List<Offset> _getContentPoints() {
    if (sketch == null) return [];
    
    final points = <Offset>[];
    
    for (final line in sketch!.lines) {
      for (final point in line.points) {
        points.add(Offset(point.x, point.y));
      }
    }
    
    return points;
  }

  /// Calculates line number opacity based on proximity to content and progressive appearance.
  double _calculateNumberOpacity(double numberY, List<Offset> contentPoints, int lineIndex) {
    // Always show the first two line numbers at full opacity initially
    if (lineIndex == 0) {
      return 1.0;
    }
    if (lineIndex == 1) {
      return 1.0;
    }

    if (contentPoints.isEmpty) {
      // If no content, only show the first two line numbers
      return 0.0;
    }

    // Find the lowest content point (highest Y value) to determine progression
    double maxContentY = contentPoints.isEmpty ? 0.0 : contentPoints.first.dy;
    for (final point in contentPoints) {
      if (point.dy > maxContentY) {
        maxContentY = point.dy;
      }
    }

    // Calculate which line the content has reached based on progression
    final lineSpacing = rowLineSpacing ?? 32.0;
    final contentLineIndex = ((maxContentY - topMargin) / lineSpacing).floor();
    
    // Show line numbers progressively: if content has reached line N, show numbers 1 through N+2
    if (lineIndex <= contentLineIndex + 2) {
      // Find the closest content point to this line number
      var minDistance = double.infinity;
      
      for (final point in contentPoints) {
        final distance = (point.dy - numberY).abs();
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      // Calculate opacity based on distance for visible line numbers
      if (minDistance <= proximityRadius) {
        // Full opacity near content
        return 1.0;
      } else if (minDistance <= proximityRadius + fadeDistance) {
        // Fade out over distance
        final fadeProgress = (minDistance - proximityRadius) / fadeDistance;
        return (1 - fadeProgress).clamp(0.3, 1.0);
      } else {
        // Medium opacity for distant but revealed line numbers
        return 0.3;
      }
    } else {
      // Line numbers beyond the progression are not shown
      return 0.0;
    }
  }

  @override
  bool shouldRepaint(LineNumberPainter oldDelegate) {
    return paperWidth != oldDelegate.paperWidth ||
        paperHeight != oldDelegate.paperHeight ||
        textColor != oldDelegate.textColor ||
        fontSize != oldDelegate.fontSize ||
        leftMargin != oldDelegate.leftMargin ||
        topMargin != oldDelegate.topMargin ||
        bottomMargin != oldDelegate.bottomMargin ||
        numberWidth != oldDelegate.numberWidth ||
        startLineNumber != oldDelegate.startLineNumber ||
        rowLineSpacing != oldDelegate.rowLineSpacing ||
        sketch != oldDelegate.sketch ||
        isDynamic != oldDelegate.isDynamic ||
        proximityRadius != oldDelegate.proximityRadius ||
        fadeDistance != oldDelegate.fadeDistance;
  }
}
