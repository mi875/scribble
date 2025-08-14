import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/dynamic_row_line_painter.dart';
import 'package:scribble/src/view/painting/image_row_painter.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';

/// A single-page canvas widget that provides line-by-line writing with
/// dynamic canvas extension.
///
/// This widget provides:
/// - Single page focus (no multi-page scrolling)
/// - Dynamic canvas height that extends as user writes
/// - Row-based writing with optional sequential constraints
/// - Dynamic row line visibility based on writing progress
class LineByLineCanvas extends StatefulWidget {
  /// Creates a new line-by-line canvas.
  const LineByLineCanvas({
    /// The notifier that controls this canvas.
    required this.notifier,

    /// Whether to draw the pointer when in drawing mode
    this.drawPen = true,

    /// Whether to draw the pointer when in erasing mode
    this.drawEraser = true,

    /// Whether to simulate pressure for lines without pressure information
    this.simulatePressure = true,

    /// Theme configuration for colors
    this.theme,

    /// Control how the widget derives its theme (defaults to system)
    this.themeMode = ScribbleThemeMode.system,

    /// Optional external theme controller for advanced control
    this.themeController,

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

    /// Width of the canvas in logical pixels.
    this.canvasWidth = 600.0,

    /// Color of the row lines.
    this.rowLineColor = const Color(0xFFBDBDBD),

    /// Width of the row lines in logical pixels.
    this.rowLineWidth = 1.0,

    /// Whether to enable sequential writing mode.
    this.sequentialMode = false,

    /// Color for the line numbers.
    this.lineNumberColor = const Color(0xFF616161),

    /// Font size for the line numbers.
    this.lineNumberFontSize = 12.0,
    super.key,
  });

  /// The notifier that controls this canvas.
  final LineByLineNotifier notifier;

  /// Whether to draw the pointer when in drawing mode.
  final bool drawPen;

  /// Whether to draw the pointer when in erasing mode.
  final bool drawEraser;

  /// Whether to simulate pressure when drawing lines that don't have pressure
  /// information (all points have the same pressure).
  final bool simulatePressure;

  /// Theme configuration for colors.
  final ScribbleTheme? theme;

  /// Theme derivation mode.
  final ScribbleThemeMode themeMode;

  /// Optional theme controller (advanced use).
  final ScribbleThemeController? themeController;

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

  /// Width of the canvas in logical pixels.
  final double canvasWidth;

  /// Color of the row lines.
  final Color rowLineColor;

  /// Width of the row lines in logical pixels.
  final double rowLineWidth;

  /// Whether to enable sequential writing mode.
  final bool sequentialMode;

  /// Color for the line numbers.
  final Color lineNumberColor;

  /// Font size for the line numbers.
  final double lineNumberFontSize;

  @override
  State<LineByLineCanvas> createState() => _LineByLineCanvasState();
}

class _LineByLineCanvasState extends State<LineByLineCanvas> {
  final ScrollController _scrollController = ScrollController();
  final TransformationController _transformationController =
      TransformationController();
  double _currentCanvasHeight = 400;
  bool _isPenActive = false;

  ScribbleTheme _effectiveTheme(BuildContext context) {
    if (widget.theme != null) return widget.theme!;
    if (widget.themeController != null) {
      return widget.themeController!.theme;
    }
    switch (widget.themeMode) {
      case ScribbleThemeMode.light:
        return ScribbleTheme.light;
      case ScribbleThemeMode.dark:
        return ScribbleTheme.dark;
      case ScribbleThemeMode.system:
        return ScribbleTheme.fromContext(context);
    }
  }

