import 'package:flutter/widgets.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';

/// {@template scribble_sketch}
/// A widget for displaying a scribble sketch without any input functionalities.
///
/// The sketch is expected to not have any active line, i.e. all lines are
/// considered finished, the sketch is complete.
/// {@endtemplate}
class ScribbleSketch extends StatelessWidget {
  /// {@macro scribble_sketch}
  const ScribbleSketch({
    required this.sketch,
    this.scaleFactor = 1,
    this.panOffset = Offset.zero,
    this.fixedStrokeWidth,
    this.canvasSize,
    super.key,
  });

  /// The sketch to display
  final Sketch sketch;

  /// How much the widget is scaled at the moment.
  ///
  /// Can be used if zoom functionality is needed
  /// (e.g. through InteractiveViewer) so that the pen width remains the same.
  final double scaleFactor;

  /// The pan offset for the canvas.
  final Offset panOffset;

  /// Fixed stroke width for all lines. When specified, all strokes will
  /// use this width regardless of their original width.
  final double? fixedStrokeWidth;

  /// The size of the canvas for clipping. If null, no clipping is applied.
  final Size? canvasSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScribblePainter(
        sketch: sketch,
        scaleFactor: scaleFactor,
        panOffset: panOffset,
        fixedStrokeWidth: fixedStrokeWidth,
        canvasSize: canvasSize,
      ),
    );
  }
}
