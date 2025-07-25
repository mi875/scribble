import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';
import 'package:scribble/src/view/pan_gesture_catcher.dart';
import 'package:scribble/src/view/state/notebook_state.dart';

/// A canvas widget that renders notebook pages with fixed paper sizes.
/// 
/// This widget provides a notebook-like drawing experience with:
/// - Fixed paper dimensions
/// - Paper background rendering
/// - Multi-page support through NotebookNotifier
/// - Zoom and pan capabilities
class NotebookCanvas extends StatefulWidget {
  /// Creates a new notebook canvas.
  const NotebookCanvas({
    /// The notifier that controls this notebook canvas.
    required this.notifier,

    /// Whether to draw the pointer when in drawing mode
    this.drawPen = true,

    /// Whether to draw the pointer when in erasing mode
    this.drawEraser = true,

    /// Whether to simulate pressure for lines without pressure information
    this.simulatePressure = true,

    /// Background color for the paper. If null, uses white.
    this.paperColor = Colors.white,

    /// Color for the paper border. If null, uses light gray.
    this.paperBorderColor = Colors.grey,

    /// Width of the paper border in logical pixels.
    this.paperBorderWidth = 1.0,

    /// Whether to show the paper border.
    this.showPaperBorder = true,

    /// Whether to show a shadow under the paper.
    this.showPaperShadow = true,

    super.key,
  });

  /// The notifier that controls this notebook canvas.
  final NotebookNotifier notifier;

  /// Whether to draw the pointer when in drawing mode.
  final bool drawPen;

  /// Whether to draw the pointer when in erasing mode.
  final bool drawEraser;

  /// Whether to simulate pressure when drawing lines that don't have pressure
  /// information (all points have the same pressure).
  final bool simulatePressure;

  /// Background color for the paper.
  final Color paperColor;

  /// Color for the paper border.
  final Color paperBorderColor;

  /// Width of the paper border in logical pixels.
  final double paperBorderWidth;

  /// Whether to show the paper border.
  final bool showPaperBorder;

  /// Whether to show a shadow under the paper.
  final bool showPaperShadow;

  @override
  State<NotebookCanvas> createState() => _NotebookCanvasState();
}

