import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/page/page.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';
import 'package:scribble/src/view/painting/row_line_painter.dart';
import 'package:scribble/src/view/painting/dynamic_row_line_painter.dart';
import 'package:scribble/src/view/painting/line_number_painter.dart';
import 'package:scribble/src/view/pan_gesture_catcher.dart';
import 'package:scribble/src/view/state/notebook_state.dart';

/// Enum for different row line display modes
enum RowLineMode {
  /// Always show row lines
  static,
  /// Show row lines dynamically based on user writing
  dynamic,
}

/// A scrollable canvas widget that renders all notebook pages vertically.
/// 
/// This widget provides a scrollable multi-page drawing experience with:
/// - Vertical scrolling through all pages
/// - Individual page interactions
/// - Zoom and pan capabilities per page
/// - Automatic page focus detection
class ScrollableNotebookCanvas extends StatefulWidget {
  /// Creates a new scrollable notebook canvas.
  const ScrollableNotebookCanvas({
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

    /// Spacing between pages in logical pixels.
    this.pageSpacing = 32,

    /// Whether to show row lines on pages.
    this.showRowLines = false,

    /// Spacing between row lines in logical pixels.
    this.rowLineSpacing = 24.0,

    /// Color of the row lines.
    this.rowLineColor = const Color(0xFFE3F2FD),

    /// Width of the row lines in logical pixels.
    this.rowLineWidth = 0.5,

    /// Mode for displaying row lines.
    this.rowLineMode = RowLineMode.static,

    /// Callback when row line spacing changes through gestures.
    this.onRowLineSpacingChanged,

    /// Whether to show line numbers on the left side.
    this.showLineNumbers = false,

    /// Color for the line numbers.
    this.lineNumberColor = const Color(0xFF616161),

    /// Font size for the line numbers.
    this.lineNumberFontSize = 12.0,

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

  /// Spacing between pages in logical pixels.
  final double pageSpacing;

  /// Whether to show row lines on pages.
  final bool showRowLines;

  /// Spacing between row lines in logical pixels.
  final double rowLineSpacing;

  /// Color of the row lines.
  final Color rowLineColor;

  /// Width of the row lines in logical pixels.
  final double rowLineWidth;

  /// Mode for displaying row lines.
  final RowLineMode rowLineMode;

  /// Callback when row line spacing changes through gestures.
  final ValueChanged<double>? onRowLineSpacingChanged;

  /// Whether to show line numbers on the left side.
  final bool showLineNumbers;

  /// Color for the line numbers.
  final Color lineNumberColor;

  /// Font size for the line numbers.
  final double lineNumberFontSize;

  @override
  State<ScrollableNotebookCanvas> createState() => _ScrollableNotebookCanvasState();
}

class _ScrollableNotebookCanvasState extends State<ScrollableNotebookCanvas> {
  final TransformationController _transformationController = TransformationController();
  final Map<int, GlobalKey> _pageKeys = {};
  final GlobalKey _containerKey = GlobalKey();
  double _currentRowLineSpacing = 24.0;
  bool _isAdjustingRowLines = false;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
    _currentRowLineSpacing = widget.rowLineSpacing;
  }

  @override
  void didUpdateWidget(ScrollableNotebookCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rowLineSpacing != widget.rowLineSpacing) {
      _currentRowLineSpacing = widget.rowLineSpacing;
    }
  }

  @override
  void dispose() {
    _transformationController
      ..removeListener(_onTransformationChanged)
      ..dispose();
    super.dispose();
  }

  /// Called when the transformation matrix changes
  void _onTransformationChanged() {
    final matrix = _transformationController.value;
    final currentZoom = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();
    
    // Update the notifier with the current zoom and pan values
    widget.notifier.setZoomLevel(currentZoom);
    widget.notifier.setPanOffset(Offset(translation.x, translation.y));
    
    // Update current page based on visible area
    _updateCurrentPageFromTransformation();
  }

