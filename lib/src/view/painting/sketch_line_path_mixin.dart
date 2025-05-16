import 'dart:ui';

import 'package:perfect_freehand/perfect_freehand.dart' as pf;
import 'package:scribble/src/domain/model/sketch/sketch.dart';

/// A mixin for generating a [Path] from a [SketchLine].
///
/// Provides the method [getPathForLine] which generates a smooth [Path] from a
/// [SketchLine].
mixin SketchLinePathMixin {
  /// {@macro scribble.simulate_pressure}
  bool get simulatePressure;

  /// Generates a [Path] from a [SketchLine].
  ///
  /// The [scaleFactor] is used to scale the line width.
  ///
  /// If [simulatePressure] is true, the line will be drawn as if it had
  /// pressure information, if all its points have the same pressure.
  Path? getPathForLine(
    SketchLine line, {
    double scaleFactor = 1.0,
  }) {
    final needSimulate = simulatePressure &&
        line.points.length > 1 &&
        line.points.every((p) => p.pressure == line.points.first.pressure);
    final points = line.points
        .map((point) => pf.PointVector(point.x, point.y, point.pressure))
        .toList();
    // Enhanced options for higher quality stroke paths
    final outlinePoints = pf.getStroke(
      points,
      options: pf.StrokeOptions(
        size: line.width * 2 * scaleFactor,
        simulatePressure: needSimulate,
        thinning: 0.6, // Improved line thinning effect for pressure
        smoothing: 0.5, // Increased smoothing for more natural curves
        streamline: 0.5, // Higher streamline for smoother lines
      ),
    );
    if (outlinePoints.isEmpty) {
      return null;
    } else if (outlinePoints.length < 2) {
      return Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(outlinePoints[0].dx, outlinePoints[0].dy),
            radius: 1,
          ),
        );
    } else {
      // Use cubic Bezier curves for even smoother strokes
      final path = Path()..moveTo(outlinePoints[0].dx, outlinePoints[0].dy);

      if (outlinePoints.length < 4) {
        // If we don't have enough points for a cubic curve, use quadratic
        for (var i = 1; i < outlinePoints.length - 1; i++) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            (p0.dx + p1.dx) / 2,
            (p0.dy + p1.dy) / 2,
          );
        }
      } else {
        // Use cubic bezier curves for smoother strokes
        // First calculate control points
        for (var i = 1; i < outlinePoints.length - 2; i++) {
          final p0 = outlinePoints[i - 1];
          final p1 = outlinePoints[i];
          final p2 = outlinePoints[i + 1];
          final p3 = outlinePoints[i + 2];

          // Calculate cubic control points
          final controlPoint1 = Offset(
            p1.dx + (p2.dx - p0.dx) / 4,
            p1.dy + (p2.dy - p0.dy) / 4,
          );
          final controlPoint2 = Offset(
            p2.dx - (p3.dx - p1.dx) / 4,
            p2.dy - (p3.dy - p1.dy) / 4,
          );

          // Add cubic curve segment
          path.cubicTo(
            controlPoint1.dx,
            controlPoint1.dy,
            controlPoint2.dx,
            controlPoint2.dy,
            p2.dx,
            p2.dy,
          );
        }
      }
      return path;
    }
  }
}
