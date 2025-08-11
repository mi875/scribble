import 'package:flutter/rendering.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/sketch_line_path_mixin.dart';

/// A painter for drawing a scribble sketch.
class ScribblePainter extends CustomPainter with SketchLinePathMixin {
  /// Creates a new [ScribblePainter] instance.
  ScribblePainter({
    required this.sketch,
    required this.scaleFactor,
    required this.simulatePressure,
    this.theme,
  });

  /// The [Sketch] to draw.
  final Sketch sketch;

  /// {@macro view.state.scribble_state.scale_factor}
  final double scaleFactor;

  /// Theme configuration for color adaptation.
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

    for (var i = 0; i < sketch.lines.length; ++i) {
      final path = getPathForLine(
        sketch.lines[i],
        scaleFactor: scaleFactor,
      );
      if (path == null) {
        continue;
      }
      paint.color = _adaptStrokeColor(Color(sketch.lines[i].color));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(ScribblePainter oldDelegate) {
    return oldDelegate.sketch != sketch ||
        oldDelegate.simulatePressure != simulatePressure ||
        oldDelegate.scaleFactor != scaleFactor ||
        oldDelegate.theme != theme;
  }
}
