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

    /// Background color behind the paper canvas.
    this.backgroundColor,

    /// Whether to show the right side button on each row.
    this.showRightSideButton = false,

    /// Custom builder for the popup widget shown when right side button is tapped.
    /// Receives the build context and row index.
    this.rightSidePopupBuilder,

    /// Icon to display on the right side button.
    this.rightSideButtonIcon = Icons.more_vert,
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

  /// Background color behind the paper canvas.
  final Color? backgroundColor;

  /// Whether to show the right side button on each row.
  final bool showRightSideButton;

  /// Custom builder for the popup widget shown when right side button is tapped.
  final Widget Function(BuildContext context, int rowIndex)?
      rightSidePopupBuilder;

  /// Icon to display on the right side button.
  final IconData rightSideButtonIcon;

  @override
  State<LineByLineCanvas> createState() => _LineByLineCanvasState();
}

class _LineByLineCanvasState extends State<LineByLineCanvas> {
  final ScrollController _scrollController = ScrollController();
  final TransformationController _transformationController =
      TransformationController();
  double _currentCanvasHeight = 400;
  bool _isDrawingWithPen = true;

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
    }
  }


  /// Inserts a new row above the specified row.
  void _insertRowAbove(int rowIndex) {
    final row = widget.notifier.getRowByRendererIndex(rowIndex);
    if (row == null) return;

    final rowY = row.startY;

    // Process all strokes, splitting those that cross the insertion boundary
    final currentSketch = widget.notifier.currentSketch;
    final processedLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      // Check if line crosses the insertion boundary
      final hasPointsAbove = line.points.any((p) => p.y < rowY);
      final hasPointsBelow = line.points.any((p) => p.y >= rowY);

      if (!hasPointsAbove && !hasPointsBelow) {
        // Empty line, skip it
        continue;
      } else if (hasPointsAbove && !hasPointsBelow) {
        // Line is entirely above the insertion point, keep as-is
        processedLines.add(line);
      } else if (!hasPointsAbove && hasPointsBelow) {
        // Line is entirely below the insertion point, shift all points
        final shiftedPoints = line.points
            .map((p) => p.copyWith(y: p.y + widget.notifier.rowLineSpacing))
            .toList();
        processedLines.add(line.copyWith(points: shiftedPoints));
      } else {
        // Line crosses the boundary, split it into two strokes
        final pointsAbove = <Point>[];
        final pointsBelow = <Point>[];

        for (final point in line.points) {
          if (point.y < rowY) {
            pointsAbove.add(point);
          } else {
            // Shift points at or below the boundary
            pointsBelow.add(
              point.copyWith(y: point.y + widget.notifier.rowLineSpacing),
            );
          }
        }

        // Create two separate strokes
        if (pointsAbove.isNotEmpty) {
          processedLines.add(line.copyWith(points: pointsAbove));
        }
        if (pointsBelow.isNotEmpty) {
          processedLines.add(line.copyWith(points: pointsBelow));
        }
      }
    }

    final newSketch = currentSketch.copyWith(lines: processedLines);
    widget.notifier.setSketch(sketch: newSketch);
  }

  /// Erases/deletes the specified row.
  void _eraseRow(int rowIndex) {
    final row = widget.notifier.getRowByRendererIndex(rowIndex);
    if (row == null) return;

    final rowY = row.startY;
    final nextRowY = row.endY;

    // Process all strokes, splitting those that cross row boundaries
    final currentSketch = widget.notifier.currentSketch;
    final processedLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      // Check where the line's points are relative to the row boundaries
      final pointsBefore = <Point>[];
      final pointsInRow = <Point>[];
      final pointsAfter = <Point>[];

      for (final point in line.points) {
        if (point.y < rowY) {
          // Point is before the deleted row
          pointsBefore.add(point);
        } else if (point.y >= rowY && point.y < nextRowY) {
          // Point is in the deleted row
          pointsInRow.add(point);
        } else {
          // Point is after the deleted row, shift it up
          pointsAfter.add(
            point.copyWith(y: point.y - widget.notifier.rowLineSpacing),
          );
        }
      }

      // Create separate strokes for portions before and after the deleted row
      // Skip the portion within the deleted row
      if (pointsBefore.isNotEmpty) {
        processedLines.add(line.copyWith(points: pointsBefore));
      }
      if (pointsAfter.isNotEmpty) {
        processedLines.add(line.copyWith(points: pointsAfter));
      }
    }

    final newSketch = currentSketch.copyWith(lines: processedLines);
    widget.notifier.setSketch(sketch: newSketch);
  }

  /// Clears content in the specified row without shifting other rows.
  void _clearRow(int rowIndex) {
    final row = widget.notifier.getRowByRendererIndex(rowIndex);
    if (row == null) return;

    final rowY = row.startY;
    final nextRowY = row.endY;

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
    widget.notifier.setSketch(sketch: newSketch);
  }

  /// Inserts a free drawing space below the specified row.
  void _insertFreeDrawingSpace(int rowIndex) {
    final row = widget.notifier.getRowByRendererIndex(rowIndex);
    if (row == null) return;

    final yPosition = row.endY;
    widget.notifier.insertFreeDrawingSpace(yPosition);
  }

  /// Deletes a free drawing space at the specified row.
  void _deleteFreeDrawingSpace(int rowIndex) {
    final row = widget.notifier.getRowByRendererIndex(rowIndex);
    if (row == null) return;

    final yPosition = row.startY;

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
    final row = widget.notifier.getRowByRendererIndex(rowIndex);
    if (row == null) return;

    final yPosition = row.startY;

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

  /// Shows the custom popup widget for the right side button.
  void _showRightSidePopup(
      BuildContext context, int rowIndex, Offset buttonPosition) {
    if (widget.rightSidePopupBuilder == null) return;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;

    // Calculate popup position (to the left of the button)
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        buttonPosition,
        buttonPosition.translate(0, 0),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<void>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<void>(
          enabled: false,
          child: widget.rightSidePopupBuilder!(context, rowIndex),
        ),
      ],
      elevation: 8,
    );
  }

  /// Builds floating widgets on the right side of each row.
  List<Widget> _buildRightSideButtons(ScribbleTheme theme) {
    if (!widget.showRightSideButton) return [];

    final buttons = <Widget>[];
    final rows = widget.notifier.rows;
    const rightMargin = 20.0;
    final canvasWidth = widget.canvasWidth;

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final betweenRowsY = row.startY + (row.height / 2);

      // Check if this position is within a free drawing space or image row
      final currentRowY = row.startY;
      final rowCenterY = row.startY + (row.height / 2);
      final freeSpace = widget.notifier.getFreeDrawingSpaceAt(currentRowY);

      var imageRow = widget.notifier.getImageRowAt(currentRowY);
      imageRow ??= widget.notifier.getImageRowAt(rowCenterY);
      imageRow ??= widget.notifier.getImageRowAt(row.startY + row.height);

      // Skip rows that are completely within image rows or free spaces
      if (imageRow != null) {
        final imageRowStartRowIndex =
            widget.notifier.getRowIndexForY(imageRow.startY);
        if (i != imageRowStartRowIndex) continue;
      } else if (freeSpace != null) {
        final spaceStartRowIndex =
            widget.notifier.getRowIndexForY(freeSpace.startY);
        if (i != spaceStartRowIndex) continue;
      }

      final normalIndex = row.normalIndex;

      // Get opacity based on content progress
      final opacity = freeSpace != null
          ? 1.0
          : imageRow != null
              ? 1.0
              : normalIndex != null
                  ? widget.notifier.getLineNumberOpacity(normalIndex)
                  : 0.0;

      if (opacity < 0.01 && imageRow == null && freeSpace == null) continue;

      // Position the button on the right side
      final buttonX = canvasWidth - rightMargin - 26;
      final buttonY = betweenRowsY - 16;

      buttons.add(
        Positioned(
          left: buttonX,
          top: buttonY,
          width: 32,
          height: 32,
          child: Opacity(
            opacity: opacity,
            child: Builder(
              builder: (buttonContext) {
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.lineNumberColor.withValues(alpha: 0.5),
                    ),
                    color: Colors.transparent,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 16,
                    icon: Icon(
                      widget.rightSideButtonIcon,
                      color: theme.lineNumberColor,
                    ),
                    onPressed: () {
                      final button = buttonContext.findRenderObject()!;
                      final buttonPosition =
                          (button as RenderBox).localToGlobal(Offset.zero);
                      _showRightSidePopup(context, i, buttonPosition);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  /// Builds line number buttons positioned over the canvas.
  List<Widget> _buildLineNumberButtons(ScribbleTheme theme) {
    const leftMargin = 20.0;
    final buttons = <Widget>[];
    final rows = widget.notifier.rows;

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final betweenRowsY = row.startY + (row.height / 2);

      // Check if this position is within a free drawing space or image row
      final currentRowY = row.startY;
      final rowCenterY = row.startY + (row.height / 2);
      final freeSpace = widget.notifier.getFreeDrawingSpaceAt(currentRowY);

      // Try multiple positions to detect image rows that might not align
      // perfectly
      var imageRow = widget.notifier.getImageRowAt(currentRowY);
      imageRow ??= widget.notifier.getImageRowAt(rowCenterY);
      imageRow ??= widget.notifier.getImageRowAt(row.startY + row.height);

      // Skip rows that are completely within image rows or free spaces,
      // except show one button per image row or free space region
      if (imageRow != null) {
        final imageRowStartRowIndex =
            widget.notifier.getRowIndexForY(imageRow.startY);
        if (i != imageRowStartRowIndex) continue;
      } else if (freeSpace != null) {
        final spaceStartRowIndex =
            widget.notifier.getRowIndexForY(freeSpace.startY);
        if (i != spaceStartRowIndex) continue;
      }

      // Use the normal index for text rows, null for image/free space rows
      final normalIndex = row.normalIndex;

      // Get opacity based on content progress (fully visible for free spaces)
      final opacity = freeSpace != null
          ? 1.0 // Fully visible for free spaces
          : imageRow != null
              ? 1.0
              : normalIndex != null
                  ? widget.notifier.getLineNumberOpacity(normalIndex)
                  : 0.0;

      // Skip if too transparent (but not for image rows or free spaces)
      if (opacity < 0.01 && imageRow == null && freeSpace == null) continue;

      // Get the current line number for display (use normal index directly)
      final currentLine =
          normalIndex; // This is already 1-based or null for non-text rows
      
      // Check if this line is highlighted
      final isHighlighted = currentLine != null && 
          widget.notifier.isRowHighlighted(currentLine);
      
      // Get colors based on highlight state
      final rowHighlightColor = currentLine != null 
          ? widget.notifier.getRowHighlightColor(currentLine)
          : null;
      final highlightColor = rowHighlightColor ?? theme.rowHighlightColor;
      final textColor = isHighlighted ? Colors.black : theme.lineNumberColor;
      final borderColor = isHighlighted 
          ? highlightColor.withValues(alpha: 0.8)
          : theme.lineNumberColor.withValues(alpha: 0.5);
      final backgroundColor = isHighlighted 
          ? highlightColor
          : Colors.transparent;

      // Position the button (left side for all controls)
      const buttonX = leftMargin - 6; // Left side position for all controls
      final buttonY = betweenRowsY - 16; // Center button vertically

      buttons.add(
        Positioned(
          left: buttonX,
          top: buttonY,
          width: 32,
          height: 32,
          child: Opacity(
            opacity: opacity,
            child: imageRow != null
                ? // Image rows: just show icon, no popup menu
                Container(
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
                      child: Icon(
                        Icons.image,
                        size: widget.lineNumberFontSize + 2,
                        color: theme.lineNumberColor,
                      ),
                    ),
                  )
                : // Text rows and free spaces: show popup menu
                PopupMenuButton<String>(
                    offset: const Offset(32, 0),
                    itemBuilder: (context) {
                      // Check if current position is in a free drawing space
                      final currentY = row.startY;
                      final isInFreeSpace =
                          widget.notifier.isInFreeDrawingSpace(currentY);

                      return [
                        const PopupMenuItem(
                          value: 'insert',
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 16),
                              SizedBox(width: 8),
                              Text('上に行を挿入'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'insert_free_space',
                          child: Row(
                            children: [
                              Icon(Icons.space_bar, size: 16),
                              SizedBox(width: 8),
                              Text('フリー描画スペースを追加'),
                            ],
                          ),
                        ),
                        if (isInFreeSpace) ...[
                          const PopupMenuItem(
                            value: 'expand_free_space',
                            child: Row(
                              children: [
                                Icon(Icons.expand, size: 16),
                                SizedBox(width: 8),
                                Text('スペースを拡張'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete_free_space',
                            child: Row(
                              children: [
                                Icon(Icons.compress, size: 16),
                                SizedBox(width: 8),
                                Text('スペースを削除'),
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
                                Text('行をクリア'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 16),
                                SizedBox(width: 8),
                                Text('行を削除'),
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
                          color: borderColor,
                        ),
                        color: backgroundColor,
                      ),
                      child: Center(
                        child: freeSpace != null
                            ? Icon(
                                Icons.space_bar,
                                size: widget.lineNumberFontSize + 2,
                                color: textColor,
                              )
                            : Text(
                                currentLine?.toString() ?? '',
                                style: TextStyle(
                                  fontSize: widget.lineNumberFontSize - 1,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
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
          return ColoredBox(
            color: widget.backgroundColor ?? theme.paperShadowColor.withValues(alpha: 0.1),
            child: ClipRect(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 3,
                constrained: false,
                // Keep pan/scale enabled but gestures are absorbed by parent GestureDetector
                panEnabled: !_isDrawingWithPen,
                scaleEnabled: !_isDrawingWithPen,
                boundaryMargin: const EdgeInsets.all(double.infinity),
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
                  child: RepaintBoundary(
                    key: widget.notifier.repaintBoundaryKey,
                    child: Listener(
                      onPointerDown: (event) {
                        if (event.kind == PointerDeviceKind.stylus ||
                            event.kind == PointerDeviceKind.invertedStylus) {
                          setState(() {
                            _isDrawingWithPen = true;
                          });
                          widget.notifier.onPointerDown(event);
                        } else if (event.kind == PointerDeviceKind.touch) {
                          setState(() {
                            _isDrawingWithPen = false;
                          });
                        }
                      },
                      onPointerMove: (event) {
                        if (event.kind == PointerDeviceKind.stylus ||
                            event.kind == PointerDeviceKind.invertedStylus) {
                          if (!_isDrawingWithPen) {
                            setState(() {
                              _isDrawingWithPen = true;
                            });
                          }
                          widget.notifier.onPointerUpdate(event);
                        }
                      },
                      onPointerUp: (event) {
                        if (event.kind == PointerDeviceKind.stylus ||
                            event.kind == PointerDeviceKind.invertedStylus) {
                          widget.notifier.onPointerUp(event);
                        }
                      },
                      onPointerCancel: (event) {
                        if (event.kind == PointerDeviceKind.stylus ||
                            event.kind == PointerDeviceKind.invertedStylus) {
                          widget.notifier.onPointerCancel(event);
                        }
                      },
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
                              rows: widget.notifier.rows,
                              leftMargin: 60,
                              rightMargin: 20,
                              topMargin: 30,
                              bottomMargin: 30,
                              proximityRadius: 40,
                              fadeDistance: 80,
                              freeDrawingSpaces:
                                  widget.notifier.freeDrawingSpaces,
                              imageRows: widget.notifier.imageRows,
                            ),
                          ),

                          // Image rows painter
                          CustomPaint(
                            painter: widget.notifier.loadedImages.isNotEmpty
                                ? AsyncImageRowPainter(
                                    imageRows: widget.notifier.imageRows,
                                    canvasWidth: widget.canvasWidth,
                                    loadedImages: widget.notifier.loadedImages,
                                    leftMargin: 60,
                                    rightMargin: 20,
                                    borderColor: theme.rowLineColor
                                        .withValues(alpha: 0.5),
                                  )
                                : ImageRowPainter(
                                    imageRows: widget.notifier.imageRows,
                                    canvasWidth: widget.canvasWidth,
                                    leftMargin: 60,
                                    rightMargin: 20,
                                    borderColor: theme.rowLineColor
                                        .withValues(alpha: 0.5),
                                  ),
                          ),

                          // Main drawing canvas
                          CustomPaint(
                            size: Size(
                              widget.canvasWidth,
                              _currentCanvasHeight,
                            ),
                            painter: ScribblePainter(
                              sketch: state.sketch,
                              scaleFactor: 1,
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

                          // Line number buttons
                          ..._buildLineNumberButtons(theme),

                          // Right side buttons
                          ..._buildRightSideButtons(theme),
                        ],
                      ),
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
