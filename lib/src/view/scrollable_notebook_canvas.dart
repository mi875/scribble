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

    /// Theme configuration for colors. When provided, individual color 
    /// parameters are ignored in favor of theme colors.
    this.theme,

    /// Background color for the paper. If null, uses white.
    /// Ignored if [theme] is provided.
    this.paperColor = Colors.white,

    /// Color for the paper border. If null, uses light gray.
    /// Ignored if [theme] is provided.
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
    /// Ignored if [theme] is provided.
    this.rowLineColor = const Color(0xFFBDBDBD),

    /// Width of the row lines in logical pixels.
    this.rowLineWidth = 1.0,

    /// Mode for displaying row lines.
    this.rowLineMode = RowLineMode.static,

    /// Callback when row line spacing changes through gestures.
    this.onRowLineSpacingChanged,

    /// Whether to show line numbers on the left side.
    this.showLineNumbers = false,

    /// Color for the line numbers.
    /// Ignored if [theme] is provided.
    this.lineNumberColor = const Color(0xFF616161),

    /// Font size for the line numbers.
    this.lineNumberFontSize = 12.0,

    /// Whether to automatically add new pages when writing near the bottom.
    this.autoAddPages = false,

    /// Distance from bottom edge that triggers new page creation.
    this.bottomMarginThreshold = 50.0,

    /// Whether to show row controls when tapping line numbers.
    this.showRowControls = false,

    /// Callback when a row should be erased.
    this.onEraseRow,

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

  /// Theme configuration for colors. When provided, individual color 
  /// parameters are ignored in favor of theme colors.
  final ScribbleTheme? theme;

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

  /// Whether to automatically add new pages when writing near the bottom.
  final bool autoAddPages;

  /// Distance from bottom edge that triggers new page creation.
  final double bottomMarginThreshold;

  /// Whether to show row controls when tapping line numbers.
  final bool showRowControls;

  /// Callback when a row should be erased.
  final void Function(int rowIndex)? onEraseRow;

  /// Gets the resolved paper color from theme or parameter.
  Color get _paperColor => theme?.paperColor ?? paperColor;

  /// Gets the resolved paper border color from theme or parameter.
  Color get _paperBorderColor => theme?.paperBorderColor ?? paperBorderColor;

  /// Gets the resolved row line color from theme or parameter.
  Color get _rowLineColor => theme?.rowLineColor ?? rowLineColor;

  /// Gets the resolved line number color from theme or parameter.
  Color get _lineNumberColor => theme?.lineNumberColor ?? lineNumberColor;

  @override
  State<ScrollableNotebookCanvas> createState() => _ScrollableNotebookCanvasState();
}

class _ScrollableNotebookCanvasState extends State<ScrollableNotebookCanvas> {
  final TransformationController _transformationController = TransformationController();
  final Map<int, GlobalKey> _pageKeys = {};
  final GlobalKey _containerKey = GlobalKey();
  double _currentRowLineSpacing = 24.0;
  bool _isAdjustingRowLines = false;
  
  // Row controls state
  OverlayEntry? _rowControlsOverlay;
  int? _selectedRowIndex;
  int? _selectedPageIndex;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
    _currentRowLineSpacing = widget.rowLineSpacing;
    