  /// Handles row line spacing gesture adjustments.
  void _handleRowLineGesture(ScaleUpdateDetails details) {
    if (!widget.showRowLines || widget.onRowLineSpacingChanged == null) return;

    if (details.pointerCount == 2) {
      // Calculate vertical distance between the two pointers
      final delta1 = details.localFocalPoint;
      final scale = details.scale;
      
      // Use scale to adjust row line spacing
      if (_isAdjustingRowLines) {
        final newSpacing = (_currentRowLineSpacing * scale).clamp(12.0, 48.0);
        setState(() {
          _currentRowLineSpacing = newSpacing;
        });
        widget.onRowLineSpacingChanged!(newSpacing);
      }
    }
  }

  /// Updates the current page based on the visible area in the transformation
  void _updateCurrentPageFromTransformation() {
    final notebook = widget.notifier.currentNotebook;
    final matrix = _transformationController.value;
    final zoom = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();
    
    final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final viewportHeight = renderBox.size.height;
    final viewportCenterY = viewportHeight / 2;
    
    // Calculate which page is at the center of the viewport
    // Account for zoom and translation
    final contentCenterY = (viewportCenterY - translation.y) / zoom;
    
    // Find which page contains this center point
    var currentOffset = widget.pageSpacing;
    
    for (int i = 0; i < notebook.pages.length; i++) {
      final paperSize = notebook.pages[i].paperSize;
      final pageHeight = paperSize.height;
      
      if (contentCenterY >= currentOffset && 
          contentCenterY < currentOffset + pageHeight) {
        if (notebook.currentPageIndex != i) {
          widget.notifier.goToPage(i);
        }
        break;
      }
      currentOffset += pageHeight + widget.pageSpacing;
    }
  }

  /// Calculates the total height of all pages plus spacing
  double _calculateTotalContentHeight() {
    final notebook = widget.notifier.currentNotebook;
    double totalHeight = widget.pageSpacing * 2; // Top and bottom padding
    
    for (int i = 0; i < notebook.pages.length; i++) {
      final paperSize = notebook.pages[i].paperSize;
      totalHeight += paperSize.height;
      
      // Add spacing between pages (except after last page)
      if (i < notebook.pages.length - 1) {
        totalHeight += widget.pageSpacing;
      }
    }
    
    return totalHeight;
  }

