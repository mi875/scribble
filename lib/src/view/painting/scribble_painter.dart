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
    required this.simulatePressure,
  });

  /// The [Sketch] to draw.
  final Sketch sketch;

  /// {@macro view.state.scribble_state.scale_factor}
  final double scaleFactor;

  @override
  final bool simulatePressure;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final startTime = DateTime.now();

    for (var i = 0; i < sketch.lines.length; ++i) {
      final line = sketch.lines[i];

      if (line.cachedImage != null) {
        // If we have a cached image, use it
        final bounds = _getBoundsForLine(line);
        drawCachedLine(canvas, line, bounds);
      } else {
        // Otherwise generate the path and draw it
        final path = getPathForLine(
          line,
          scaleFactor: scaleFactor,
        );
        if (path == null) {
          continue;
        }
        paint.color = Color(line.color);
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

    // Calculate bounds from the logical points of the line
    // This should match the `strokeBounds` used in `createCacheForLine`
    // before padding was applied there.
    // Use the SketchLinePathMixin directly available in ScribblePainter
    final logicalPath = getPathForLine(line, scaleFactor: 1.0);
    if (logicalPath == null) return Rect.zero;
    final strokeBounds = logicalPath.getBounds();

    // The padding should be the same logical padding used in `createCacheForLine`
    final padding = line.width / 2;

    // The destination rectangle for drawImageRect should be in logical pixels.
    // Flutter's canvas will handle scaling this to physical pixels using the
    // device pixel ratio (which is `this.scaleFactor` in the painter).
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
        oldDelegate.simulatePressure != simulatePressure ||
        oldDelegate.scaleFactor != scaleFactor;
  }
}
