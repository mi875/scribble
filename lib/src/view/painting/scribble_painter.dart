import 'package:flutter/rendering.dart';
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
    this.fixedStrokeWidth,
  });

  /// The [Sketch] to draw.
  final Sketch sketch;

  /// {@macro view.state.scribble_state.scale_factor}
  final double scaleFactor;

  @override
  final bool simulatePressure = false; // Always false for fixed width strokes

  /// Fixed stroke width for all lines. When specified, all strokes will
  /// use this width regardless of their original width.
  final double? fixedStrokeWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final startTime = DateTime.now();

    for (var i = 0; i < sketch.lines.length; ++i) {
      final line = sketch.lines[i];
      
      // Use fixed width if specified, otherwise use line's original width
      final effectiveLine = fixedStrokeWidth != null
          ? line.copyWith(width: fixedStrokeWidth!)
          : line;

      if (effectiveLine.cachedImage != null && fixedStrokeWidth == null) {
        // If we have a cached image and no fixed width override, use it
        final bounds = _getBoundsForLine(effectiveLine);
        drawCachedLine(canvas, effectiveLine, bounds);
      } else {
        // Otherwise generate the path and draw it
        final path = getPathForLine(
          effectiveLine,
          scaleFactor: scaleFactor,
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

    // Calculate bounds using the same scaleFactor as cache generation
    // This ensures consistency between cache creation and display bounds
    final logicalPath = getPathForLine(line, scaleFactor: scaleFactor);
    if (logicalPath == null) return Rect.zero;
    final strokeBounds = logicalPath.getBounds();

    // Use the same padding calculation as cache generation
    final padding = (line.width * scaleFactor) / 2;

    // The destination rectangle for drawImageRect should match the cached area
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
        oldDelegate.fixedStrokeWidth != fixedStrokeWidth;
  }
}
