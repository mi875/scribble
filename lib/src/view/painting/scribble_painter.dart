import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/sketch_line_cache_mixin.dart';
import 'package:scribble/src/view/painting/sketch_line_path_mixin.dart';

/// A painter for drawing a scribble sketch.
class ScribblePainter extends CustomPainter
    with SketchLinePathMixin, SketchLineCacheMixin {
  /// Creates a new [ScribblePainter] instance.
  ScribblePainter({
    required this.sketch,
    required this.scaleFactor,
    required this.panOffset,
    this.fixedStrokeWidth,
    this.canvasSize,
  });

  /// The [Sketch] to draw.
  final Sketch sketch;

  /// {@macro view.state.scribble_state.scale_factor}
  final double scaleFactor;

  /// {@macro view.state.scribble_state.pan_offset}
  final Offset panOffset;

  @override
  final bool simulatePressure = false; // Always false for fixed width strokes

  /// Fixed stroke width for all lines. When specified, all strokes will
  /// use this width regardless of their original width.
  final double? fixedStrokeWidth;

  /// The size of the canvas for clipping. If null, no clipping is applied.
  final Size? canvasSize;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final startTime = DateTime.now();

    // Clip to canvas bounds if canvas size is specified
    if (canvasSize != null) {
      canvas
          .clipRect(Rect.fromLTWH(0, 0, canvasSize!.width, canvasSize!.height));
    }

    // Apply zoom and pan transformations
    canvas.save();
    canvas.translate(panOffset.dx, panOffset.dy);
    canvas.scale(scaleFactor);

    for (var i = 0; i < sketch.lines.length; ++i) {
      final line = sketch.lines[i];

      // Use fixed width if specified, but don't adjust for scale factor
      // The scale factor is already applied to the canvas, so we need to
      // counteract it to maintain consistent visual stroke width
      final effectiveLine = fixedStrokeWidth != null
          ? line.copyWith(width: fixedStrokeWidth! / scaleFactor)
          : line.copyWith(width: line.width / scaleFactor);

      if (line.cachedImage != null && fixedStrokeWidth == null) {
        // If we have a cached image and no fixed width override, use it
        final bounds = _getBoundsForLine(line);
        drawCachedLine(canvas, line, bounds);
      } else {
        // Otherwise generate the path and draw it
        final path = getPathForLine(
          effectiveLine,
          scaleFactor:
              1.0, // Don't apply scale factor again since canvas is already scaled
        );
        if (path == null) {
          continue;
        }
        paint.color = Color(effectiveLine.color);
        paint.isAntiAlias = true; // Enable anti-aliasing for smoother lines
        paint.filterQuality = FilterQuality.high; // Use high quality filtering
        canvas.drawPath(path, paint);
      }
    }

    canvas.restore();

    final endTime = DateTime.now();
    final renderTime = endTime.difference(startTime).inMilliseconds;

    // Only log if rendering took significant time (more than 16ms - one frame)
    if (sketch.lines.length > 10 && renderTime > 16) {
      print(
          'Rendered ${sketch.lines.length} lines in ${renderTime}ms, cached: ${sketch.lines.where((l) => l.cachedImage != null).length}');
    }
  }

  /// Get bounds for a line to position the cached image
  Rect _getBoundsForLine(SketchLine line) {
    if (line.points.isEmpty) return Rect.zero;

    // Calculate bounds using scale factor 1.0 since canvas is already scaled
    final logicalPath = getPathForLine(line, scaleFactor: 1.0);
    if (logicalPath == null) return Rect.zero;
    final strokeBounds = logicalPath.getBounds();

    // Use the line's actual width for padding calculation
    final padding = line.width / 2;

    // The destination rectangle for drawImageRect
    return Rect.fromLTRB(
      strokeBounds.left - padding,
      strokeBounds.top - padding,
      strokeBounds.right + padding,
      strokeBounds.bottom + padding,
    );
  }

  @override
  bool shouldRepaint(ScribblePainter oldDelegate) {
    return oldDelegate.sketch != sketch ||
        oldDelegate.scaleFactor != scaleFactor ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.fixedStrokeWidth != fixedStrokeWidth ||
        oldDelegate.canvasSize != canvasSize;
  }
}
