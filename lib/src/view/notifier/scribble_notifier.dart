import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';
import 'package:scribble/src/view/painting/point_to_offset_x.dart';
import 'package:scribble/src/view/painting/sketch_line_cache_mixin.dart';
import 'package:scribble/src/view/painting/sketch_line_path_mixin.dart';
import 'package:scribble/src/view/simplification/sketch_simplifier.dart';
import 'package:scribble/src/view/state/scribble.state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

/// {@template scribble_notifier_base}
/// The base class for a notifier that controls the state of a [Scribble]
/// widget.
///
/// This class is meant to be extended by a concrete implementation that
/// provides the actual behavior.
///
/// See [ScribbleNotifier] for the default implementation.
/// {@endtemplate}
abstract class ScribbleNotifierBase extends ValueNotifier<ScribbleState> {
  /// {@macro scribble_notifier_base}
  ScribbleNotifierBase(super.state);

  /// You need to provide a key that the [RepaintBoundary] can use so you can
  /// access it from the [renderImage] method.
  GlobalKey get repaintBoundaryKey;

  /// Should be called when the pointer hovers over the canvas with the
  /// corresponding [event].
  void onPointerHover(PointerHoverEvent event);

  /// Should be called when the pointer is pressed down on the canvas with the
  /// corresponding [event].
  void onPointerDown(PointerDownEvent event);

  /// Should be called when the pointer is moved on the canvas with the
  /// corresponding [event].
  void onPointerUpdate(PointerMoveEvent event);

  /// Should be called when the pointer is lifted from the canvas with the
  /// corresponding [event].
  void onPointerUp(PointerUpEvent event);

  /// Should be called when the pointer is canceled with the corresponding
  /// [event].
  void onPointerCancel(PointerCancelEvent event);

  /// Should be called when the pointer exits the canvas with the corresponding
  /// [event].
  void onPointerExit(PointerExitEvent event);