class _NotebookCanvasState extends State<NotebookCanvas> {
  double _initialZoom = 1.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NotebookState>(
      valueListenable: widget.notifier,
      builder: (context, state, _) {
        final paperSize = widget.notifier.currentPaperSize;
        final drawCurrentTool = widget.drawPen && state is NotebookDrawing ||
            widget.drawEraser && state is NotebookErasing;

        // Create the paper-sized container
        final paperWidget = Container(
          width: paperSize.width,
          height: paperSize.height,
          decoration: BoxDecoration(
            color: widget.paperColor,
            border: widget.showPaperBorder
                ? Border.all(
                    color: widget.paperBorderColor,
                    width: widget.paperBorderWidth,
                  )
                : null,
            boxShadow: widget.showPaperShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ]
                : null,
          ),
          child: CustomPaint(
            foregroundPainter: ScribbleEditingPainter(
              state: _convertToScribbleState(state),
              drawPointer: widget.drawPen,
              drawEraser: widget.drawEraser,
              simulatePressure: widget.simulatePressure,
            ),
            child: RepaintBoundary(
              key: widget.notifier.repaintBoundaryKey,
              child: CustomPaint(
                painter: ScribblePainter(
                  sketch: state.currentSketch,
                  scaleFactor: state.scaleFactor,
                  simulatePressure: widget.simulatePressure,
                ),
              ),
            ),
          ),
        );

        // Wrap in gesture handling if active
        final canvasWidget = !state.active
            ? paperWidget
            : GestureCatcher(
                pointerKindsToCatch: state.supportedPointerKinds,
                child: MouseRegion(
                  cursor: drawCurrentTool &&
                          state.supportedPointerKinds
                              .contains(PointerDeviceKind.mouse)
                      ? SystemMouseCursors.none
                      : MouseCursor.defer,
                  onExit: widget.notifier.onPointerExit,
                  child: Listener(
                    onPointerDown: widget.notifier.onPointerDown,
                    onPointerMove: widget.notifier.onPointerUpdate,
                    onPointerUp: widget.notifier.onPointerUp,
                    onPointerHover: widget.notifier.onPointerHover,
                    onPointerCancel: widget.notifier.onPointerCancel,
                    child: paperWidget,
                  ),
                ),
              );

        // Apply zoom transformation and pan offset
        final transformedWidget = Transform.translate(
          offset: state.panOffset,
          child: Transform.scale(
            scale: state.zoomLevel,
            child: canvasWidget,
          ),
        );
        
        // Wrap with gesture detection for pinch-to-zoom and pan
        return GestureDetector(
          onScaleStart: (details) {
            // Store initial zoom level
            _initialZoom = state.zoomLevel;
          },
          onScaleUpdate: (details) {
            if (details.pointerCount >= 2) {
              // Handle zoom (pinch-to-zoom)
              final newZoom = (_initialZoom * details.scale).clamp(0.1, 5.0);
              widget.notifier.setZoomLevel(newZoom);
              
              // Auto-center when zooming down to 1.0 or below
              if (newZoom <= 1.0 && state.zoomLevel > 1.0) {
                widget.notifier.setPanOffset(Offset.zero);
              }
            } else if (details.pointerCount == 1) {
              // Handle pan (single finger drag)
              final delta = details.focalPointDelta;
              final newPanOffset = _constrainPanOffset(
                state.panOffset + delta,
                state.zoomLevel,
                paperSize,
                context,
              );
              widget.notifier.setPanOffset(newPanOffset);
            }
          },
          child: ClipRect(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(child: transformedWidget),
            ),
          ),
        );
      },
    );
  }

  /// Constrains the pan offset to keep the page within reasonable bounds.
  /// Ensures at least part of the page remains visible in the viewport.
  Offset _constrainPanOffset(
    Offset panOffset,
    double zoomLevel,
    PaperSize paperSize,
    BuildContext context,
  ) {
    // If zoom is at or below 1.0, allow centering (no constraints needed)
    if (zoomLevel <= 1.0) {
      return Offset.zero;
    }
    
    // Get the available canvas size (not the full screen size)
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return panOffset; // fallback if can't get size
    }
    
    final canvasSize = renderBox.size;
    
    // Calculate the scaled paper dimensions
    final scaledPaperWidth = paperSize.width * zoomLevel;
    final scaledPaperHeight = paperSize.height * zoomLevel;
    
    // Define minimum visible area (at least 50px of the page should be visible)
    const minVisibleSize = 50.0;
    
    // Only constrain if the paper is larger than the canvas
    final constrainX = scaledPaperWidth > canvasSize.width;
    final constrainY = scaledPaperHeight > canvasSize.height;
    
    double clampedX = panOffset.dx;
    double clampedY = panOffset.dy;
    
    if (constrainX) {
      // Keep paper within canvas bounds
      final maxX = canvasSize.width / 2 - minVisibleSize;
      final minX = -canvasSize.width / 2 + minVisibleSize;
      clampedX = panOffset.dx.clamp(minX, maxX);
    }
    
    if (constrainY) {
      // Keep paper within canvas bounds
      final maxY = canvasSize.height / 2 - minVisibleSize;
      final minY = -canvasSize.height / 2 + minVisibleSize;
      clampedY = panOffset.dy.clamp(minY, maxY);
    }
    
    return Offset(clampedX, clampedY);
  }

  /// Converts NotebookState to ScribbleState for compatibility with existing
  /// painters. This is a temporary workaround until we create notebook-specific
  /// painters.
  ScribbleState _convertToScribbleState(NotebookState state) {
    return state.map(
      drawing: (s) => ScribbleState.drawing(
        sketch: s.currentSketch,
        activeLine: s.activeLine,
        allowedPointersMode: s.allowedPointersMode,
        activePointerIds: s.activePointerIds,
        pointerPosition: s.pointerPosition,
        selectedColor: s.selectedColor,
        selectedWidth: s.selectedWidth,
        scaleFactor: s.scaleFactor,
        simplificationTolerance: s.simplificationTolerance,
      ),
      erasing: (s) => ScribbleState.erasing(
        sketch: s.currentSketch,
        allowedPointersMode: s.allowedPointersMode,
        activePointerIds: s.activePointerIds,
        pointerPosition: s.pointerPosition,
        selectedWidth: s.selectedWidth,
        scaleFactor: s.scaleFactor,
        simplificationTolerance: s.simplificationTolerance,
      ),
    );
  }
}
