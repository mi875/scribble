import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scribble/src/view/notifier/scribble_notifier.dart';
import 'package:scribble/src/view/painting/dot_grid_painter.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';
import 'package:scribble/src/view/pan_gesture_catcher.dart';
import 'package:scribble/src/view/state/scribble.state.dart';
import 'package:scribble/src/view/widgets/background_image_widget.dart';

/// {@template scribble}
/// This Widget represents a canvas on which users can draw with any pointer.
///
/// You can control its behavior from code using the [notifier] instance you
/// pass in.
/// {@endtemplate}
class Scribble extends StatelessWidget {
  /// {@macro scribble}
  const Scribble({
    /// The notifier that controls this canvas.
    required this.notifier,

    /// Whether to draw the pointer when in drawing mode
    this.drawPen = true,

    /// Whether to draw the pointer when in erasing mode
    this.drawEraser = true,

    /// Fixed stroke width for all drawing. When specified, all strokes will
    /// use this width regardless of pressure or other factors.
    this.fixedStrokeWidth,

    /// The size of the canvas. If null, the canvas will expand to fill
    /// all available space.
    this.canvasSize,

    /// Whether to show the dot grid background. Defaults to true.
    this.showDotGrid = true,

    /// The spacing between dots in the grid (in logical pixels at 100% zoom).
    this.dotSpacing = 20.0,

    /// The color of the dots in the grid.
    this.dotColor = const Color(0x1A000000), // 10% opacity black

    /// The radius of each dot in the grid.
    this.dotRadius = 1.0,

    /// How the background image should fit within the canvas.
    this.backgroundImageFit = BoxFit.contain,
    super.key,
  });

  /// The notifier that controls this canvas.
  final ScribbleNotifierBase notifier;

  /// Whether to draw the pointer when in drawing mode
  final bool drawPen;

  /// Whether to draw the pointer when in erasing mode
  final bool drawEraser;

  /// Fixed stroke width for all drawing. When specified, all strokes will
  /// use this width regardless of pressure or other factors.
  final double? fixedStrokeWidth;

  /// The size of the canvas. If null, the canvas will expand to fill
  /// all available space.
  final Size? canvasSize;

  /// Whether to show the dot grid background.
  final bool showDotGrid;

  /// The spacing between dots in the grid (in logical pixels at 100% zoom).
  final double dotSpacing;

  /// The color of the dots in the grid.
  final Color dotColor;

  /// The radius of each dot in the grid.
  final double dotRadius;

  /// How the background image should fit within the canvas.
  final BoxFit backgroundImageFit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScribbleState>(
      valueListenable: notifier,
      builder: (context, state, _) {
        final drawCurrentTool =
            drawPen && state is Drawing || drawEraser && state is Erasing;

        Widget buildScribbleCanvas() {
          final canvas = CustomPaint(
            painter: showDotGrid
                ? DotGridPainter(
                    scaleFactor: state.scaleFactor,
                    panOffset: state.panOffset,
                    canvasSize: (notifier is ScribbleNotifier)
                        ? (notifier as ScribbleNotifier).canvasSize
                        : null,
                    dotSpacing: dotSpacing,
                    dotColor: dotColor,
                    dotRadius: dotRadius,
                  )
                : null,
            foregroundPainter: ScribbleEditingPainter(
              state: state,
              drawPointer: drawPen,
              drawEraser: drawEraser,
              fixedStrokeWidth: fixedStrokeWidth,
              canvasSize: (notifier is ScribbleNotifier)
                  ? (notifier as ScribbleNotifier).canvasSize
                  : null,
            ),
            child: RepaintBoundary(
              key: notifier.repaintBoundaryKey,
              child: CustomPaint(
                painter: ScribblePainter(
                  sketch: state.sketch,
                  scaleFactor: state.scaleFactor,
                  panOffset: state.panOffset,
                  fixedStrokeWidth: fixedStrokeWidth,
                  canvasSize: (notifier is ScribbleNotifier)
                      ? (notifier as ScribbleNotifier).canvasSize
                      : null,
                ),
              ),
            ),
          );

          // Wrap with background image if present
          if (state.backgroundImage != null) {
            return BackgroundImageWidget(
              imageProvider: state.backgroundImage!,
              scaleFactor: state.scaleFactor,
              panOffset: state.panOffset,
              canvasSize: (notifier is ScribbleNotifier)
                  ? (notifier as ScribbleNotifier).canvasSize
                  : null,
              backgroundImageSize: state.backgroundImageSize,
              fit: backgroundImageFit,
              child: canvas,
            );
          }

          return canvas;
        }

        final child = canvasSize != null
            ? SizedBox(
                width: canvasSize!.width,
                height: canvasSize!.height,
                child: buildScribbleCanvas(),
              )
            : SizedBox.expand(
                child: buildScribbleCanvas(),
              );
        return !state.active
            ? child
            : GestureCatcher(
                pointerKindsToCatch: state.supportedPointerKinds,
                child: MouseRegion(
                  cursor: drawCurrentTool &&
                          state.supportedPointerKinds
                              .contains(PointerDeviceKind.mouse)
                      ? SystemMouseCursors.none
                      : MouseCursor.defer,
                  onExit: notifier.onPointerExit,
                  child: Listener(
                    onPointerDown: notifier.onPointerDown,
                    onPointerMove: notifier.onPointerUpdate,
                    onPointerUp: notifier.onPointerUp,
                    onPointerHover: notifier.onPointerHover,
                    onPointerCancel: notifier.onPointerCancel,
                    child: child,
                  ),
                ),
              );
      },
    );
  }
}
