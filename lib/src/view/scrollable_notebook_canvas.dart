import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/page/page.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/region/region_type.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';
import 'package:scribble/src/view/painting/constrained_row_line_painter.dart';
import 'package:scribble/src/view/painting/dynamic_row_line_painter.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';
import 'package:scribble/src/view/pan_gesture_catcher.dart';
import 'package:scribble/src/view/state/notebook_state.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

/// Enum for different row line display modes
enum RowLineMode {
  /// Always show row lines
  static,
  /// Show row lines dynamically based on user writing
  dynamic,
}

/// Enum for different row constraint modes that control writing behavior
enum RowConstraintMode {
  /// No constraints - users can write anywhere (default behavior)
  none,
  /// Users must write lines sequentially from top to bottom
  sequential,
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

    /// Spacing between row lines in logical pixels.
    this.rowLineSpacing = 24.0,

    /// Color of the row lines.
    /// Ignored if [theme] is provided.
    this.rowLineColor = const Color(0xFFBDBDBD),

    /// Width of the row lines in logical pixels.
    this.rowLineWidth = 1.0,

    /// Mode for constraining writing to specific rows.
    this.rowConstraintMode = RowConstraintMode.none,

    /// Color for the line numbers.
    /// Ignored if [theme] is provided.
    this.lineNumberColor = const Color(0xFF616161),

    /// Font size for the line numbers.
    this.lineNumberFontSize = 12.0,

    /// Whether to automatically add new pages when writing near the bottom.
    this.autoAddPages = false,

    /// Distance from bottom edge that triggers new page creation.
    this.bottomMarginThreshold = 50.0,


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

  /// Spacing between row lines in logical pixels.
  final double rowLineSpacing;

  /// Color of the row lines.
  final Color rowLineColor;

  /// Width of the row lines in logical pixels.
  final double rowLineWidth;

  /// Mode for constraining writing to specific rows.
  final RowConstraintMode rowConstraintMode;

  /// Color for the line numbers.
  final Color lineNumberColor;

  /// Font size for the line numbers.
  final double lineNumberFontSize;

  /// Whether to automatically add new pages when writing near the bottom.
  final bool autoAddPages;

  /// Distance from bottom edge that triggers new page creation.
  final double bottomMarginThreshold;


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
  double _currentRowLineSpacing = 24;
  
  // Row controls state
  OverlayEntry? _rowControlsOverlay;
  

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
    _currentRowLineSpacing = widget.rowLineSpacing;
    
    // Enable auto-page addition - always enabled in dynamic mode
    if (widget.autoAddPages) {
      widget.notifier.setAutoAddPages(true, bottomThreshold: widget.bottomMarginThreshold);
    }
    