  @override
  void initState() {
    super.initState();

    // Set up canvas height change callback
    widget.notifier.setCanvasHeightChangeCallback((newHeight) {
      setState(() {
        _currentCanvasHeight = newHeight;
      });
      _autoScrollToKeepCurrentAreaVisible();
    });

    // Set sequential mode
    widget.notifier.setSequentialMode(widget.sequentialMode);

    // Set canvas dimensions
    widget.notifier.setCanvasWidth(widget.canvasWidth);
    _currentCanvasHeight = widget.notifier.canvasHeight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerContent();
    });
  }

  @override
  void didUpdateWidget(LineByLineCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sequentialMode != widget.sequentialMode) {
      widget.notifier.setSequentialMode(widget.sequentialMode);
    }
    if (oldWidget.canvasWidth != widget.canvasWidth) {
      widget.notifier.setCanvasWidth(widget.canvasWidth);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  /// Centers the content initially
  void _centerContent() {
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    if (size.isEmpty) return;

    // Calculate centering offsets
    final offsetX = (size.width - widget.canvasWidth) / 2;
    final offsetY = (size.height - _currentCanvasHeight) / 2;

    // Only center if content is smaller than viewport
    final centerX = offsetX > 0 ? offsetX : 0.0;
    final centerY = offsetY > 0 ? offsetY : 0.0;

    final matrix = Matrix4.identity()..translate(centerX, centerY);
    _transformationController.value = matrix;
  }

  /// Auto-scrolls to keep current writing area visible
  void _autoScrollToKeepCurrentAreaVisible() {
    if (!mounted || !_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final viewportHeight = _scrollController.position.viewportDimension;

      // If we're near the bottom, scroll to show new content
      if (currentScroll > maxScrollExtent - viewportHeight * 0.3) {
        _scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Handles row action selection from popup menu.
  void _handleRowAction(String action, int rowIndex) {
    switch (action) {
      case 'insert':
        _insertRowAbove(rowIndex);
      case 'delete':
        _eraseRow(rowIndex);
      case 'clear':
        _clearRow(rowIndex);
      case 'insert_free_space':
        _insertFreeDrawingSpace(rowIndex);
      case 'delete_free_space':
        _deleteFreeDrawingSpace(rowIndex);
      case 'expand_free_space':
        _expandFreeDrawingSpace(rowIndex);
      case 'insert_image_row':
        _showImageRowInsertionMessage(rowIndex);
      case 'delete_image_row':
        _deleteImageRowAtRowIndex(rowIndex);
    }
  }

  /// Shows a message directing users to use external image insertion controls.
  void _showImageRowInsertionMessage(int rowIndex) {
    const topMargin = 30.0;
    final yPosition = topMargin + (rowIndex * widget.notifier.rowLineSpacing);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'To insert an image row, use the Image Rows controls in the left panel. '
          'Set the insert position to ${yPosition.round()}px.',
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Got it',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Deletes an image row at the specified row index.
  void _deleteImageRowAtRowIndex(int rowIndex) {
    const topMargin = 30.0;
    final yPosition = topMargin + (rowIndex * widget.notifier.rowLineSpacing);

    try {
      widget.notifier.deleteImageRow(yPosition);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image row deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image row found at this position: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Inserts a new row above the specified row.
  void _insertRowAbove(int rowIndex) {
    // Calculate Y position for the row
    const topMargin = 30.0;
    final rowY = topMargin + (rowIndex * widget.notifier.rowLineSpacing);

    // Shift all content below this Y position down by one row spacing
    final currentSketch = widget.notifier.currentSketch;
    final shiftedLines = currentSketch.lines.map((line) {
      final shiftedPoints = line.points.map((point) {
        if (point.y >= rowY) {
          return point.copyWith(y: point.y + widget.notifier.rowLineSpacing);
        }
        return point;
      }).toList();
      return line.copyWith(points: shiftedPoints);
    }).toList();

    final newSketch = currentSketch.copyWith(lines: shiftedLines);
    widget.notifier.setSketch(sketch: newSketch, addToUndoHistory: true);
  }

  /// Erases/deletes the specified row.
  void _eraseRow(int rowIndex) {
    const topMargin = 30.0;
    final rowY = topMargin + (rowIndex * widget.notifier.rowLineSpacing);
    final nextRowY = rowY + widget.notifier.rowLineSpacing;

    // Remove all content in this row and shift content below up
    final currentSketch = widget.notifier.currentSketch;
    final filteredAndShiftedLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      final filteredPoints = <Point>[];

      for (final point in line.points) {
        if (point.y >= rowY && point.y < nextRowY) {
          // Skip points in the deleted row
          continue;
        } else if (point.y >= nextRowY) {
          // Shift points above the deleted row down
          filteredPoints.add(
            point.copyWith(y: point.y - widget.notifier.rowLineSpacing),
          );
        } else {
          // Keep points below the deleted row as-is
          filteredPoints.add(point);
        }
      }

      if (filteredPoints.isNotEmpty) {
        filteredAndShiftedLines.add(line.copyWith(points: filteredPoints));
      }
    }

    final newSketch = currentSketch.copyWith(lines: filteredAndShiftedLines);
    widget.notifier.setSketch(sketch: newSketch, addToUndoHistory: true);
  }

  /// Clears content in the specified row without shifting other rows.
  void _clearRow(int rowIndex) {
    const topMargin = 30.0;
    final rowY = topMargin + (rowIndex * widget.notifier.rowLineSpacing);
    final nextRowY = rowY + widget.notifier.rowLineSpacing;

    // Remove all content in this row only
    final currentSketch = widget.notifier.currentSketch;
    final filteredLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      final filteredPoints = line.points
          .where((point) => !(point.y >= rowY && point.y < nextRowY))
          .toList();

      if (filteredPoints.isNotEmpty) {
        filteredLines.add(line.copyWith(points: filteredPoints));
      }
    }

    final newSketch = currentSketch.copyWith(lines: filteredLines);
    widget.notifier.setSketch(sketch: newSketch, addToUndoHistory: true);
  }

  /// Inserts a free drawing space below the specified row.
  void _insertFreeDrawingSpace(int rowIndex) {
    const topMargin = 30.0;
    final yPosition =
        topMargin + ((rowIndex + 1) * widget.notifier.rowLineSpacing);
    widget.notifier.insertFreeDrawingSpace(yPosition);
  }

  /// Deletes a free drawing space at the specified row.
  void _deleteFreeDrawingSpace(int rowIndex) {
    const topMargin = 30.0;
    final yPosition = topMargin + (rowIndex * widget.notifier.rowLineSpacing);

    try {
      widget.notifier.deleteFreeDrawingSpace(yPosition);
    } catch (e) {
      // Show a brief message if no free drawing space found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No free drawing space found at this position'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Expands a free drawing space at the specified row.
  void _expandFreeDrawingSpace(int rowIndex) {
    const topMargin = 30.0;
    final yPosition = topMargin + (rowIndex * widget.notifier.rowLineSpacing);

    try {
      widget.notifier.expandFreeDrawingSpace(yPosition);
    } catch (e) {
      // Show a brief message if no free drawing space found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No free drawing space found at this position'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Builds line number buttons positioned over the canvas.
  List<Widget> _buildLineNumberButtons(ScribbleTheme theme) {
    const leftMargin = 20.0;
    const topMargin = 30.0;
    const bottomMargin = 30.0;

    const drawingTop = topMargin;
    final drawingBottom = _currentCanvasHeight - bottomMargin;
    final availableHeight = drawingBottom - drawingTop;

    if (drawingTop >= drawingBottom || availableHeight <= 0) return [];

    final lineSpacing = widget.notifier.rowLineSpacing;
    final maxLines = (availableHeight / lineSpacing).floor();

    final buttons = <Widget>[];

    for (var i = 0; i < maxLines; i++) {
      final currentLine = 1 + i;
      final betweenRowsY = drawingTop + (i * lineSpacing) + (lineSpacing / 2);

      if (betweenRowsY > drawingBottom) break;

      // Check if this position is within a free drawing space or image row
      final currentRowY = drawingTop + (i * lineSpacing);
      final freeSpace = widget.notifier.getFreeDrawingSpaceAt(currentRowY);
      final imageRow = widget.notifier.getImageRowAt(currentRowY);

      // For image rows, only show icon at the beginning of the image row
      if (imageRow != null) {
        final imageRowStartRowIndex =
            ((imageRow.startY - drawingTop) / lineSpacing).round();
        if (i != imageRowStartRowIndex) continue;
      }

      // If in free space, only show line number at the beginning of the space
      if (freeSpace != null) {
        // Skip if not at the start of the free drawing space
        final spaceStartRowIndex =
            ((freeSpace.startY - drawingTop) / lineSpacing).round();
        if (i != spaceStartRowIndex) continue;
      }

      // Get opacity based on content progress (but always show image rows)
      final opacity = imageRow != null ? 1.0 : widget.notifier.getLineNumberOpacity(i);

      // Skip if too transparent (but not for image rows)
      if (opacity < 0.01) continue;

      // Position the button (centered in left margin)
      const buttonX = leftMargin - 6; // Center horizontally in margin
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
              offset: const Offset(32, 0),
              itemBuilder: (context) {
                // Check if current position is in a free drawing space or image row
                const topMargin = 30.0;
                final currentY =
                    topMargin + (i * widget.notifier.rowLineSpacing);
                final isInFreeSpace =
                    widget.notifier.isInFreeDrawingSpace(currentY);
                final isInImageRow =
                    widget.notifier.isInImageRow(currentY);

                return [
                  const PopupMenuItem(
                    value: 'insert',
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 8),
                        Text('Insert Row Above'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'insert_free_space',
                    child: Row(
                      children: [
                        Icon(Icons.space_bar, size: 16),
                        SizedBox(width: 8),
                        Text('Add Free Drawing Space'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'insert_image_row',
                    child: Row(
                      children: [
                        Icon(Icons.image, size: 16),
                        SizedBox(width: 8),
                        Text('Insert Image Row'),
                      ],
                    ),
                  ),
                  if (isInImageRow) ...[
                    const PopupMenuItem(
                      value: 'delete_image_row',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 16),
                          SizedBox(width: 8),
                          Text('Delete Image Row'),
                        ],
                      ),
                    ),
                  ] else if (isInFreeSpace) ...[
                    const PopupMenuItem(
                      value: 'expand_free_space',
                      child: Row(
                        children: [
                          Icon(Icons.expand, size: 16),
                          SizedBox(width: 8),
                          Text('Expand Free Space'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete_free_space',
                      child: Row(
                        children: [
                          Icon(Icons.compress, size: 16),
                          SizedBox(width: 8),
                          Text('Delete Free Space'),
                        ],
                      ),
                    ),
                  ] else ...[
                    const PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.clear, size: 16),
                          SizedBox(width: 8),
                          Text('Clear Row'),
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
                ];
              },
              onSelected: (value) => _handleRowAction(value, i),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.lineNumberColor.withValues(alpha: 0.5),
                  ),
                  color: Colors.transparent,
                ),
                child: Center(
                  child: imageRow != null
                      ? Icon(
                          Icons.image,
                          size: widget.lineNumberFontSize + 2,
                          color: theme.lineNumberColor,
                        )
                      : freeSpace != null
                          ? Icon(
                              Icons.space_bar,
                              size: widget.lineNumberFontSize + 2,
                              color: theme.lineNumberColor,
                            )
                          : Text(
                              currentLine.toString(),
                              style: TextStyle(
                                fontSize: widget.lineNumberFontSize - 1,
                                fontWeight: FontWeight.w500,
                                color: theme.lineNumberColor,
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

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme(context);

    return ScribbleThemeProvider(
      theme: theme,
      child: ValueListenableBuilder<ScribbleState>(
        valueListenable: widget.notifier,
        builder: (context, state, _) {
          return Container(
            color: theme.paperShadowColor.withValues(alpha: 0.1),
            child: ClipRect(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                panEnabled: !_isPenActive,
                scaleEnabled: !_isPenActive,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    width: widget.canvasWidth,
                    height: _currentCanvasHeight,
                    margin: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.paperColor,
                      border: widget.showPaperBorder
                          ? Border.all(
                              color: theme.paperBorderColor,
                              width: widget.paperBorderWidth,
                            )
                          : null,
                      boxShadow: widget.showPaperShadow
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // Row lines painter
                        CustomPaint(
                          painter: DynamicRowLinePainter(
                            paperWidth: widget.canvasWidth,
                            paperHeight: _currentCanvasHeight,
                            lineSpacing: widget.notifier.rowLineSpacing,
                            lineColor: theme.rowLineColor,
                            lineWidth: widget.rowLineWidth,
                            sketch: state.sketch,
                            leftMargin: 60.0,
                            rightMargin: 20.0,
                            topMargin: 30.0,
                            bottomMargin: 30.0,
                            proximityRadius: 40,
                            fadeDistance: 80,
                            regions: const [],
                            freeDrawingSpaces:
                                widget.notifier.freeDrawingSpaces,
                            imageRows: widget.notifier.imageRows,
                          ),
                        ),

                        // Image rows painter
                        CustomPaint(
                          painter: ImageRowPainter(
                            imageRows: widget.notifier.imageRows,
                            canvasWidth: widget.canvasWidth,
                            leftMargin: 60.0,
                            rightMargin: 20.0,
                            borderColor: theme.rowLineColor.withOpacity(0.5),
                            borderWidth: 1.0,
                            showBorders: true,
                          ),
                        ),

                        // Main drawing canvas
                        RepaintBoundary(
                          key: widget.notifier.repaintBoundaryKey,
                          child: Listener(
                            onPointerDown: (event) {
                              if (event.kind == PointerDeviceKind.stylus ||
                                  event.kind ==
                                      PointerDeviceKind.invertedStylus) {
                                setState(() => _isPenActive = true);
                              }
                              widget.notifier.onPointerDown(event);
                            },
                            onPointerMove: widget.notifier.onPointerUpdate,
                            onPointerUp: (event) {
                              widget.notifier.onPointerUp(event);
                              if (event.kind == PointerDeviceKind.stylus ||
                                  event.kind ==
                                      PointerDeviceKind.invertedStylus) {
                                setState(() => _isPenActive = false);
                              }
                            },
                            child: CustomPaint(
                              size: Size(
                                  widget.canvasWidth, _currentCanvasHeight),
                              painter: ScribblePainter(
                                sketch: state.sketch,
                                scaleFactor: 1.0,
                                simulatePressure: widget.simulatePressure,
                                theme: theme,
                              ),
                              foregroundPainter: state.active
                                  ? ScribbleEditingPainter(
                                      state: state,
                                      drawPointer: widget.drawPen,
                                      drawEraser: widget.drawEraser,
                                      simulatePressure: widget.simulatePressure,
                                      theme: theme,
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        // Line number buttons
                        ..._buildLineNumberButtons(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
