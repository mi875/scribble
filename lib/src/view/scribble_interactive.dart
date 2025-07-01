import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scribble/src/view/notifier/scribble_notifier.dart';
import 'package:scribble/src/view/scribble.dart';

/// {@template scribble_interactive}
/// A wrapper widget that adds zoom and pan functionality to the Scribble widget.
///
/// This widget provides interactive zoom and pan gestures while maintaining
/// the original drawing functionality.
/// {@endtemplate}
class ScribbleInteractive extends StatefulWidget {
  /// {@macro scribble_interactive}
  const ScribbleInteractive({
    /// The notifier that controls the canvas.
    required this.notifier,

    /// Whether to draw the pointer when in drawing mode
    this.drawPen = true,

    /// Whether to draw the pointer when in erasing mode
    this.drawEraser = true,

    /// Fixed stroke width for all drawing. When specified, all strokes will
    /// use this width regardless of pressure or other factors.
    this.fixedStrokeWidth,

    /// The size of the canvas. If null, the canvas will expand to fill
    /// available space.
    this.canvasSize,

    /// The display size of the widget. If null, uses canvasSize or expands to fill space.
    /// This allows the logical canvas size to be different from the display size.
    /// When null, the widget will expand to fill all available space regardless of canvasSize.
    this.displaySize,

    /// Minimum zoom scale factor. Defaults to 1.0 (100%).
    this.minScale = 1.0,

    /// Maximum zoom scale factor. Defaults to 5.0.
    this.maxScale = 5.0,

    /// Whether zoom and pan gestures are enabled. Defaults to true.
    this.enableInteraction = true,

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

  /// The notifier that controls the canvas.
  final ScribbleNotifierBase notifier;

  /// Whether to draw the pointer when in drawing mode
  final bool drawPen;

  /// Whether to draw the pointer when in erasing mode
  final bool drawEraser;

  /// Fixed stroke width for all drawing. When specified, all strokes will
  /// use this width regardless of pressure or other factors.
  final double? fixedStrokeWidth;

  /// The size of the canvas. If null, the canvas will expand to fill
  /// available space.
  final Size? canvasSize;

  /// The display size of the widget. If null, uses canvasSize or expands to fill space.
  /// This allows the logical canvas size to be different from the display size.
  /// When null, the widget will expand to fill all available space regardless of canvasSize.
  final Size? displaySize;

  /// Minimum zoom scale factor.
  final double minScale;

  /// Maximum zoom scale factor.
  /// Maximum zoom scale factor.
  final double maxScale;

  /// Whether zoom and pan gestures are enabled.
  final bool enableInteraction;

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
  State<ScribbleInteractive> createState() => _ScribbleInteractiveState();

  /// Static method to reset the view of a ScribbleInteractive widget
  static void resetView(BuildContext context) {
    final state = context.findAncestorStateOfType<_ScribbleInteractiveState>();
    state?.resetView();
  }
}

class _ScribbleInteractiveState extends State<ScribbleInteractive> {
  double _baseScale = 1.0;
  Offset _baseOffset = Offset.zero;
  double _initialScale = 1.0;
  Offset _initialOffset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Initialize base values from notifier's current state
    _baseScale = widget.notifier.value.scaleFactor;
    _baseOffset = widget.notifier.value.panOffset;

    // After the first frame, ensure the initial scale and offset are appropriate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamicMinScale = _calculateMinScale();
      if (_baseScale < dynamicMinScale) {
        // If current scale is too small, reset to appropriate scale
        resetView();
      } else {
        // Just clamp the offset to ensure we're within bounds
        final clampedOffset = _clampOffset(_baseOffset, _baseScale);
        if (clampedOffset != _baseOffset) {
          _baseOffset = clampedOffset;
          if (widget.notifier is ScribbleNotifier) {
            (widget.notifier as ScribbleNotifier).setZoomAndPan(
              scaleFactor: _baseScale,
              panOffset: _baseOffset,
            );
          }
        }
      }
    });
  }

  @override
  void didUpdateWidget(ScribbleInteractive oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Get current and old canvas sizes (could be from widget or notifier)
    final currentCanvasSize = widget.canvasSize ??
        (widget.notifier is ScribbleNotifier
            ? (widget.notifier as ScribbleNotifier).canvasSize
            : null);
    final oldCanvasSize = oldWidget.canvasSize ??
        (oldWidget.notifier is ScribbleNotifier
            ? (oldWidget.notifier as ScribbleNotifier).canvasSize
            : null);

    // If canvas size changed, we need to reclamp the current offset
    if (currentCanvasSize != oldCanvasSize) {
      _baseOffset = _clampOffset(_baseOffset, _baseScale);
      if (widget.notifier is ScribbleNotifier) {
        (widget.notifier as ScribbleNotifier).setZoomAndPan(
          scaleFactor: _baseScale,
          panOffset: _baseOffset,
        );
      }
    }
  }

  /// Calculates the minimum zoom scale to ensure the canvas fits appropriately in the viewport
  double _calculateMinScale() {
    // Get canvas size from widget parameter or notifier
    final canvasSize = widget.canvasSize ??
        (widget.notifier is ScribbleNotifier
            ? (widget.notifier as ScribbleNotifier).canvasSize
            : null);

    if (canvasSize == null) {
      // No canvas size limit, use the widget's minScale but ensure it's at least 1.0
      return math.max(widget.minScale, 1.0);
    }

    // We need the viewport size to calculate bounds
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return math.max(widget.minScale, 1.0);
    }

    final viewportSize = renderBox.size;

    // If the widget size matches the canvas size (like in the example app),
    // then the canvas fills the entire widget and we should not zoom out below 100%
    final widgetMatchesCanvas =
        (viewportSize.width - canvasSize.width).abs() < 1.0 &&
            (viewportSize.height - canvasSize.height).abs() < 1.0;

    if (widgetMatchesCanvas) {
      // Widget is sized to match canvas - minimum zoom is 100% (1.0)
      return math.max(widget.minScale, 1.0);
    }

    // Calculate the scale needed to fit the canvas within the viewport with some padding
    const padding = 50.0; // 50 pixels of padding around the canvas
    final availableWidth = viewportSize.width - (padding * 2);
    final availableHeight = viewportSize.height - (padding * 2);

    if (availableWidth <= 0 || availableHeight <= 0) {
      return math.max(widget.minScale, 1.0);
    }

    final scaleToFitWidth = availableWidth / canvasSize.width;
    final scaleToFitHeight = availableHeight / canvasSize.height;

    // Use the smaller scale to ensure the canvas fits in both dimensions
    final minScaleToFit = math.min(scaleToFitWidth, scaleToFitHeight);

    // Ensure minimum zoom is 100% (1.0) - never zoom out below actual size
    return math.max(widget.minScale, math.max(minScaleToFit, 1.0));
  }

  /// Clamps the offset to prevent panning outside the canvas bounds when a finite canvas is set
  Offset _clampOffset(Offset offset, double scale) {
    // Get canvas size from widget parameter or notifier
    final canvasSize = widget.canvasSize ??
        (widget.notifier is ScribbleNotifier
            ? (widget.notifier as ScribbleNotifier).canvasSize
            : null);

    if (canvasSize == null) {
      // No canvas size limit, return the offset as-is
      return offset;
    }

    // We need the viewport size to calculate bounds
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return offset;
    }

    final viewportSize = renderBox.size;

    // Check if the widget size matches the canvas size (like in the example app)
    final widgetMatchesCanvas =
        (viewportSize.width - canvasSize.width).abs() < 1.0 &&
            (viewportSize.height - canvasSize.height).abs() < 1.0;

    if (widgetMatchesCanvas) {
      // Widget is sized to match canvas - simpler clamping logic
      // The canvas already fills the widget, so we just need to prevent over-panning when zoomed

      final scaledCanvasWidth = canvasSize.width * scale;
      final scaledCanvasHeight = canvasSize.height * scale;

      // Calculate bounds to keep the scaled canvas within the viewport
      double minX, maxX, minY, maxY;

      if (scaledCanvasWidth <= viewportSize.width) {
        // Canvas fits within viewport width - center it
        final centerX = (viewportSize.width - scaledCanvasWidth) / 2;
        minX = maxX = centerX;
      } else {
        // Canvas is larger than viewport - allow panning but keep bounds
        maxX = 0; // Canvas left edge can be at viewport left edge
        minX = viewportSize.width -
            scaledCanvasWidth; // Canvas right edge at viewport right edge
      }

      if (scaledCanvasHeight <= viewportSize.height) {
        // Canvas fits within viewport height - center it
        final centerY = (viewportSize.height - scaledCanvasHeight) / 2;
        minY = maxY = centerY;
      } else {
        // Canvas is larger than viewport - allow panning but keep bounds
        maxY = 0; // Canvas top edge can be at viewport top edge
        minY = viewportSize.height -
            scaledCanvasHeight; // Canvas bottom edge at viewport bottom edge
      }

      return Offset(
        offset.dx.clamp(minX, maxX),
        offset.dy.clamp(minY, maxY),
      );
    }

    // Original logic for when canvas is smaller than widget and needs to be centered
    final scaledCanvasWidth = canvasSize.width * scale;
    final scaledCanvasHeight = canvasSize.height * scale;

    // Calculate bounds to ensure the canvas stays within the viewport
    double minX, maxX, minY, maxY;

    if (scaledCanvasWidth <= viewportSize.width) {
      // Canvas fits within viewport width - center it
      final centerX = (viewportSize.width - scaledCanvasWidth) / 2;
      minX = maxX = centerX;
    } else {
      // Canvas is larger than viewport - constrain panning
      maxX = 0;
      minX = viewportSize.width - scaledCanvasWidth;
    }

    if (scaledCanvasHeight <= viewportSize.height) {
      // Canvas fits within viewport height - center it
      final centerY = (viewportSize.height - scaledCanvasHeight) / 2;
      minY = maxY = centerY;
    } else {
      // Canvas is larger than viewport - constrain panning
      maxY = 0;
      minY = viewportSize.height - scaledCanvasHeight;
    }

    return Offset(
      offset.dx.clamp(minX, maxX),
      offset.dy.clamp(minY, maxY),
    );
  }

  /// Clamps the offset with less restriction during zoom operations to maintain focal point
  Offset _clampOffsetDuringZoom(Offset offset, double scale) {
    final canvasSize = widget.canvasSize ??
        (widget.notifier is ScribbleNotifier
            ? (widget.notifier as ScribbleNotifier).canvasSize
            : null);

    if (canvasSize == null) {
      // No canvas size limit, return the offset as-is
      return offset;
    }

    // We need the viewport size to calculate bounds
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return offset;
    }

    final viewportSize = renderBox.size;

    // During zoom, we want to be very lenient with clamping to preserve
    // the focal point behavior. Only prevent extreme cases where the
    // canvas would be completely outside the viewport.

    // Calculate the scaled canvas size
    final scaledCanvasWidth = canvasSize.width * scale;
    final scaledCanvasHeight = canvasSize.height * scale;

    // Very generous tolerance during zoom - we want to preserve focal point
    final zoomTolerance = 100.0;

    // Calculate extreme bounds - only clamp if canvas would be completely off-screen
    final minX = viewportSize.width - scaledCanvasWidth - zoomTolerance;
    final maxX = zoomTolerance;
    final minY = viewportSize.height - scaledCanvasHeight - zoomTolerance;
    final maxY = zoomTolerance;

    // Ensure clamp bounds are valid (min <= max)
    final validMinX = math.min(minX, maxX);
    final validMaxX = math.max(minX, maxX);
    final validMinY = math.min(minY, maxY);
    final validMaxY = math.max(minY, maxY);

    return Offset(
      offset.dx.clamp(validMinX, validMaxX),
      offset.dy.clamp(validMinY, validMaxY),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    // Store the current state when gesture starts
    _initialScale = _baseScale;
    _initialOffset = _baseOffset;
    _initialFocalPoint = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!widget.enableInteraction) return;

    // Calculate dynamic minimum scale based on canvas size
    final dynamicMinScale = _calculateMinScale();

    // Calculate new scale based on gesture scale from start
    final newScale =
        (_initialScale * details.scale).clamp(dynamicMinScale, widget.maxScale);

    var newOffset = _initialOffset;

    // Check if this is primarily a zoom gesture or a pan gesture
    // Use a more sensitive threshold and also check if scale actually changed
    final isZooming = (details.scale - 1.0).abs() > 0.02 &&
        (newScale - _initialScale).abs() > 0.001;

    if (isZooming) {
      // This is a zoom gesture - use focal point zooming
      final focalPoint = details.focalPoint;

      // In fixed canvas mode, we need to ensure proper coordinate transformation
      // The key insight: gestures provide screen coordinates, but our pan offset
      // is also in screen coordinates (relative to the widget)

      // Method: Keep the point under the cursor stationary during zoom
      // 1. Calculate what canvas point is currently under the cursor
      // 2. Calculate new pan offset so that same canvas point stays under cursor

      // The relationship is: screen_pos = canvas_pos * scale + pan_offset
      // Solving for canvas_pos: canvas_pos = (screen_pos - pan_offset) / scale
      final canvasPointUnderCursor = Offset(
        (focalPoint.dx - _initialOffset.dx) / _initialScale,
        (focalPoint.dy - _initialOffset.dy) / _initialScale,
      );

      // Now calculate new pan offset to keep the same canvas point under cursor
      // We want: focalPoint = canvasPointUnderCursor * newScale + newOffset
      // So: newOffset = focalPoint - canvasPointUnderCursor * newScale
      newOffset = Offset(
        focalPoint.dx - (canvasPointUnderCursor.dx * newScale),
        focalPoint.dy - (canvasPointUnderCursor.dy * newScale),
      );

      // Apply lenient clamping during zoom to allow better focal point tracking
      newOffset = _clampOffsetDuringZoom(newOffset, newScale);
    } else {
      // This is a pan gesture - use focal point delta for translation
      final focalPointDelta = details.focalPoint - _initialFocalPoint;
      newOffset = _initialOffset + focalPointDelta;

      // Apply strict clamping immediately for pan gestures to prevent any out-of-bounds movement
      newOffset = _clampOffset(newOffset, newScale);
    }

    // Update the notifier with new zoom and pan values
    if (widget.notifier is ScribbleNotifier) {
      (widget.notifier as ScribbleNotifier).setZoomAndPan(
        scaleFactor: newScale,
        panOffset: newOffset,
      );
    }

    _baseScale = newScale;
    _baseOffset = newOffset;
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // Update base values for next gesture and apply stricter clamping
    _baseScale = widget.notifier.value.scaleFactor;

    // Apply stricter clamping at the end of the gesture
    final strictlyClampedOffset =
        _clampOffset(widget.notifier.value.panOffset, _baseScale);
    _baseOffset = strictlyClampedOffset;

    // Update the notifier with strictly clamped values if they changed
    if (strictlyClampedOffset != widget.notifier.value.panOffset) {
      if (widget.notifier is ScribbleNotifier) {
        (widget.notifier as ScribbleNotifier).setZoomAndPan(
          scaleFactor: _baseScale,
          panOffset: strictlyClampedOffset,
        );
      }
    }
  }

  /// Reset zoom and pan to default values
  void resetView() {
    // Use the minimum scale that fits the canvas appropriately
    final defaultScale = math.max(1.0, _calculateMinScale());
    final defaultOffset = _clampOffset(Offset.zero, defaultScale);

    setState(() {
      _baseScale = defaultScale;
      _baseOffset = defaultOffset;
      if (widget.notifier is ScribbleNotifier) {
        (widget.notifier as ScribbleNotifier).setZoomAndPan(
          scaleFactor: defaultScale,
          panOffset: defaultOffset,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableInteraction) {
      // If interaction is disabled, just return the regular Scribble widget
      return Scribble(
        notifier: widget.notifier,
        drawPen: widget.drawPen,
        drawEraser: widget.drawEraser,
        fixedStrokeWidth: widget.fixedStrokeWidth,
        canvasSize: widget.canvasSize,
        displaySize: widget.displaySize,
        showDotGrid: widget.showDotGrid,
        dotSpacing: widget.dotSpacing,
        dotColor: widget.dotColor,
        dotRadius: widget.dotRadius,
        backgroundImageFit: widget.backgroundImageFit,
      );
    }

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Scribble(
        notifier: widget.notifier,
        drawPen: widget.drawPen,
        drawEraser: widget.drawEraser,
        fixedStrokeWidth: widget.fixedStrokeWidth,
        canvasSize: widget.canvasSize,
        displaySize: widget.displaySize,
        showDotGrid: widget.showDotGrid,
        dotSpacing: widget.dotSpacing,
        dotColor: widget.dotColor,
        dotRadius: widget.dotRadius,
        backgroundImageFit: widget.backgroundImageFit,
      ),
    );
  }
}