    // Setup row constraint mode
    widget.notifier.setRowConstraintMode(
      widget.rowConstraintMode,
      rowLineSpacing: _currentRowLineSpacing,
      topMargin: 30,
    );
  }

  @override
  void didUpdateWidget(ScrollableNotebookCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rowLineSpacing != widget.rowLineSpacing) {
      _currentRowLineSpacing = widget.rowLineSpacing;
    }
    
    // Update auto-page settings if they changed
    if (oldWidget.autoAddPages != widget.autoAddPages ||
        oldWidget.bottomMarginThreshold != widget.bottomMarginThreshold) {
      widget.notifier.setAutoAddPages(widget.autoAddPages, bottomThreshold: widget.bottomMarginThreshold);
    }
    
    // Update constraint mode settings if they changed
    if (oldWidget.rowConstraintMode != widget.rowConstraintMode ||
        oldWidget.rowLineSpacing != widget.rowLineSpacing) {
      widget.notifier.setRowConstraintMode(
        widget.rowConstraintMode,
        rowLineSpacing: _currentRowLineSpacing,
        topMargin: 30,
      );
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


  /// Checks if a point is tapping directly on a visible line number.
  /// Returns the row index if tapping on a line number, null otherwise.


  /// Removes the row controls overlay.
  void _removeRowControls() {
    _rowControlsOverlay?.remove();
    _rowControlsOverlay = null;
  }

  /// Builds the line number buttons positioned over the canvas.
  List<Widget> _buildLineNumberButtons(int pageIndex, NotebookPage page, Size paperSize) {
    const leftMargin = 20.0;
    const topMargin = 30.0;
    const bottomMargin = 30.0;
    // Remove unused variable
    
    const drawingTop = topMargin;
    final drawingBottom = paperSize.height - bottomMargin;
    final availableHeight = drawingBottom - drawingTop;
    
    if (drawingTop >= drawingBottom || availableHeight <= 0) return [];
    
    final lineSpacing = _currentRowLineSpacing;
    final maxLines = (availableHeight / lineSpacing).floor();
    
    // Get content points for dynamic visibility
    final contentPoints = _getContentPoints(page.sketch);
    
    final buttons = <Widget>[];
    
    for (var i = 0; i < maxLines; i++) {
      final currentLine = 1 + i;
      final betweenRowsY = drawingTop + (i * lineSpacing) + (lineSpacing / 2);
      
      if (betweenRowsY > drawingBottom) break;
      
      // Calculate opacity for dynamic mode
      final opacity = _calculateNumberOpacity(betweenRowsY, contentPoints, i);
      
      // Skip if too transparent
      if (opacity < 0.01) continue;
      
      // Skip if line number position is in a free drawing region
      if (_isVerticalPositionInFreeDrawingRegion(betweenRowsY, page.regions)) continue;
      
      // Position the button (centered in left margin)
      const buttonX = leftMargin + 4; // Center horizontally in margin
      final buttonY = betweenRowsY - 16; // Center button vertically
      
      buttons.add(
        Positioned(
          left: buttonX,
          top: buttonY,
          width: 32,
          height: 32,
          child: Opacity(
            opacity: opacity,
            child: PopupMenuButton<String>(
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'insert',
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 16),
                      SizedBox(width: 8),
                      Text('Insert Row Above'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'free_space',
                  child: Row(
                    children: [
                      Icon(Icons.crop_free, size: 16),
                      SizedBox(width: 8),
                      Text('Add Drawing Space'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 16),
                      SizedBox(width: 8),
                      Text('Delete Row'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) => _handleRowAction(value, pageIndex, i),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget._lineNumberColor.withValues(alpha: 0.5),
                  ),
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    currentLine.toString(),
                    style: TextStyle(
                      fontSize: widget.lineNumberFontSize - 1,
                      fontWeight: FontWeight.w500,
                      color: widget._lineNumberColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return buttons;
  }
  
  /// Gets content points from sketch for proximity calculations.
  List<Offset> _getContentPoints(Sketch? sketch) {
    if (sketch == null) return [];
    
    final points = <Offset>[];
    for (final line in sketch.lines) {
      for (final point in line.points) {
        points.add(Offset(point.x, point.y));
      }
    }
    return points;
  }
  
  /// Calculates line number opacity based on proximity to content.
  double _calculateNumberOpacity(double numberY, List<Offset> contentPoints, int lineIndex) {
    // Always show the first two line numbers at full opacity initially
    if (lineIndex == 0 || lineIndex == 1) {
      return 1;
    }

    if (contentPoints.isEmpty) {
      // If no content, only show the first two line numbers
      return 0;
    }

    // Find the lowest content point (highest Y value) to determine progression
    var maxContentY = contentPoints.isEmpty ? 0.0 : contentPoints.first.dy;
    for (final point in contentPoints) {
      if (point.dy > maxContentY) {
        maxContentY = point.dy;
      }
    }

    // Calculate which line the content has reached based on progression
    const topMargin = 30.0;
    final lineSpacing = _currentRowLineSpacing;
    final contentLineIndex = ((maxContentY - topMargin) / lineSpacing).floor();
    
    // Show line numbers progressively: if content has reached line N, show numbers 1 through N+2
    if (lineIndex <= contentLineIndex + 2) {
      // Find the closest content point to this line number
      var minDistance = double.infinity;
      
      for (final point in contentPoints) {
        final distance = (point.dy - numberY).abs();
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      // Calculate opacity based on distance for visible line numbers
      const proximityRadius = 40.0;
      const fadeDistance = 80.0;
      
      if (minDistance <= proximityRadius) {
        // Full opacity near content
        return 1;
      } else if (minDistance <= proximityRadius + fadeDistance) {
        // Fade out over distance
        final fadeProgress = (minDistance - proximityRadius) / fadeDistance;
        return (1 - fadeProgress).clamp(0.3, 1.0);
      } else {
        // Medium opacity for distant but revealed line numbers
        return 0.3;
      }
    } else {
      // Line numbers beyond the progression are not shown
      return 0;
    }
  }
  
  /// Checks if a vertical position is within a free drawing region.
  bool _isVerticalPositionInFreeDrawingRegion(double y, List<PageRegion> regions) {
    final freeDrawingRegions = regions
        .where((region) => region.type == RegionType.freeDrawing)
        .toList();
    
    for (final region in freeDrawingRegions) {
      if (region.bounds.top <= y && y <= region.bounds.bottom) {
        return true;
      }
    }
    return false;
  }
  
  /// Handles row action selection from popup menu.
  void _handleRowAction(String action, int pageIndex, int rowIndex) {
    switch (action) {
      case 'insert':
        _insertRowAbove(pageIndex, rowIndex);
      case 'free_space':
        // Directly add a generous free drawing space
        _insertFreeDrawingSpace(pageIndex, rowIndex, FreeDrawingPreset.sketch);
      case 'delete':
        _eraseRow(pageIndex, rowIndex);
    }
  }
  
  /// Builds free space icon buttons for existing free drawing regions.
  List<Widget> _buildFreeSpaceButtons(int pageIndex, NotebookPage page, Size paperSize) {
    final buttons = <Widget>[];
    
    // Get only free drawing regions
    final freeDrawingRegions = page.regions
        .where((region) => region.type == RegionType.freeDrawing)
        .toList();
    
    for (final region in freeDrawingRegions) {
      final bounds = region.bounds;
      
      // Position button in the center of the region vertically, in left margin
      const buttonX = 30.0 - 16; // Center in 60px left margin
      final buttonY = bounds.center.dy - 16; // Center vertically in region
      
      // Get icon for the preset type
      final icon = _getPresetIcon(region.preset);
      final color = _getPresetColor(region.preset ?? FreeDrawingPreset.custom);
      
      buttons.add(
        Positioned(
          left: buttonX,
          top: buttonY,
          width: 32,
          height: 32,
          child: PopupMenuButton<String>(
            offset: const Offset(32, 0),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'extend',
                child: Row(
                  children: [
                    Icon(Icons.expand_more, size: 16),
                    SizedBox(width: 8),
                    Text('Extend Space'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16),
                    SizedBox(width: 8),
                    Text('Delete Free Space'),
                  ],
                ),
              ),
            ],
            onSelected: (value) => _handleFreeSpaceAction(value, pageIndex, region),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                ),
                color: color.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      );
      
      // No resize handles needed - using extend button instead
    }
    
    return buttons;
  }
  
  /// Gets the appropriate icon for a free drawing preset.
  IconData _getPresetIcon(FreeDrawingPreset? preset) {
    // Since we only use one type now, show a generic free drawing icon
    return Icons.crop_free;
  }
  
  /// Gets the appropriate color for a free drawing preset.
  Color _getPresetColor(FreeDrawingPreset preset) {
    // Since we only use 'sketch' preset now, return a neutral color for all free spaces
    return Colors.blue.shade300;
  }
  
  
  /// Handles free space action selection from popup menu.
  void _handleFreeSpaceAction(String action, int pageIndex, PageRegion region) {
    switch (action) {
      case 'extend':
        _extendFreeSpace(pageIndex, region);
      case 'delete':
        _deleteFreeSpace(pageIndex, region);
    }
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
      topMargin: 30,
    );
  }

  /// Inserts a new row above the specified row with animation.
  Future<void> _insertRowAbove(int pageIndex, int rowIndex) async {
    // Remove the controls popup immediately
    _removeRowControls();
    
    // Perform animated row insertion
    await widget.notifier.insertRowAboveAnimated(
      rowIndex,
      rowLineSpacing: _currentRowLineSpacing,
      topMargin: 30,
    );
  }



  /// Inserts a free drawing space with the specified preset.
  Future<void> _insertFreeDrawingSpace(int pageIndex, int rowIndex, FreeDrawingPreset preset) async {
    // Remove the overlay
    _removeRowControls();
    
    // Get current paper dimensions for region calculation
    final notebookState = widget.notifier.value;
    final currentPage = notebookState.notebook.currentPage;
    final paperSize = currentPage.paperSize;
    
    // Insert the actual free drawing region with animation
    await widget.notifier.insertFreeDrawingRegionAnimated(
      rowIndex: rowIndex,
      preset: preset,
      rowLineSpacing: _currentRowLineSpacing,
      topMargin: 30,
      paperWidth: paperSize.width,
      leftMargin: 60,
      rightMargin: 20,
    );
  }


  /// Extends a free drawing space by adding more height.
  void _extendFreeSpace(int pageIndex, PageRegion region) {
    // Remove the controls popup immediately
    _removeRowControls();
    
    // Calculate extension amount (equivalent to 4 row lines)
    final extensionHeight = _currentRowLineSpacing * 4;
    
    // Create new bounds with extended height
    final newBounds = Rect.fromLTRB(
      region.bounds.left,
      region.bounds.top,
      region.bounds.right,
      region.bounds.bottom + extensionHeight,
    );
    
    // Update the region with new bounds
    final updatedRegion = region.copyWith(bounds: newBounds);
    widget.notifier.updateRegionBounds(region, updatedRegion);
  }
  
  /// Deletes a free drawing region.
  Future<void> _deleteFreeSpace(int pageIndex, PageRegion region) async {
    // Remove the controls popup immediately
    _removeRowControls();
    
    // Delete the free drawing region with animation
    await widget.notifier.removeFreeDrawingRegionAnimated(
      region,
      duration: const Duration(milliseconds: 300),
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
    
    for (var i = 0; i < notebook.pages.length; i++) {
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
    var totalHeight = widget.pageSpacing * 2; // Top and bottom padding
    
    for (var i = 0; i < notebook.pages.length; i++) {
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
    
    for (var i = 0; i < pageIndex; i++) {
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
        painter: _getRowLinePainter(Size(paperSize.width, paperSize.height), page, state),
        foregroundPainter: isCurrentPage ? ScribbleEditingPainter(
          state: _convertToScribbleState(state),
          drawPointer: widget.drawPen,
          drawEraser: widget.drawEraser,
          simulatePressure: widget.simulatePressure,
          theme: widget.theme,
        ) : null,
        child: Stack(
          children: [
            RepaintBoundary(
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
            // Free space icon buttons positioned individually
            ..._buildFreeSpaceButtons(pageIndex, page, Size(paperSize.width, paperSize.height)),
            // Line number buttons positioned individually
            ..._buildLineNumberButtons(pageIndex, page, Size(paperSize.width, paperSize.height)),
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

  /// Gets the appropriate row line painter based on configuration.
  CustomPainter _getRowLinePainter(Size paperSize, NotebookPage page, NotebookState state) {
    const leftMargin = 60.0;
    const rightMargin = 20.0;
    const topMargin = 30.0;
    const bottomMargin = 30.0;

    // Use constrained painter if constraint mode is active
    if (widget.rowConstraintMode != RowConstraintMode.none) {
      return ConstrainedRowLinePainter(
        paperWidth: paperSize.width,
        paperHeight: paperSize.height,
        lineSpacing: _currentRowLineSpacing,
        lineColor: widget._rowLineColor,
        lineWidth: widget.rowLineWidth,
        leftMargin: leftMargin,
        rightMargin: rightMargin,
        topMargin: topMargin,
        bottomMargin: bottomMargin,
        sketch: page.sketch,
        proximityRadius: 40,
        fadeDistance: 80,
        isDynamic: true,
        regions: page.regions,
      );
    }

    // Always use dynamic row line painter
    return DynamicRowLinePainter(
      paperWidth: paperSize.width,
      paperHeight: paperSize.height,
      lineSpacing: _currentRowLineSpacing,
      lineColor: widget._rowLineColor,
      lineWidth: widget.rowLineWidth,
      sketch: page.sketch,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
      proximityRadius: 40,
      fadeDistance: 80,
      regions: page.regions,
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