  /// Scrolls to the specified page by updating the transformation matrix.
  void scrollToPage(int pageIndex) {
    final notebook = widget.notifier.currentNotebook;
    if (pageIndex < 0 || pageIndex >= notebook.pages.length) return;

    // Calculate the Y offset to the target page
    var targetOffset = widget.pageSpacing; // Initial top padding
    
    for (int i = 0; i < pageIndex; i++) {
      final paperSize = notebook.pages[i].paperSize;
      targetOffset += paperSize.height + widget.pageSpacing;
    }

    // Get current transformation matrix
    final currentMatrix = _transformationController.value.clone();
    final currentZoom = currentMatrix.getMaxScaleOnAxis();
    
    // Update the translation to show the target page
    // Keep current zoom and X translation, only change Y
    final currentTranslation = currentMatrix.getTranslation();
    final newTranslation = Vector3(
      currentTranslation.x,
      -targetOffset * currentZoom,
      currentTranslation.z,
    );
    
    // Create new transformation matrix
    final newMatrix = Matrix4.identity()
      ..scale(currentZoom)
      ..translate(newTranslation.x / currentZoom, newTranslation.y / currentZoom);
    
    // Animate to the new transformation
    _transformationController.value = newMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NotebookState>(
      valueListenable: widget.notifier,
      builder: (context, state, _) {
        final notebook = state.notebook;
        final drawCurrentTool = 
            widget.drawPen && state is NotebookDrawing ||
            widget.drawEraser && state is NotebookErasing;

        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.25,
          maxScale: 4,
          constrained: false,
          key: _containerKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: _calculateTotalContentHeight(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.pageSpacing,
              ),
              child: Column(
                children: notebook.pages.asMap().entries.map((entry) {
                  final pageIndex = entry.key;
                  final page = entry.value;
                  final isCurrentPage = pageIndex == notebook.currentPageIndex;
                  
                  // Ensure we have a key for this page
                  _pageKeys[pageIndex] ??= GlobalKey();
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: pageIndex < notebook.pages.length - 1 
                          ? widget.pageSpacing
                          : 0,
                    ),
                    child: _buildPage(
                      key: _pageKeys[pageIndex]!,
                      pageIndex: pageIndex,
                      page: page,
                      state: state,
                      isCurrentPage: isCurrentPage,
                      drawCurrentTool: drawCurrentTool,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage({
    required Key key,
    required int pageIndex,
    required NotebookPage page,
    required NotebookState state,
    required bool isCurrentPage,
    required bool drawCurrentTool,
  }) {
    final paperSize = page.paperSize;
    
    // Create the paper-sized container
    final paperWidget = Container(
      width: paperSize.width,
      height: paperSize.height,
      decoration: BoxDecoration(
        color: widget.paperColor,
        border: widget.showPaperBorder
            ? Border.all(
                color: isCurrentPage 
                    ? widget.paperBorderColor.withValues(alpha: 0.8)
                    : widget.paperBorderColor.withValues(alpha: 0.3),
                width: isCurrentPage 
                    ? widget.paperBorderWidth * 2
                    : widget.paperBorderWidth,
              )
            : null,
        boxShadow: widget.showPaperShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isCurrentPage ? 0.15 : 0.05,
                  ),
                  blurRadius: isCurrentPage ? 12 : 6,
                  offset: const Offset(2, 2),
                ),
              ]
            : null,
      ),
      child: CustomPaint(
        painter: widget.showRowLines
            ? widget.rowLineMode == RowLineMode.dynamic
                ? DynamicRowLinePainter(
                    paperWidth: paperSize.width,
                    paperHeight: paperSize.height,
                    lineSpacing: _currentRowLineSpacing,
                    lineColor: widget.rowLineColor,
                    lineWidth: widget.rowLineWidth,
                    sketch: page.sketch,
                    leftMargin: widget.showLineNumbers ? 60 : 20,
                    rightMargin: 20,
                    topMargin: 30,
                    bottomMargin: 30,
                    proximityRadius: 40,
                    fadeDistance: 80,
                  )
                : RowLinePainter(
                    paperWidth: paperSize.width,
                    paperHeight: paperSize.height,
                    lineSpacing: _currentRowLineSpacing,
                    lineColor: widget.rowLineColor,
                    lineWidth: widget.rowLineWidth,
                    leftMargin: widget.showLineNumbers ? 60 : 20,
                    rightMargin: 20,
                    topMargin: 30,
                    bottomMargin: 30,
                  )
            : null,
        foregroundPainter: isCurrentPage ? ScribbleEditingPainter(
          state: _convertToScribbleState(state),
          drawPointer: widget.drawPen,
          drawEraser: widget.drawEraser,
          simulatePressure: widget.simulatePressure,
        ) : null,
        child: CustomPaint(
          painter: widget.showLineNumbers
              ? LineNumberPainter(
                  paperWidth: paperSize.width,
                  paperHeight: paperSize.height,
                  textColor: widget.lineNumberColor,
                  fontSize: widget.lineNumberFontSize,
                  leftMargin: 20,
                  topMargin: 30,
                  bottomMargin: 30,
                  rowLineSpacing: widget.showRowLines ? _currentRowLineSpacing : null,
                )
              : null,
          child: RepaintBoundary(
            key: isCurrentPage ? widget.notifier.repaintBoundaryKey : null,
            child: CustomPaint(
              painter: ScribblePainter(
                sketch: page.sketch,
                scaleFactor: state.scaleFactor,
                simulatePressure: widget.simulatePressure,
              ),
            ),
          ),
        ),
      ),
    );

    // Only add gesture handling to the current page
    final canvasWidget = !isCurrentPage || !state.active
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
                onPointerDown: (event) {
                  // Switch to this page when interacting with it
                  if (!isCurrentPage) {
                    widget.notifier.goToPage(pageIndex);
                  }
                  widget.notifier.onPointerDown(event);
                },
                onPointerMove: widget.notifier.onPointerUpdate,
                onPointerUp: widget.notifier.onPointerUp,
                onPointerHover: widget.notifier.onPointerHover,
                onPointerCancel: widget.notifier.onPointerCancel,
                child: paperWidget,
              ),
            ),
          );

    return GestureDetector(
      onTap: () {
        // Switch to this page when tapping on it
        if (!isCurrentPage) {
          widget.notifier.goToPage(pageIndex);
        }
      },
      child: Center(
        key: key,
        child: canvasWidget,
      ),
    );
  }


  /// Converts NotebookState to ScribbleState for compatibility.
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