    // Enable auto-page addition if configured and in dynamic mode
    if (widget.autoAddPages && widget.rowLineMode == RowLineMode.dynamic) {
      widget.notifier.setAutoAddPages(true, bottomThreshold: widget.bottomMarginThreshold);
    }
  }

  @override
  void didUpdateWidget(ScrollableNotebookCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rowLineSpacing != widget.rowLineSpacing) {
      _currentRowLineSpacing = widget.rowLineSpacing;
    }
    
    // Update auto-page settings if they changed
    if (oldWidget.autoAddPages != widget.autoAddPages ||
        oldWidget.rowLineMode != widget.rowLineMode ||
        oldWidget.bottomMarginThreshold != widget.bottomMarginThreshold) {
      final shouldEnable = widget.autoAddPages && widget.rowLineMode == RowLineMode.dynamic;
      widget.notifier.setAutoAddPages(shouldEnable, bottomThreshold: widget.bottomMarginThreshold);
    }
  }

  @override
  void dispose() {
    _removeRowControls();
    _transformationController
      ..removeListener(_onTransformationChanged)
      ..dispose();
    super.dispose();
  }

  /// Shows row controls at the specified position.
  void _showRowControls(int pageIndex, int rowIndex, Offset globalPosition) {
    _removeRowControls();
    
    _selectedPageIndex = pageIndex;
    _selectedRowIndex = rowIndex;
    
    _rowControlsOverlay = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        
        // Calculate optimal positioning to avoid hiding the row
        final screenSize = MediaQuery.of(context).size;
        final popupHeight = 64.0; // Estimated popup height
        final popupWidth = 180.0; // Estimated popup width
        
        // Determine if popup should appear above or below the tapped row
        final spaceBelow = screenSize.height - globalPosition.dy;
        final spaceAbove = globalPosition.dy;
        final showAbove = spaceBelow < popupHeight + 20 && spaceAbove > popupHeight + 20;
        
        // Calculate vertical position
        final topPosition = showAbove 
            ? globalPosition.dy - popupHeight - 8  // Above the row
            : globalPosition.dy + 8;               // Below the row
            
        // Calculate horizontal position (ensure it stays on screen)
        final leftPosition = (globalPosition.dx + popupWidth > screenSize.width)
            ? screenSize.width - popupWidth - 16  // Move left to fit
            : globalPosition.dx + 16;             // Normal right offset
        
        return Positioned(
          left: leftPosition,
          top: topPosition,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Arrow pointing to the row (shown above popup when below row)
              if (!showAbove)
                CustomPaint(
                  painter: _TrianglePainter(
                    color: colorScheme.surfaceContainerHigh,
                    pointUp: true,
                  ),
                  size: const Size(16, 8),
                ),
              Material(
                type: MaterialType.card,
                elevation: 3,
                shadowColor: colorScheme.shadow,
                surfaceTintColor: colorScheme.surfaceTint,
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Row ${rowIndex + 1}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.tonalIcon(
                        onPressed: () => _eraseRow(pageIndex, rowIndex),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Delete'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(72, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _removeRowControls,
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: 'Close',
                        style: IconButton.styleFrom(
                          minimumSize: const Size(36, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Arrow pointing to the row (shown below popup when above row)
              if (showAbove)
                CustomPaint(
                  painter: _TrianglePainter(
                    color: colorScheme.surfaceContainerHigh,
                    pointUp: false,
                  ),
                  size: const Size(16, 8),
                ),
            ],
          ),
        );
      },
    );
    
    Overlay.of(context).insert(_rowControlsOverlay!);
  }

  /// Removes the row controls overlay.
  void _removeRowControls() {
    _rowControlsOverlay?.remove();
    _rowControlsOverlay = null;
    _selectedRowIndex = null;
    _selectedPageIndex = null;
  }

  /// Deletes the specified row with animation.
  Future<void> _eraseRow(int pageIndex, int rowIndex) async {
    // Remove the controls popup immediately
    _removeRowControls();
    
    // Call the callback to notify the parent (before animation starts)
    widget.onEraseRow?.call(rowIndex);
    
    // Perform animated row deletion
    await widget.notifier.deleteRowAnimated(
      rowIndex,
      rowLineSpacing: _currentRowLineSpacing,
      topMargin: 30.0,
    );
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
        color: widget._paperColor,
        border: widget.showPaperBorder
            ? Border.all(
                color: isCurrentPage 
                    ? widget._paperBorderColor.withValues(alpha: 0.8)
                    : widget._paperBorderColor.withValues(alpha: 0.3),
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
                    lineColor: widget._rowLineColor,
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
                    lineColor: widget._rowLineColor,
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
          theme: widget.theme,
        ) : null,
        child: Stack(
          children: [
            CustomPaint(
              painter: widget.showLineNumbers
                  ? LineNumberPainter(
                      paperWidth: paperSize.width,
                      paperHeight: paperSize.height,
                      textColor: widget._lineNumberColor,
                      fontSize: widget.lineNumberFontSize,
                      leftMargin: 20,
                      topMargin: 30,
                      bottomMargin: 30,
                      rowLineSpacing: widget.showRowLines ? _currentRowLineSpacing : null,
                      sketch: widget.rowLineMode == RowLineMode.dynamic 
                          ? page.sketch : null,
                      isDynamic: widget.rowLineMode == RowLineMode.dynamic,
                      proximityRadius: 40,
                      fadeDistance: 80,
                    )
                  : null,
              child: RepaintBoundary(
                key: isCurrentPage ? widget.notifier.repaintBoundaryKey : null,
                child: CustomPaint(
                  painter: ScribblePainter(
                    sketch: page.sketch,
                    scaleFactor: state.scaleFactor,
                    simulatePressure: widget.simulatePressure,
                    theme: widget.theme,
                  ),
                ),
              ),
            ),
            // Line number tap detector
            if (widget.showLineNumbers && widget.showRowControls)
              Positioned(
                left: 0,
                top: 0,
                width: 60, // Cover line number area
                height: paperSize.height,
                child: GestureDetector(
                  onTapDown: (details) {
                    final localY = details.localPosition.dy;
                    final rowIndex = ((localY - 30) / _currentRowLineSpacing).floor();
                    if (rowIndex >= 0) {
                      final globalPosition = details.globalPosition;
                      _showRowControls(pageIndex, rowIndex, globalPosition);
                    }
                  },
                  behavior: HitTestBehavior.translucent,
                ),
              ),
          ],
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

/// A custom painter that draws a small triangle pointer.
class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({
    required this.color,
    required this.pointUp,
  });

  final Color color;
  final bool pointUp;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    if (pointUp) {
      // Triangle pointing up (for popup below row)
      path.moveTo(size.width / 2, 0); // Top point
      path.lineTo(0, size.height); // Bottom left
      path.lineTo(size.width, size.height); // Bottom right
    } else {
      // Triangle pointing down (for popup above row)
      path.moveTo(0, 0); // Top left
      path.lineTo(size.width, 0); // Top right
      path.lineTo(size.width / 2, size.height); // Bottom point
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return color != oldDelegate.color || pointUp != oldDelegate.pointUp;
  }
}