  /// Used to render the image to ByteData which can then be stored or reused
  /// for example in an [Image.memory] widget.
  ///
  /// Use [pixelRatio] to increase the resolution of the resulting image.
  /// You can specify a different [format], by default this method
  /// generates pngs.
  Future<ByteData> renderImage({
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final renderObject = repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (renderObject == null) {
      throw StateError(
        "Tried to convert Scribble to Image, but no valid RenderObject was "
        "found!",
      );
    }
    final img = await renderObject.toImage(pixelRatio: pixelRatio);
    return (await img.toByteData(format: format))!;
  }
}

/// {@template scribble_notifier}
/// The default implementation of a [ScribbleNotifierBase].
///
/// This class controls the state and behavior for a [Scribble] widget.
/// {@endtemplate}
class ScribbleNotifier extends ScribbleNotifierBase
    with HistoryValueNotifierMixin<ScribbleState> {
  /// {@macro scribble_notifier}
  ScribbleNotifier({
    /// If you pass a sketch here, the notifier will use that sketch as a
    /// starting point.
    Sketch? sketch,

    /// Which pointers can be drawn with and are captured.
    ScribblePointerMode allowedPointersMode = ScribblePointerMode.all,

    /// How many states you want stored in the undo history, 30 by default.
    int maxHistoryLength = 30,
    this.simplifier = const VisvalingamSimplifier(),

    /// {@macro view.state.scribble_state.simplification_tolerance}
    double simplificationTolerance = 0,

    /// Fixed stroke width for all drawing. When specified, all strokes will
    /// use this width regardless of pressure or other factors.
    this.fixedStrokeWidth,

    /// The size of the drawing canvas (paper). If specified, drawing and
    /// erasing will be constrained to this area.
    this.canvasSize,

    /// Background image for the canvas.
    ImageProvider? backgroundImage,

    /// Size of the background image.
    Size? backgroundImageSize,

    /// Position/offset of the background image.
    Offset backgroundImageOffset = Offset.zero,
  }) : super(
          ScribbleState.drawing(
            sketch: switch (sketch) {
              Sketch() => simplifier.simplifySketch(
                  sketch,
                  pixelTolerance: simplificationTolerance,
                ),
              null => const Sketch(lines: []),
            },
            selectedWidth: fixedStrokeWidth ?? 5.0,
            allowedPointersMode: allowedPointersMode,
            simplificationTolerance: simplificationTolerance,
            backgroundImage: backgroundImage,
            backgroundImageSize: backgroundImageSize,
            backgroundImageOffset: backgroundImageOffset,
          ),
        ) {
    this.maxHistoryLength = maxHistoryLength;
  }

  /// The state of the sketch at this moment.
  ///
  /// If you want to store it somewhere you can call ``.toJson()`` on it to
  /// receive a map.
  Sketch get currentSketch => value.sketch;

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  /// Track whether the notifier is still mounted
  bool _isMounted = true;

  /// Whether the notifier is still mounted
  bool get mounted => _isMounted;

  @override
  GlobalKey get repaintBoundaryKey => _repaintBoundaryKey;

  /// The [SketchSimplifier] that is used to simplify the lines of the sketch.
  ///
  /// Defaults to [VisvalingamSimplifier], but you can implement your own.
  final SketchSimplifier simplifier;

  /// Fixed stroke width for all drawing. When specified, all strokes will
  /// use this width regardless of pressure or other factors.
  final double? fixedStrokeWidth;

  /// The size of the drawing canvas (paper). If specified, drawing and
  /// erasing will be constrained to this area.
  final Size? canvasSize;

  /// Only apply the sketch from the undo history, otherwise keep current state
  @override
  @protected
  ScribbleState transformHistoryValue(
    ScribbleState historyValue,
    ScribbleState currentState,
  ) {
    return currentState.copyWith(
      sketch: historyValue.sketch,
    );
  }

  /// Can be used to update the state of the Sketch externally (e.g. when
  /// fetching from a server) to what is passed in as [sketch];
  ///
  /// By default, this state of the sketch gets added to the undo history. If
  /// this is not desired, set [addToUndoHistory] to `false`.
  ///
  /// The sketch will be simplified using the currently set simplification
  /// tolerance. If you don't want simplification, call
  /// [setSimplificationTolerance] to set it to 0.
  void setSketch({
    required Sketch sketch,
    bool addToUndoHistory = true,
  }) {
    // Dispose existing cached images
    _disposeCachedImages();

    final newState = value.copyWith(
      sketch: sketch,
    );

    if (addToUndoHistory) {
      value = newState;
    } else {
      temporaryValue = newState;
    }

    // Cache the new lines
    _cacheAllStrokes();
  }

  /// Clear the entire drawing.
  void clear() {
    // Dispose any cached images
    _disposeCachedImages();

    value = switch (value) {
      final Drawing d => d.copyWith(
          sketch: const Sketch(lines: []),
          activeLine: null,
        ),
      final Erasing e => e.copyWith(
          sketch: const Sketch(lines: []),
        ),
    };
  }

  @override
  void dispose() {
    _isMounted = false;
    _disposeCachedImages();
    super.dispose();
  }

  /// Dispose any cached images to prevent memory leaks
  void _disposeCachedImages() {
    for (final line in value.sketch.lines) {
      if (line.cachedImage != null) {
        line.cachedImage!.dispose();
      }
    }
  }

  /// Sets the width of the next line
  void setStrokeWidth(double strokeWidth) {
    temporaryValue = value.copyWith(
      selectedWidth: strokeWidth,
    );
  }

  /// Switches to eraser mode
  void setEraser() {
    // Finish any active line before switching to eraser mode
    final currentState =
        value is Drawing && (value as Drawing).activeLine != null
            ? _finishLineForState(value)
            : value;

    temporaryValue = ScribbleState.erasing(
      sketch: currentState.sketch,
      selectedWidth: currentState.selectedWidth,
      scaleFactor: currentState.scaleFactor,
      panOffset: currentState.panOffset,
      allowedPointersMode: currentState.allowedPointersMode,
      activePointerIds: currentState.activePointerIds,
      pointerPosition: currentState.pointerPosition,
      simplificationTolerance: currentState.simplificationTolerance,
      backgroundImage: currentState.backgroundImage,
      backgroundImageSize: currentState.backgroundImageSize,
      backgroundImageOffset: currentState.backgroundImageOffset,
    );
  }

  /// Switches to drawing mode
  void setDrawing() {
    temporaryValue = ScribbleState.drawing(
      sketch: value.sketch,
      selectedColor:
          value is Drawing ? (value as Drawing).selectedColor : 0xFF000000,
      selectedWidth: value.selectedWidth,
      scaleFactor: value.scaleFactor,
      panOffset: value.panOffset,
      allowedPointersMode: value.allowedPointersMode,
      activePointerIds: value.activePointerIds,
      pointerPosition: value.pointerPosition,
      simplificationTolerance: value.simplificationTolerance,
      backgroundImage: value.backgroundImage,
      backgroundImageSize: value.backgroundImageSize,
      backgroundImageOffset: value.backgroundImageOffset,
    );
  }

  /// Sets the current mode of allowed pointers to the given
  /// [ScribblePointerMode]
  void setAllowedPointersMode(ScribblePointerMode allowedPointersMode) {
    temporaryValue = value.copyWith(
      allowedPointersMode: allowedPointersMode,
    );
  }

  /// Sets the zoom factor to allow for adjusting line width.
  ///
  /// If the factor is 2 for example, lines will be drawn half as thick as
  /// actually selected to allow for drawing details. Has to be greater than 0.
  void setScaleFactor(double factor) {
    assert(factor > 0, "The scale factor must be greater than 0.");
    temporaryValue = value.copyWith(
      scaleFactor: factor,
    );
  }

  /// Sets the pan offset for the canvas.
  ///
  /// This allows for panning the canvas view.
  void setPanOffset(Offset offset) {
    temporaryValue = value.copyWith(
      panOffset: offset,
    );
  }

  /// Sets both zoom factor and pan offset simultaneously.
  ///
  /// This is more efficient than calling setScaleFactor and setPanOffset
  /// separately.
  void setZoomAndPan({required double scaleFactor, required Offset panOffset}) {
    assert(scaleFactor > 0, "The scale factor must be greater than 0.");
    temporaryValue = value.copyWith(
      scaleFactor: scaleFactor,
      panOffset: panOffset,
    );
  }

  /// Sets the color of the pen to the given color.
  void setColor(Color color) {
    temporaryValue = switch (value) {
      Drawing() => ScribbleState.drawing(
          sketch: value.sketch,
          selectedColor: color.value, // ignore: deprecated_member_use
          selectedWidth: value.selectedWidth,
          allowedPointersMode: value.allowedPointersMode,
          scaleFactor: value.scaleFactor,
          panOffset: value.panOffset,
          activePointerIds: value.activePointerIds,
          simplificationTolerance: value.simplificationTolerance,
          backgroundImage: value.backgroundImage,
          backgroundImageSize: value.backgroundImageSize,
          backgroundImageOffset: value.backgroundImageOffset,
        ),
      Erasing() => ScribbleState.drawing(
          sketch: value.sketch,
          selectedColor: color.value, // ignore: deprecated_member_use
          selectedWidth: value.selectedWidth,
          allowedPointersMode: value.allowedPointersMode,
          scaleFactor: value.scaleFactor,
          panOffset: value.panOffset,
          activePointerIds: value.activePointerIds,
          simplificationTolerance: value.simplificationTolerance,
          backgroundImage: value.backgroundImage,
          backgroundImageSize: value.backgroundImageSize,
          backgroundImageOffset: value.backgroundImageOffset,
        ),
    };
  }

  /// Sets the background image for the canvas.
  void setBackgroundImage(ImageProvider? backgroundImage) {
    temporaryValue = value.copyWith(
      backgroundImage: backgroundImage,
    );
  }

  /// Sets the background image and its size for the canvas.
  void setBackgroundImageWithSize(ImageProvider? backgroundImage, Size? size) {
    temporaryValue = value.copyWith(
      backgroundImage: backgroundImage,
      backgroundImageSize: size,
    );
  }

  /// Sets the size of the background image.
  void setBackgroundImageSize(Size? size) {
    temporaryValue = value.copyWith(
      backgroundImageSize: size,
    );
  }

  /// Sets the position/offset of the background image.
  void setBackgroundImageOffset(Offset offset) {
    temporaryValue = value.copyWith(
      backgroundImageOffset: offset,
    );
  }

  /// Sets the background image with size and offset for the canvas.
  void setBackgroundImageWithSizeAndOffset(
    ImageProvider? backgroundImage,
    Size? size,
    Offset offset,
  ) {
    temporaryValue = value.copyWith(
      backgroundImage: backgroundImage,
      backgroundImageSize: size,
      backgroundImageOffset: offset,
    );
  }

  /// Clears the background image.
  void clearBackgroundImage() {
    setBackgroundImage(null);
  }

  /// Sets the simplification degree for the sketch in logical pixels.
  ///
  /// 0 means no simplification, 1px is a good starting point for most sketches.
  /// The higher the degree, the more the details will be eroded.
  ///
  /// **Info:** Simplification quickly breaks simulated pressure, since it
  /// removes points that are close together first, so pressure simulation
  /// assumes a more even speed of the pen.
  ///
  /// Changing this value by itself will only affect future lines. If you want
  /// to simplify existing lines, see [simplify].
  void setSimplificationTolerance(double degree) {
    temporaryValue = value.copyWith(
      simplificationTolerance: degree,
    );
  }

  /// Simplifies the current sketch to the current simplification degree using
  /// [simplifier].
  ///
  /// This will simplify all lines. If [addToUndoHistory] is true, this step
  /// will be added to the undo history
  void simplify({bool addToUndoHistory = true}) {
    // Dispose existing cached images
    _disposeCachedImages();

    final newSketch = simplifier.simplifySketch(
      value.sketch,
      pixelTolerance: value.simplificationTolerance,
    );

    if (addToUndoHistory) {
      value = value.copyWith(sketch: newSketch);
    } else {
      temporaryValue = value.copyWith(sketch: newSketch);
    }

    // Cache the new lines
    _cacheAllStrokes();
  }

  /// Cache all strokes in the current sketch
  void _cacheAllStrokes() {
    // Skip caching in tests or if the binding is not available
    if (!_canUseWidgetsBinding) return;

    final cacheGenerator = _StrokePathAndCacheGenerator();

    // Use a delayed frame to avoid blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isMounted) return;

      final scaleFactor = value.scaleFactor;

      // Get lines that need caching (no cached image and at least 2 points)
      final linesToCache = value.sketch.lines
          .where((line) => line.cachedImage == null && line.points.length > 1)
          .toList();

      // Sort by complexity (more points = more complex)
      linesToCache.sort((a, b) => b.points.length.compareTo(a.points.length));

      // Limit number of lines to cache in one batch to avoid freezing
      const maxLinesPerBatch = 5;
      final batch = linesToCache.take(maxLinesPerBatch).toList();

      // Keep track of updated lines
      final allLines = List<SketchLine>.from(value.sketch.lines);
      var updatedAny = false;

      // Process lines with small delays between each
      for (final line in batch) {
        // Skip if we're no longer mounted
        if (!_isMounted) return;

        // Cache the line
        final cachedImage = await cacheGenerator.createCacheForLine(
          line,
          scaleFactor: scaleFactor,
          simulatePressure: false,
          devicePixelRatio: 1,
        );

        if (cachedImage != null) {
          // Find the line index in our list
          final index = allLines.indexWhere(
            (l) =>
                l.points == line.points &&
                l.color == line.color &&
                l.width == line.width,
          );

          if (index >= 0) {
            // Replace with cached version
            allLines[index] = line.copyWith(
              cachedImage: cachedImage,
            );
            updatedAny = true;
          }
          // Small delay to let UI breathe
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
      }

      // Update state only if we cached something
      if (_isMounted && updatedAny) {
        temporaryValue = value.copyWith(
          sketch: value.sketch.copyWith(lines: allLines),
        );

        // Schedule the next batch if there are more lines
        if (linesToCache.length > maxLinesPerBatch) {
          // Wait a bit before starting next batch
          Future<void>.delayed(
            const Duration(milliseconds: 100),
            _cacheAllStrokes,
          );
        }
      }
    });
  }

