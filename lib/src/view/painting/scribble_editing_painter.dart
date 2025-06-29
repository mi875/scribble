import 'package:flutter/rendering.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/point_to_offset_x.dart';
import 'package:scribble/src/view/painting/sketch_line_path_mixin.dart';

/// {@template scribble_editing_painter}
/// A painter for drawing the currently active line of a scribble sketch, as
/// well as the pointer when in drawing or erasing mode, if desired.
/// {@endtemplate}
class ScribbleEditingPainter extends CustomPainter with SketchLinePathMixin {
  /// {@macro scribble_editing_painter}
  ScribbleEditingPainter({
    required this.state,
    required this.drawPointer,
    required this.drawEraser,
    this.fixedStrokeWidth,
    this.canvasSize,
  });

  /// The current state of the scribble sketch
  final ScribbleState state;

  /// Whether to draw the pointer when in drawing mode.
  ///
  /// The pointer will be drawn as a filled circle with the currently selected
  /// color.
  final bool drawPointer;

  /// Whether to draw the pointer when in erasing mode
  ///
  /// The pointer will be drawn as a transparent circle with a black border.
  final bool drawEraser;

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

    // Clip to canvas bounds if canvas size is specified
    if (canvasSize != null) {
      canvas
          .clipRect(Rect.fromLTWH(0, 0, canvasSize!.width, canvasSize!.height));
    }

    // Apply zoom and pan transformations
    canvas.save();
    canvas.translate(state.panOffset.dx, state.panOffset.dy);
    canvas.scale(state.scaleFactor);

    final activeLine = switch (state) {
      Drawing(activeLine: final activeLine) => activeLine,
      Erasing() => null,
    };
    if (activeLine != null) {
      // Use fixed width if specified, adjusted for scale factor to maintain visual consistency
      final effectiveLine = fixedStrokeWidth != null
          ? activeLine.copyWith(width: fixedStrokeWidth! / state.scaleFactor)
          : activeLine.copyWith(width: activeLine.width / state.scaleFactor);

      final path = getPathForLine(
        effectiveLine,
        scaleFactor:
            1.0, // Don't apply scale factor again since canvas is already scaled
      );
      if (path != null) {
        paint.color = Color(effectiveLine.color);
        canvas.drawPath(path, paint);
      }
    }

    if (state.pointerPosition != null &&
        (state is Drawing && drawPointer || state is Erasing && drawEraser)) {
      paint
        ..style = switch (state) {
          Drawing() => PaintingStyle.fill,
          Erasing() => PaintingStyle.stroke,
        }
        ..color = switch (state) {
          Drawing(:final selectedColor) => Color(selectedColor),
          Erasing() => const Color(0xFF000000),
        }
        ..strokeWidth = 1;
      canvas.drawCircle(
        state.pointerPosition!.asOffset,
        (fixedStrokeWidth ?? state.selectedWidth) / state.scaleFactor / 2,
        paint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(ScribbleEditingPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.fixedStrokeWidth != fixedStrokeWidth ||
        oldDelegate.canvasSize != canvasSize;
  }
}
