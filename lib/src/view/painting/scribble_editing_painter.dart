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
    required this.simulatePressure,
    this.theme,
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
  /// The pointer will be drawn as a transparent circle with a border.
  /// The border color comes from the theme's eraserPointerColor.
  final bool drawEraser;

  /// Theme configuration for colors.
  final ScribbleTheme? theme;

  @override
  final bool simulatePressure;

  /// Adapts a stroke color based on the current theme.
  /// 
  /// In dark mode, converts black/very dark colors to white/light colors
  /// to ensure visibility against dark backgrounds.
  Color _adaptStrokeColor(Color originalColor) {
    if (theme == null || theme == ScribbleTheme.light) {
      return originalColor;
    }

    // In dark mode, adapt dark colors to light colors
    if (theme == ScribbleTheme.dark) {
      // Calculate relative luminance to determine if color is dark
      final luminance = originalColor.computeLuminance();
      
      // If the color is very dark (black or near-black), make it white
      if (luminance < 0.1) {
        return const Color(0xFFFFFFFF); // White
      }
      
      // If the color is somewhat dark, lighten it
      if (luminance < 0.3) {
        final hsl = HSLColor.fromColor(originalColor);
        return hsl.withLightness(
          (hsl.lightness + 0.4).clamp(0.0, 1.0),
        ).toColor();
      }
    }

    return originalColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final activeLine = state.map(
      drawing: (s) => s.activeLine,
      erasing: (_) => null,
    );
    if (activeLine != null) {
      final path = getPathForLine(
        activeLine,
        scaleFactor: state.scaleFactor,
      );
      if (path != null) {
        paint.color = _adaptStrokeColor(Color(activeLine.color));
        canvas.drawPath(path, paint);
      }
    }

    if (state.pointerPosition != null &&
        (state is Drawing && drawPointer || state is Erasing && drawEraser)) {
      paint
        ..style = state.map(
          drawing: (_) => PaintingStyle.fill,
          erasing: (_) => PaintingStyle.stroke,
        )
        ..color = state.map(
          drawing: (s) => _adaptStrokeColor(Color(s.selectedColor)),
          erasing: (s) => theme?.eraserPointerColor ?? const Color(0xFF000000),
        )
        ..strokeWidth = 1;
      canvas.drawCircle(
        state.pointerPosition!.asOffset,
        state.map(
          drawing: (s) => s.selectedWidth / state.scaleFactor,
          erasing: (s) => s.selectedEraserWidth / state.scaleFactor,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ScribbleEditingPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.simulatePressure != simulatePressure ||
        oldDelegate.theme != theme;
  }
}