  /// Check if we can use WidgetsBinding for caching
  bool get _canUseWidgetsBinding {
    try {
      // This will throw if binding is not initialized
      WidgetsBinding.instance;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Used by the Listener callback to display the pen if desired
  @override
  void onPointerHover(PointerHoverEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    temporaryValue = value.copyWith(
      pointerPosition:
          event.distance > 10000 ? null : _getPointFromEvent(event),
    );
  }

  /// Used by the Listener callback to start drawing
  @override
  void onPointerDown(PointerDownEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    var s = value;

    // Are there already pointers on the screen?
    if (value.activePointerIds.isNotEmpty) {
      s = switch (value) {
        Drawing(activeLine: final activeLine) =>
          // If the current line already contains something
          (activeLine != null && activeLine.points.length > 2)
              ? _finishLineForState(value)
              : (value as Drawing).copyWith(
                  activeLine: null,
                ),
        Erasing() => value,
      };
    } else if (value is Drawing) {
      final point = _getPointFromEvent(event);
      if (point != null) {
        s = (value as Drawing).copyWith(
          pointerPosition: point,
          activeLine: SketchLine(
            points: [point],
            color: (value as Drawing).selectedColor,
            width: fixedStrokeWidth ?? value.selectedWidth,
          ),
        );
      }
    }
    temporaryValue = s.copyWith(
      activePointerIds: [...value.activePointerIds, event.pointer],
    );
  }

  /// Used by the Listener callback to update the drawing
  @override
  void onPointerUpdate(PointerMoveEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    if (!value.active) {
      temporaryValue = value.copyWith(
        pointerPosition: null,
      );
      return;
    }
    if (value is Drawing) {
      temporaryValue = _addPoint(event, value).copyWith(
        pointerPosition: _getPointFromEvent(event),
      );
    } else if (value is Erasing) {
      temporaryValue = _erasePoint(event).copyWith(
        pointerPosition: _getPointFromEvent(event),
      );
    }
  }

  /// Used by the Listener callback to finish a line
  @override
  void onPointerUp(PointerUpEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    final pos =
        event.kind == PointerDeviceKind.mouse ? value.pointerPosition : null;
    if (value is Drawing) {
      value = _finishLineForState(_addPoint(event, value)).copyWith(
        pointerPosition: pos,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    } else if (value is Erasing) {
      value = _erasePoint(event).copyWith(
        pointerPosition: pos,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    }
  }

  /// Used by the Listener callback to stop displaying the cursor
  @override
  void onPointerCancel(PointerCancelEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    if (value is Drawing) {
      value = _finishLineForState(_addPoint(event, value)).copyWith(
        pointerPosition: null,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    } else if (value is Erasing) {
      value = _erasePoint(event).copyWith(
        pointerPosition: null,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    }
  }

  @override
  void onPointerExit(PointerExitEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    temporaryValue = _finishLineForState(value).copyWith(
      pointerPosition: null,
      activePointerIds:
          value.activePointerIds.where((id) => id != event.pointer).toList(),
    );
  }

  ScribbleState _addPoint(PointerEvent event, ScribbleState s) {
    if (s is Erasing || !s.active) return s;
    if (s is Drawing && s.activeLine == null) return s;
    final currentLine = (s as Drawing).activeLine!;
    final distanceToLast = currentLine.points.isEmpty
        ? double.infinity
        : (currentLine.points.last.asOffset - event.localPosition).distance;

    // Adaptive filtering: use smaller threshold for better detail preservation
    // Scale based on line width and device pixel ratio for consistent quality
    final adaptiveThreshold = (kPrecisePointerPanSlop * 0.5) /
        (s.scaleFactor * (currentLine.width / 10.0).clamp(0.5, 2.0));

    if (distanceToLast <= adaptiveThreshold) return s;

    final newPoint = _getPointFromEvent(event);
    if (newPoint == null) return s; // Don't add points outside canvas bounds

    return s.copyWith(
      activeLine: currentLine.copyWith(
        points: [
          ...currentLine.points,
          newPoint,
        ],
      ),
    );
  }

  ScribbleState _erasePoint(PointerEvent event) {
    // Transform the pointer position to canvas coordinates
    final transformedPosition = _transformPointerPosition(event.localPosition);

    // Define eraser radius (could be made configurable)
    final eraserRadius = value.selectedWidth * 2.0;

    return value.copyWith.sketch(
      lines: value.sketch.lines
          .where(
            (l) => l.points.every(
              (p) =>
                  (transformedPosition - p.asOffset).distance >
                  l.width / 2 + eraserRadius,
            ),
          )
          .toList(),
    );
  }

  /// Converts a pointer event to the [Point] on the canvas.
  ///
  /// This method accounts for zoom and pan transformations to ensure
  /// drawing coordinates are correct regardless of the current view state.
  /// Returns null if the point is outside the canvas bounds.
  Point? _getPointFromEvent(PointerEvent event) {
    // Transform the pointer position to account for zoom and pan
    final transformedPosition = _transformPointerPosition(event.localPosition);

    // Check if the point is within canvas bounds
    if (!_isPointInCanvas(transformedPosition)) {
      return null;
    }

    return Point(
      transformedPosition.dx,
      transformedPosition.dy,
      pressure: 0.5, // Fixed pressure since we're using fixed width
    );
  }

  /// Transforms a pointer position from screen coordinates to canvas coordinates
  /// accounting for zoom and pan transformations.
  Offset _transformPointerPosition(Offset screenPosition) {
    final state = value;

    // The painters apply transformations in this order:
    // 1. Clip to canvas bounds (if canvasSize is specified)
    // 2. Translate by panOffset
    // 3. Scale by scaleFactor

    // To reverse: we need to undo scale first, then undo translate

    // 1. First, reverse the scaling (zoom)
    final afterScale = Offset(
      screenPosition.dx / state.scaleFactor,
      screenPosition.dy / state.scaleFactor,
    );

    // 2. Then, reverse the translation (pan)
    // Note: panOffset is applied in canvas coordinates, so we need to reverse it
    // in the same coordinate space
    final canvasPosition = afterScale - (state.panOffset / state.scaleFactor);

    return canvasPosition;
  }

  /// Checks if a point is within the canvas bounds
  bool _isPointInCanvas(Offset point) {
    if (canvasSize == null) return true;

    return point.dx >= 0 &&
        point.dx <= canvasSize!.width &&
        point.dy >= 0 &&
        point.dy <= canvasSize!.height;
  }

  ScribbleState _finishLineForState(ScribbleState s) {
    if (s case Drawing(activeLine: final activeLine?)) {
      final simplifiedLine = simplifier.simplify(
        activeLine,
        pixelTolerance: s.simplificationTolerance,
      );

      // Create cached image for the line in the next frame to avoid UI jank
      if (_canUseWidgetsBinding && simplifiedLine.points.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _cacheStrokeLine(simplifiedLine, s.scaleFactor);
        });
      }

      return s.copyWith(
        activeLine: null,
        sketch: s.sketch.copyWith(
          lines: [
            ...s.sketch.lines,
            simplifiedLine,
          ],
        ),
      );
    }
    return s;
  }

  /// Cache a stroke line as an image to improve performance
  Future<void> _cacheStrokeLine(SketchLine line, double scaleFactor) async {
    if (line.points.length < 2) return;

    // Don't cache if already cached
    if (line.cachedImage != null) return;

    // Create a path generator with cache support
    final cacheGenerator = _StrokePathAndCacheGenerator();

    // Generate the cached image using device-specific resolution
    final cachedImage = await cacheGenerator.createCacheForLine(
      line,
      scaleFactor: scaleFactor,
      simulatePressure: false,
    );

    if (cachedImage != null) {
      // Create a new line with the cached image
      final cachedLine = line.copyWith(cachedImage: cachedImage);

      // Update the sketch with the cached line
      final updatedLines = value.sketch.lines.map((l) {
        // Find the line to update by comparing points
        if (l.points == line.points &&
            l.color == line.color &&
            l.width == line.width) {
          return cachedLine;
        }
        return l;
      }).toList();

      // Update the sketch without adding to history
      temporaryValue = value.copyWith(
        sketch: value.sketch.copyWith(lines: updatedLines),
      );
    }
  }
}

/// Helper class for path generation and caching
class _StrokePathAndCacheGenerator
    with SketchLinePathMixin, SketchLineCacheMixin {
  _StrokePathAndCacheGenerator();
  @override
  final bool simulatePressure = false; // Always false since we use fixed width
}
