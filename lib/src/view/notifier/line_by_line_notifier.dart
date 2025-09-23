import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/row/row.dart';
import 'package:scribble/src/domain/model/row_change/row_change.dart';
import 'package:scribble/src/view/painting/reusable_painter_export.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';
import 'package:scribble/src/view/simplification/sketch_simplifier.dart';

/// A notifier that extends ScribbleNotifier with line-by-line writing
/// capabilities and dynamic canvas extension.
class LineByLineNotifier extends ScribbleNotifier {
  /// Creates a new line-by-line notifier.
  LineByLineNotifier({
    /// Which pointers can be drawn with and are captured.
    super.allowedPointersMode = ScribblePointerMode.all,

    /// How many states you want stored in the undo history, 30 by default.
    super.maxHistoryLength = 30,

    /// The supported widths for drawing.
    super.widths = const [5, 10, 15],

    /// The supported eraser widths.
    super.eraserWidths = const [10, 15, 20],

    /// The curve used to map pen pressure.
    super.pressureCurve = Curves.linear,

    /// The sketch simplifier used to simplify lines.
    super.simplifier = const VisvalingamSimplifier(),

    /// The simplification tolerance for sketch lines.
    super.simplificationTolerance = 0,

    /// Row line spacing for line-by-line writing.
    double rowLineSpacing = 24.0,

    /// Top margin for the canvas.
    double topMargin = 30.0,

    /// Bottom margin buffer for the canvas.
    double bottomMargin = 60.0,

    /// Initial canvas height.
    double initialCanvasHeight = 400.0,
  })  : _rowLineSpacing = rowLineSpacing,
        _topMargin = topMargin,
        _bottomMargin = bottomMargin,
        _canvasHeight = initialCanvasHeight,
        _freeDrawingSpaces = [],
        _imageRows = [] {
    // Store initial canvas height as minimum
    _initialCanvasHeight = initialCanvasHeight;
    
    // Initialize rows based on initial canvas height
    _initializeRows();
  }

  /// Row line spacing for line-by-line writing.
  double _rowLineSpacing;
  double get rowLineSpacing => _rowLineSpacing;

  /// Top margin for the canvas.
  final double _topMargin;
  double get topMargin => _topMargin;

  /// Bottom margin buffer for the canvas.
  final double _bottomMargin;
  double get bottomMargin => _bottomMargin;

  /// Current canvas height.
  double _canvasHeight;
  double get canvasHeight => _canvasHeight;

  /// Initial canvas height to use as minimum.
  late final double _initialCanvasHeight;

  /// Whether sequential writing mode is enabled.
  bool _sequentialMode = false;
  bool get sequentialMode => _sequentialMode;

  /// Callback to notify canvas height changes.
  void Function(double newHeight)? _onCanvasHeightChanged;

  /// Canvas width for bounds checking.
  double _canvasWidth = 600;

  /// List of rows with fixed positions.
  final List<NotebookRow> _rows = [];

  /// List of free drawing spaces (line-free regions).
  final List<FreeDrawingSpace> _freeDrawingSpaces;

  /// List of image rows.
  final List<ImageRow> _imageRows;

  /// Map of loaded ui.Image objects keyed by image row ID.
  final Map<String, ui.Image> _loadedImages = <String, ui.Image>{};

  /// Map of highlighted normal indices to their specific colors.
  /// Key: user-visible line number (1, 2, 3, etc.)
  /// Value: color to use for highlighting that specific row
  final Map<int, Color> _highlightedRows = <int, Color>{};


  /// Gets an immutable list of rows.
  List<NotebookRow> get rows => List.unmodifiable(_rows);

  /// Gets an immutable list of free drawing spaces.
  List<FreeDrawingSpace> get freeDrawingSpaces =>
      List.unmodifiable(_freeDrawingSpaces);

  /// Gets an immutable list of image rows.
  List<ImageRow> get imageRows => List.unmodifiable(_imageRows);

  /// Gets an immutable map of loaded images.
  Map<String, ui.Image> get loadedImages => Map.unmodifiable(_loadedImages);

  /// Gets an immutable set of highlighted row indices.
  Set<int> get highlightedRows => Set.unmodifiable(_highlightedRows.keys);


  /// Sets the callback for canvas height changes.
  void setCanvasHeightChangeCallback(
      void Function(double newHeight)? callback,) {
    _onCanvasHeightChanged = callback;
  }

  /// Sets the row line spacing.
  void setRowLineSpacing(double spacing) {
    _rowLineSpacing = spacing;
    _checkAndResizeCanvas();
  }

  /// Sets the sequential writing mode.
  void setSequentialMode(bool enabled) {
    _sequentialMode = enabled;
  }


  @override
  void clear() {
    super.clear();
    // After clearing, check if canvas needs to be resized (likely shrunk)
    _checkAndResizeCanvas();
  }

  /// Sets the canvas height and notifies listeners.
  void setCanvasHeight(double height) {
    if (_canvasHeight != height) {
      _canvasHeight = height;
      _initializeRows(); // Reinitialize rows with new height
      _onCanvasHeightChanged?.call(height);
    }
  }

  /// Sets the canvas width for bounds checking.
  void setCanvasWidth(double width) {
    _canvasWidth = width;
  }

  /// Initializes the rows based on current canvas height and spacing.
  void _initializeRows() {
    _rows.clear();
    
    final drawingHeight = _canvasHeight - _topMargin - _bottomMargin;
    final numberOfRows = (drawingHeight / _rowLineSpacing).floor();
    
    _createRowsWithIndices(numberOfRows);
  }

  /// Creates rows with properly calculated dual indices.
  void _createRowsWithIndices(int numberOfRows) {
    var normalIndex = 1; // User-visible line numbers start at 1
    
    for (var rendererIndex = 0; rendererIndex < numberOfRows; rendererIndex++) {
      final rowY = _topMargin + (rendererIndex * _rowLineSpacing);
      
      // Check if this row position overlaps with an image row
      final overlapsImageRow = _imageRows.any((imageRow) => 
          imageRow.containsY(rowY) || imageRow.containsY(rowY + _rowLineSpacing),);
      
      // Check if this row position overlaps with a free drawing space
      final overlapsFreespace = _freeDrawingSpaces.any(
        (space) => space.containsY(rowY),
      );
      
      // Only assign normal index if this is a text row (not image/free space)
      final assignedNormalIndex = (!overlapsImageRow && !overlapsFreespace) 
          ? normalIndex++ 
          : null;
      
      _rows.add(NotebookRow(
        startY: rowY,
        rendererIndex: rendererIndex,
        normalIndex: assignedNormalIndex,
        height: _rowLineSpacing,
        id: 'row_$rendererIndex',
      ),);
    }
  }

  /// Recalculates normal indices for all existing rows.
  /// This should be called after image row or free space operations.
  void _recalculateNormalIndices() {
    var normalIndex = 1;
    
    for (var rendererIndex = 0; rendererIndex < _rows.length; rendererIndex++) {
      final row = _rows[rendererIndex];
      final rowY = row.startY;
      
      // Check if this row position overlaps with an image row or free space
      final overlapsImageRow = _imageRows.any((imageRow) => 
          imageRow.containsY(rowY) || imageRow.containsY(rowY + row.height),);
      final overlapsFreespace = _freeDrawingSpaces.any(
        (space) => space.containsY(rowY),
      );
      
      // Update the row with the correct normal index
      final assignedNormalIndex = (!overlapsImageRow && !overlapsFreespace) 
          ? normalIndex++ 
          : null;
      
      _rows[rendererIndex] = row.withNormalIndex(assignedNormalIndex);
    }
  }

  /// Recalculates the indices for all image rows after modifications.
  /// This should be called after image row operations that affect order.
  void _recalculateImageRowIndices() {
    // Sort image rows by startY position first
    _imageRows.sort((a, b) => a.startY.compareTo(b.startY));
    
    // Update each image row with correct indices
    for (var i = 0; i < _imageRows.length; i++) {
      _imageRows[i] = _imageRows[i].withIndices(
        rendererIndex: i, // 0-based physical position
        visualIndex: i + 1, // 1-based visual position
      );
    }
  }

  /// Gets a row by its renderer index (physical array position).
  /// This method should be used for canvas operations and image row positioning.
  NotebookRow? getRowByRendererIndex(int rendererIndex) {
    if (rendererIndex < 0 || rendererIndex >= _rows.length) return null;
    return _rows[rendererIndex];
  }

  /// Gets a row by its normal index (user-visible line number).
  /// This method should be used for user-facing operations like highlighting.
  NotebookRow? getRowByNormalIndex(int normalIndex) {
    if (normalIndex < 1) return null;
    return _rows.cast<NotebookRow?>().firstWhere(
      (row) => row?.normalIndex == normalIndex,
      orElse: () => null,
    );
  }

  /// Gets a row by its index, returns null if not found.
  /// @deprecated Use getRowByRendererIndex or getRowByNormalIndex instead.
  @Deprecated('Use getRowByRendererIndex or getRowByNormalIndex instead')
  NotebookRow? getRowByIndex(int index) {
    return getRowByRendererIndex(index);
  }

  /// Gets the row that contains the specified Y position, returns null if not found.
  NotebookRow? getRowAt(double y) {
    return _rows.cast<NotebookRow?>().firstWhere(
      (row) => row?.containsY(y) ?? false,
      orElse: () => null,
    );
  }

  /// Gets the row index for a given Y coordinate.
  int getRowIndexForY(double y) {
    if (y < _topMargin) return -1;
    return ((y - _topMargin) / _rowLineSpacing).floor();
  }

  /// Gets the maximum Y coordinate of all drawn content.
  double _getMaxContentY() {
    var maxY = _topMargin;
    
    // Check sketch lines
    if (value.sketch.lines.isNotEmpty) {
      for (final line in value.sketch.lines) {
        for (final point in line.points) {
          if (point.y > maxY) {
            maxY = point.y;
          }
        }
      }
    }
    
    // Check image rows
    for (final imageRow in _imageRows) {
      if (imageRow.endY > maxY) {
        maxY = imageRow.endY;
      }
    }
    
    // Check free drawing spaces
    for (final space in _freeDrawingSpaces) {
      if (space.endY > maxY) {
        maxY = space.endY;
      }
    }
    
    return maxY;
  }

  /// Calculates the required number of rows based on content.
  int _getRequiredRows() {
    final maxContentY = _getMaxContentY();
    final contentProgress = (maxContentY - _topMargin) / _rowLineSpacing;

    // Add 2 extra rows as buffer
    return contentProgress.ceil() + 2;
  }

  /// Checks if canvas needs to be resized and resizes it if necessary.
  void _checkAndResizeCanvas() {
    final requiredRows = _getRequiredRows();
    final requiredHeight =
        _topMargin + (requiredRows * _rowLineSpacing) + _bottomMargin;

    // Calculate minimum height (initial height or based on minimum content)
    final minimumHeight = _initialCanvasHeight;
    final targetHeight = requiredHeight < minimumHeight 
        ? minimumHeight 
        : requiredHeight;

    // Resize if the target height is different from current height
    // Add some tolerance to prevent frequent small changes
    const resizeTolerance = 5.0; // pixels
    if ((targetHeight - _canvasHeight).abs() > resizeTolerance) {
      setCanvasHeight(targetHeight);
    }
  }

  /// Validates if drawing is allowed at the given position (for sequential mode).
  bool _isDrawingAllowedAtPosition(Offset position) {
    if (!_sequentialMode) return true;

    final maxContentY = _getMaxContentY();
    final currentRowIndex = getRowIndexForY(position.dy);
    final maxRowIndex = getRowIndexForY(maxContentY);

    // Allow drawing on current row or next row only
    return currentRowIndex <= maxRowIndex + 1;
  }

  /// Validates if the position is within canvas bounds.
  bool _isPositionWithinCanvasBounds(Offset position, Size canvasSize) {
    return position.dx >= 0 &&
           position.dx <= canvasSize.width &&
           position.dy >= 0 &&
           position.dy <= canvasSize.height;
  }

  @override
  void onPointerDown(PointerDownEvent event) {
    final position = event.localPosition;
    final canvasSize = Size(_canvasWidth, _canvasHeight);

    // Check if position is within canvas bounds
    if (!_isPositionWithinCanvasBounds(position, canvasSize)) {
      return; // Block drawing outside canvas bounds
    }

    // Check if drawing is allowed at this position (for sequential mode)
    if (!_isDrawingAllowedAtPosition(position)) {
      return; // Block drawing outside allowed area
    }

    super.onPointerDown(event);
    _checkAndResizeCanvas();
  }

  @override
  void onPointerUpdate(PointerMoveEvent event) {
    final position = event.localPosition;
    final canvasSize = Size(_canvasWidth, _canvasHeight);

    // Check if position is within canvas bounds
    if (!_isPositionWithinCanvasBounds(position, canvasSize)) {
      return; // Block drawing outside canvas bounds
    }

    // Check if drawing is allowed at this position (for sequential mode)
    if (!_isDrawingAllowedAtPosition(position)) {
      return; // Block drawing outside allowed area
    }

    super.onPointerUpdate(event);
    // Don't resize canvas during pointer move to prevent jittering
    // Canvas will be resized on pointer up
  }

  @override
  void onPointerUp(PointerUpEvent event) {
    super.onPointerUp(event);
    _checkAndResizeCanvas();
  }

  /// Gets the progress-based opacity for a normal index (user-visible line number).
  /// 
  /// [normalIndex] should be a 1-based line number (1, 2, 3...).
  /// Normal index 1 will always have opacity 1.0.
  double getLineNumberOpacity(int normalIndex) {
    // Always show the first two line numbers at full opacity
    // Normal index 1 (first visible line) must always be visible
    if (normalIndex == 1 || normalIndex == 2) {
      return 1;
    }

    final maxContentY = _getMaxContentY();
    if (maxContentY <= _topMargin) {
      // No content yet, only show first two lines
      return 0;
    }

    // Calculate which visible line number the content has reached
    final contentRowIndex = getRowIndexForY(maxContentY);
    final contentVisibleLineNumber = _getVisibleLineNumberForRowIndex(contentRowIndex);

    // Show line numbers progressively: if content reached visible line N, show numbers 1 through N+2
    if (normalIndex <= contentVisibleLineNumber + 2) {
      return 1;
    } else {
      return 0;
    }
  }

  /// Converts a raw row index to a visible line number (0-based).
  /// Returns -1 if the row index corresponds to an image row or invalid position.
  int _getVisibleLineNumberForRowIndex(int rowIndex) {
    if (rowIndex < 0) return -1;
    
    // Count how many visible text lines come before this row index
    var visibleLineCount = 0;
    
    for (var i = 0; i <= rowIndex; i++) {
      final rowY = _topMargin + (i * _rowLineSpacing);
      
      // Skip this row if it's within an image row
      if (isInImageRow(rowY)) {
        continue;
      }
      
      // This is a visible text line
      if (i == rowIndex) {
        // If the target row itself is a text line, return its line number
        return visibleLineCount;
      }
      
      visibleLineCount++;
    }
    
    // If we get here, the target row index was within an image row
    return -1;
  }

  /// Gets the number of visible rows based on current content.
  int getVisibleRowCount() {
    final requiredRows = _getRequiredRows();
    return requiredRows;
  }

  /// Checks if a Y position is within the allowed drawing area.
  bool isPositionInDrawingArea(double y) {
    if (!_sequentialMode) return true;

    final maxContentY = _getMaxContentY();
    final maxRowIndex = getRowIndexForY(maxContentY);
    final maxRow = getRowByRendererIndex(maxRowIndex);
    
    if (maxRow == null) return y >= _topMargin;
    
    // Allow drawing within current content area plus one extra row
    final allowedMaxY = maxRow.endY + _rowLineSpacing;

    return y >= _topMargin && y <= allowedMaxY;
  }

  // Free Drawing Space Management Methods

  /// Default height for plenty of free drawing space (equivalent to ~6 rows).
  static const double _defaultFreeSpaceHeight = 144; // 6 * 24px

  /// Inserts a free drawing space (line-free region) above the specified Y position.
  void insertFreeDrawingSpace(double yPosition, {double? height}) {
    final spaceHeight = height ?? _defaultFreeSpaceHeight;

    // Create the new free drawing space
    final newSpace = FreeDrawingSpace(
      startY: yPosition,
      height: spaceHeight,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // Shift all existing free drawing spaces that are below this position
    final updatedSpaces = <FreeDrawingSpace>[];
    for (final space in _freeDrawingSpaces) {
      if (space.startY >= yPosition) {
        updatedSpaces.add(space.moveBy(spaceHeight));
      } else {
        updatedSpaces.add(space);
      }
    }

    // Add the new space and sort by startY
    updatedSpaces.add(newSpace);
    updatedSpaces.sort((a, b) => a.startY.compareTo(b.startY));

    // Update the list
    _freeDrawingSpaces.clear();
    _freeDrawingSpaces.addAll(updatedSpaces);

    // Shift all sketch content that is below this position
    _shiftSketchContentDown(yPosition, spaceHeight);

    // Extend canvas to accommodate the new space
    _checkAndResizeCanvas();

    // Recalculate normal indices after free space operation
    _recalculateNormalIndices();

    // Store current state for undo/redo of free space operations
    _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
    _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);

    // Notify listeners
    notifyListeners();
  }

  /// Deletes a free drawing space at the specified Y position.
  void deleteFreeDrawingSpace(double yPosition) {
    // Find the free drawing space that contains this Y position
    final spaceToDelete = _freeDrawingSpaces.firstWhere(
      (space) => space.containsY(yPosition),
      orElse: () => throw StateError(
          'No free drawing space found at Y position $yPosition',),
    );

    final spaceHeight = spaceToDelete.height;
    final spaceStartY = spaceToDelete.startY;

    // Remove the space
    _freeDrawingSpaces.remove(spaceToDelete);

    // Shift all remaining free drawing spaces that are below this position up
    final updatedSpaces = <FreeDrawingSpace>[];
    for (final space in _freeDrawingSpaces) {
      if (space.startY > spaceStartY) {
        updatedSpaces.add(space.moveBy(-spaceHeight));
      } else {
        updatedSpaces.add(space);
      }
    }

    // Update the list
    _freeDrawingSpaces.clear();
    _freeDrawingSpaces.addAll(updatedSpaces);

    // Remove all strokes that were drawn within the deleted free space
    _removeStrokesInRegion(spaceStartY, spaceStartY + spaceHeight);

    // Shift all sketch content that is below this position up
    _shiftSketchContentUp(spaceStartY + spaceHeight, spaceHeight);

    // Recalculate canvas height
    _checkAndResizeCanvas();

    // Recalculate normal indices after free space operation
    _recalculateNormalIndices();

    // Store current state for undo/redo of free space operations
    _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
    _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);

    // Notify listeners
    notifyListeners();
  }

  /// Expands an existing free drawing space by the specified additional height.
  void expandFreeDrawingSpace(double yPosition,
      {double additionalHeight = 72.0,}) {
    // Find the free drawing space that contains this Y position
    final spaceIndex = _freeDrawingSpaces.indexWhere(
      (space) => space.containsY(yPosition),
    );

    if (spaceIndex == -1) {
      throw StateError('No free drawing space found at Y position $yPosition');
    }

    final currentSpace = _freeDrawingSpaces[spaceIndex];
    final expandedSpace = currentSpace.expandBy(additionalHeight);

    // Update the space
    _freeDrawingSpaces[spaceIndex] = expandedSpace;

    // Shift all free drawing spaces that are below this space down
    for (var i = spaceIndex + 1; i < _freeDrawingSpaces.length; i++) {
      _freeDrawingSpaces[i] = _freeDrawingSpaces[i].moveBy(additionalHeight);
    }

    // Shift all sketch content that is below the end of this space down
    final shiftStartY = currentSpace.endY;
    _shiftSketchContentDown(shiftStartY, additionalHeight);

    // Extend canvas to accommodate the expanded space
    _checkAndResizeCanvas();

    // Recalculate normal indices after free space operation
    _recalculateNormalIndices();

    // Store current state for undo/redo of free space operations
    _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
    _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);

    // Notify listeners
    notifyListeners();
  }

  /// Checks if a Y position is within any free drawing space.
  bool isInFreeDrawingSpace(double y) {
    return _freeDrawingSpaces.any((space) => space.containsY(y));
  }

  /// Gets the free drawing space that contains the specified Y position, if any.
  FreeDrawingSpace? getFreeDrawingSpaceAt(double y) {
    try {
      return _freeDrawingSpaces.firstWhere((space) => space.containsY(y));
    } catch (e) {
      return null;
    }
  }

  /// Shifts all sketch content down by the specified amount starting from startY.
  void _shiftSketchContentDown(double startY, double shiftAmount, {bool addToUndoHistory = true}) {
    final currentSketch = value.sketch;
    final shiftedLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      final shiftedPoints = line.points.map((point) {
        if (point.y >= startY) {
          return Point(point.x, point.y + shiftAmount,
              pressure: point.pressure,);
        }
        return point;
      }).toList();

      if (shiftedPoints.isNotEmpty) {
        shiftedLines.add(line.copyWith(points: shiftedPoints));
      }
    }

    final newSketch = currentSketch.copyWith(lines: shiftedLines);
    setSketch(sketch: newSketch, addToUndoHistory: addToUndoHistory);
  }

  /// Removes all strokes that are within the specified Y region.
  void _removeStrokesInRegion(double startY, double endY) {
    final currentSketch = value.sketch;
    final filteredLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      // Check if any point in this line is within the region to be deleted
      final hasPointInRegion = line.points.any((point) =>
          point.y >= startY && point.y <= endY,);

      // Only keep lines that have no points in the deletion region
      if (!hasPointInRegion) {
        filteredLines.add(line);
      }
    }

    final newSketch = currentSketch.copyWith(lines: filteredLines);
    setSketch(sketch: newSketch);
  }

  /// Shifts all sketch content up by the specified amount starting from startY.
  void _shiftSketchContentUp(double startY, double shiftAmount, {bool addToUndoHistory = true}) {
    final currentSketch = value.sketch;
    final shiftedLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      final shiftedPoints = line.points.map((point) {
        if (point.y >= startY) {
          return Point(point.x, point.y - shiftAmount,
              pressure: point.pressure,);
        }
        return point;
      }).toList();

      if (shiftedPoints.isNotEmpty) {
        shiftedLines.add(line.copyWith(points: shiftedPoints));
      }
    }

    final newSketch = currentSketch.copyWith(lines: shiftedLines);
    setSketch(sketch: newSketch, addToUndoHistory: addToUndoHistory);
  }

  /// Clears all free drawing spaces.
  void clearAllFreeDrawingSpaces() {
    _freeDrawingSpaces.clear();
    notifyListeners();
  }

  // Image Row Management Methods

  /// Default height for image rows (equivalent to ~4 rows).
  static const double _defaultImageRowHeight = 96; // 4 * 24px

  /// Inserts an image row above the specified Y position.
  Future<void> insertImageRow(double yPosition, ImageProvider image, {double? height, bool shiftContent = true, String? id}) async {
    final rowHeight = height ?? _defaultImageRowHeight;

    try {
      // Convert ImageProvider to bytes
      final imageBytes = await _imageProviderToBytes(image);
      if (imageBytes == null) {
        throw Exception('Failed to load image from ImageProvider');
      }

      // Calculate indices for the new image row
      final existingImageRowIndex = _imageRows.indexWhere((row) => row.startY >= yPosition);
      final rendererIndex = existingImageRowIndex != -1 ? existingImageRowIndex : _imageRows.length;
      final visualIndex = rendererIndex + 1; // Visual index is 1-based
      
      // Create the new image row with the image bytes and indices
      final newImageRow = ImageRow(
        startY: yPosition,
        height: rowHeight,
        rendererIndex: rendererIndex,
        visualIndex: visualIndex,
        imageBytes: imageBytes,
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (shiftContent) {
        // Shift all existing image rows that are below this position
        final updatedImageRows = <ImageRow>[];
        for (final imageRow in _imageRows) {
          if (imageRow.startY >= yPosition) {
            updatedImageRows.add(imageRow.moveBy(rowHeight));
          } else {
            updatedImageRows.add(imageRow);
          }
        }

        // Shift all existing free drawing spaces that are below this position
        final updatedSpaces = <FreeDrawingSpace>[];
        for (final space in _freeDrawingSpaces) {
          if (space.startY >= yPosition) {
            updatedSpaces.add(space.moveBy(rowHeight));
          } else {
            updatedSpaces.add(space);
          }
        }

        // Add the new image row and sort by startY
        updatedImageRows.add(newImageRow);
        updatedImageRows.sort((a, b) => a.startY.compareTo(b.startY));

        // Update the lists
        _imageRows.clear();
        _imageRows.addAll(updatedImageRows);
        _freeDrawingSpaces.clear();
        _freeDrawingSpaces.addAll(updatedSpaces);

        // Shift all sketch content that is below this position
        _shiftSketchContentDown(yPosition, rowHeight);
      } else {
        // Just add the image row without shifting anything
        _imageRows.add(newImageRow);
        _imageRows.sort((a, b) => a.startY.compareTo(b.startY));
      }

      // Extend canvas to accommodate the new image row
      _checkAndResizeCanvas();

      // Recalculate indices after image row operation
      _recalculateNormalIndices();
      _recalculateImageRowIndices();

      // Load the image asynchronously for rendering (fire and forget)
      if (newImageRow.id != null && newImageRow.imageBytes != null) {
        loadImageForRow(newImageRow.id!, newImageRow.imageBytes!).ignore();
      }

      // Store current state for undo/redo of image operations
      _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
      _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);

      // Notify listeners
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to insert image row: $e');
      rethrow; // Re-throw so calling code can handle the error
    }
  }

  /// Inserts an image row with byte data above the specified Y position.
  void insertImageRowWithBytes(double yPosition, List<int> imageBytes, {double? height, bool shiftContent = true, String? id}) {
    final rowHeight = height ?? _defaultImageRowHeight;

    // Calculate indices for the new image row
    final existingImageRowIndex = _imageRows.indexWhere(
      (row) => row.startY >= yPosition,
    );
    final rendererIndex = 
        existingImageRowIndex != -1 ? existingImageRowIndex : _imageRows.length;
    final visualIndex = rendererIndex + 1; // Visual index is 1-based
    
    // Create the new image row
    final newImageRow = ImageRow(
      startY: yPosition,
      height: rowHeight,
      rendererIndex: rendererIndex,
      visualIndex: visualIndex,
      imageBytes: Uint8List.fromList(imageBytes),
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );

    if (shiftContent) {
      // Shift all existing image rows that are below this position
      final updatedImageRows = <ImageRow>[];
      for (final imageRow in _imageRows) {
        if (imageRow.startY >= yPosition) {
          updatedImageRows.add(imageRow.moveBy(rowHeight));
        } else {
          updatedImageRows.add(imageRow);
        }
      }

      // Shift all existing free drawing spaces that are below this position
      final updatedSpaces = <FreeDrawingSpace>[];
      for (final space in _freeDrawingSpaces) {
        if (space.startY >= yPosition) {
          updatedSpaces.add(space.moveBy(rowHeight));
        } else {
          updatedSpaces.add(space);
        }
      }

      // Add the new image row and sort by startY
      updatedImageRows.add(newImageRow);
      updatedImageRows.sort((a, b) => a.startY.compareTo(b.startY));

      // Update the lists
      _imageRows.clear();
      _imageRows.addAll(updatedImageRows);
      _freeDrawingSpaces.clear();
      _freeDrawingSpaces.addAll(updatedSpaces);

      // Shift all sketch content that is below this position
      _shiftSketchContentDown(yPosition, rowHeight);
    } else {
      // Just add the image row without shifting anything
      _imageRows.add(newImageRow);
      _imageRows.sort((a, b) => a.startY.compareTo(b.startY));
    }

    // Extend canvas to accommodate the new image row
    _checkAndResizeCanvas();

    // Recalculate indices after image row operation
    _recalculateNormalIndices();
    _recalculateImageRowIndices();

    // Load the image asynchronously (fire and forget)
    if (newImageRow.id != null && newImageRow.imageBytes != null) {
      loadImageForRow(newImageRow.id!, newImageRow.imageBytes!).ignore();
    }

    // Store current state for undo/redo of image operations
    _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
    _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);

    // Notify listeners
    notifyListeners();
  }

  /// Deletes an image row at the specified Y position.
  void deleteImageRow(double yPosition) {
    // Find the image row that contains this Y position
    final imageRowToDelete = _imageRows.firstWhere(
      (imageRow) => imageRow.containsY(yPosition),
      orElse: () => throw StateError(
          'No image row found at Y position $yPosition',),
    );

    final rowHeight = imageRowToDelete.height;
    final rowStartY = imageRowToDelete.startY;
    final rowId = imageRowToDelete.id;

    // Remove the loaded image from memory
    if (rowId != null) {
      unloadImageForRow(rowId);
    }

    // Remove the image row
    _imageRows.remove(imageRowToDelete);

    // Shift all remaining image rows that are below this position up
    final updatedImageRows = <ImageRow>[];
    for (final imageRow in _imageRows) {
      if (imageRow.startY > rowStartY) {
        updatedImageRows.add(imageRow.moveBy(-rowHeight));
      } else {
        updatedImageRows.add(imageRow);
      }
    }

    // Shift all free drawing spaces that are below this position up
    final updatedSpaces = <FreeDrawingSpace>[];
    for (final space in _freeDrawingSpaces) {
      if (space.startY > rowStartY) {
        updatedSpaces.add(space.moveBy(-rowHeight));
      } else {
        updatedSpaces.add(space);
      }
    }

    // Update the lists
    _imageRows.clear();
    _imageRows.addAll(updatedImageRows);
    _freeDrawingSpaces.clear();
    _freeDrawingSpaces.addAll(updatedSpaces);

    // Shift all sketch content that is below this position up
    _shiftSketchContentUp(rowStartY + rowHeight, rowHeight);

    // Recalculate canvas height
    _checkAndResizeCanvas();

    // Recalculate indices after image row deletion
    _recalculateNormalIndices();
    _recalculateImageRowIndices();

    // Store current state for undo/redo of image operations
    _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
    _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);

    // Notify listeners
    notifyListeners();
  }

  /// Checks if a Y position is within any image row.
  bool isInImageRow(double y) {
    return _imageRows.any((imageRow) => imageRow.containsY(y));
  }

  /// Gets the image row that contains the specified Y position, if any.
  ImageRow? getImageRowAt(double y) {
    // Primary detection: exact containment
    try {
      return _imageRows.firstWhere((imageRow) => imageRow.containsY(y));
    } catch (e) {
      // Fallback: tolerance-based detection for slight misalignments
      const tolerance = 1.0;
      for (final imageRow in _imageRows) {
        if (y >= (imageRow.startY - tolerance) && 
            y <= (imageRow.endY + tolerance)) {
          return imageRow;
        }
      }
      return null;
    }
  }

  /// Clears all image rows.
  void clearAllImageRows() {
    _imageRows.clear();
    _clearAllLoadedImages();
    notifyListeners();
  }

  /// Loads a ui.Image for the specified image row ID.
  Future<void> loadImageForRow(String imageRowId, Uint8List imageBytes) async {
    try {
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      _loadedImages[imageRowId] = frame.image;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load image for row $imageRowId: $e');
    }
  }

  /// Removes a loaded image from memory.
  void unloadImageForRow(String imageRowId) {
    final image = _loadedImages.remove(imageRowId);
    image?.dispose();
    notifyListeners();
  }

  /// Clears all loaded images from memory.
  void _clearAllLoadedImages() {
    for (final image in _loadedImages.values) {
      image.dispose();
    }
    _loadedImages.clear();
  }

  /// Loads all images for existing image rows.
  Future<void> loadAllImages() async {
    final futures = <Future<void>>[];
    for (final imageRow in _imageRows) {
      if (imageRow.id != null && imageRow.imageBytes != null) {
        futures.add(loadImageForRow(imageRow.id!, imageRow.imageBytes!));
      }
    }
    await Future.wait(futures);
  }

  /// Converts an ImageProvider to bytes for storage.
  Future<Uint8List?> _imageProviderToBytes(ImageProvider imageProvider) async {
    try {
      // Handle different ImageProvider types
      if (imageProvider is MemoryImage) {
        // MemoryImage already has bytes
        return imageProvider.bytes;
      }
      
      // For other ImageProvider types, load the image and encode it
      final stream = imageProvider.resolve(const ImageConfiguration());
      final completer = Completer<Uint8List?>();
      
      late ImageStreamListener listener;
      listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
        stream.removeListener(listener);
        
        // Convert ui.Image to bytes
        info.image.toByteData(format: ui.ImageByteFormat.png).then((byteData) {
          if (byteData != null) {
            completer.complete(Uint8List.fromList(byteData.buffer.asUint8List()));
          } else {
            completer.complete(null);
          }
        }).catchError(completer.completeError);
      }, onError: (Object error, StackTrace? stackTrace) {
        stream.removeListener(listener);
        completer.completeError(error);
      },);
      
      stream.addListener(listener);
      
      return await completer.future;
    } catch (e) {
      debugPrint('Failed to convert ImageProvider to bytes: $e');
      return null;
    }
  }

  // Row Highlighting Methods





  /// Removes highlights from multiple line numbers (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void unhighlightRows(Iterable<int> lineNumbers) {
    var changed = false;
    for (final lineNumber in lineNumbers) {
      if (lineNumber >= 1) {
        if (_highlightedRows.remove(lineNumber) != null) {
          changed = true;
        }
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Clears all row highlights.
  void clearAllHighlights() {
    if (_highlightedRows.isNotEmpty) {
      _highlightedRows.clear();
      notifyListeners();
    }
  }

  /// Checks if a specific line number (1, 2, 3, etc.) is highlighted.
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  bool isRowHighlighted(int lineNumber) {
    if (lineNumber < 1) return false; // Line numbers start at 1
    
    return _highlightedRows.containsKey(lineNumber);
  }

  /// Sets highlights for multiple rows with individual colors.
  /// 
  /// This allows each row to have its own specific highlight color.
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void setHighlightRows(List<RowHighlight> highlights) {
    var changed = false;
    
    for (final highlight in highlights) {
      if (highlight.index >= 1) {
        final currentColor = _highlightedRows[highlight.index];
        if (currentColor != highlight.color) {
          _highlightedRows[highlight.index] = highlight.color;
          changed = true;
        }
      }
    }
    
    if (changed) {
      notifyListeners();
    }
  }

  /// Gets the highlight color for a specific line number.
  /// 
  /// Returns the specific color assigned to this row, or null if the row
  /// is not highlighted. Line numbers correspond to what users see displayed
  /// on the UI. Free drawing spaces and image rows are skipped when counting
  /// line numbers.
  Color? getRowHighlightColor(int lineNumber) {
    if (lineNumber < 1) return null; // Line numbers start at 1
    
    return _highlightedRows[lineNumber];
  }

  /// Converts a line number (1, 2, 3...) to the corresponding renderer index (0, 1, 2...).
  /// 
  /// Line numbers are what users see displayed on the UI (normal indices), while
  /// renderer indices are internal array positions used to access the _rows array.
  /// This method uses the dual index system to find the row with the matching normalIndex.
  /// 
  /// Returns the renderer index for the row, or null if the line number doesn't exist.
  int? getRowIndexForLineNumber(int lineNumber) {
    if (lineNumber < 1) return null; // Line numbers (normal indices) start at 1
    
    // Use the dual index system: find the row with matching normalIndex
    for (var i = 0; i < _rows.length; i++) {
      final row = _rows[i];
      if (row.normalIndex == lineNumber) {
        return i; // Return the renderer index (array position)
      }
    }
    
    return null; // Line number not found
  }

  /// Gets the maximum line number currently available.
  /// 
  /// This counts only regular text rows, skipping image rows and free drawing spaces.
  /// Returns 0 if there are no text rows.
  int getMaxLineNumber() {
    var maxLineNumber = 0;
    
    for (var i = 0; i < _rows.length; i++) {
      final row = _rows[i];
      final currentRowY = row.startY;
      final freeSpace = getFreeDrawingSpaceAt(currentRowY);
      final imageRow = getImageRowAt(currentRowY);
      
      // Skip rows that are within free drawing spaces or image rows
      if (freeSpace != null || imageRow != null) {
        continue;
      }
      
      // This is a regular text row
      maxLineNumber++;
    }
    
    return maxLineNumber;
  }

  // Note: Free drawing space undo/redo is handled through the sketch operations
  // Since all free space operations trigger sketch modifications with addToUndoHistory: true,
  // the undo/redo functionality works through the existing sketch history system.

  /// Map to store free drawing spaces for each sketch state
  final Map<Sketch, List<FreeDrawingSpace>> _sketchToSpacesMap = {};

  /// Map to store image rows for each sketch state
  final Map<Sketch, List<ImageRow>> _sketchToImageRowsMap = {};

  @override
  Future<void> setSketch({
    required Sketch sketch, 
    bool addToUndoHistory = true,
    Map<String, ImageProvider>? imageProviders,
    List<ImageRow>? imageRows,
    List<FreeDrawingSpace>? freeDrawingSpaces,
  }) async {
    // Note: We no longer automatically store image rows and free drawing spaces
    // on every sketch change. They should persist independently unless explicitly
    // modified through their dedicated operations.
    super.setSketch(sketch: sketch, addToUndoHistory: addToUndoHistory);
    
    // Restore image rows if provided
    if (imageRows != null) {
      _imageRows.clear();
      _imageRows.addAll(imageRows);
      // Sort by startY to maintain proper order
      _imageRows.sort((a, b) => a.startY.compareTo(b.startY));
    }
    
    // Restore free drawing spaces if provided
    if (freeDrawingSpaces != null) {
      _freeDrawingSpaces.clear();
      _freeDrawingSpaces.addAll(freeDrawingSpaces);
      // Sort by startY to maintain proper order
      _freeDrawingSpaces.sort((a, b) => a.startY.compareTo(b.startY));
    }
    
    // Load image data if provided
    if (imageProviders != null) {
      for (final imageRow in _imageRows) {
        final id = imageRow.id;
        if (id != null && imageProviders.containsKey(id)) {
          // Convert ImageProvider to bytes and load the image asynchronously
          final imageProvider = imageProviders[id]!;
          final imageBytes = await _imageProviderToBytes(imageProvider);
          if (imageBytes != null) {
            await loadImageForRow(id, imageBytes);
          }
        }
      }
    }
    
    // After sketch changes, check if canvas needs to be resized
    _checkAndResizeCanvas();
  }

  /// Exports the complete notebook data to JSON format.
  /// 
  /// Returns a Map containing:
  /// - sketch: The drawing data (lines, points)
  /// - imageRows: Image metadata (position, size, id - excludes image bytes)
  /// - freeDrawingSpaces: Free drawing space data
  /// - canvasHeight: Current canvas height
  /// - rowLineSpacing: Current row line spacing
  /// - topMargin: Top margin setting
  /// - bottomMargin: Bottom margin setting
  Map<String, dynamic> exportToJson() {
    return {
      'sketch': value.sketch.toJson(),
      'imageRows': imageRows.map((row) => row.toJson()).toList(),
      'freeDrawingSpaces': freeDrawingSpaces.map((space) => space.toJson()).toList(),
      'canvasHeight': canvasHeight,
      'rowLineSpacing': rowLineSpacing,
      'topMargin': topMargin,
      'bottomMargin': bottomMargin,
    };
  }

  /// Imports notebook data from JSON format.
  /// 
  /// Takes a Map (from exportToJson) and optional ImageProviders for loading
  /// actual image data. The JSON contains sketch data, image metadata, and 
  /// free drawing spaces, but not the actual image bytes.
  /// 
  /// [jsonData] - The JSON data from exportToJson()
  /// [imageProviders] - Optional map of image providers keyed by image row ID
  /// [addToUndoHistory] - Whether to add this import to undo history
  Future<void> importFromJson(
    Map<String, dynamic> jsonData, {
    Map<String, ImageProvider>? imageProviders,
    bool addToUndoHistory = true,
  }) async {
    // Parse the JSON data
    final sketch = Sketch.fromJson(jsonData['sketch'] as Map<String, dynamic>);
    
    final imageRowsData = jsonData['imageRows'] as List<dynamic>?;
    final imageRows = imageRowsData
        ?.map((json) => ImageRow.fromJson(json as Map<String, dynamic>))
        .toList();
    
    final freeDrawingSpacesData = jsonData['freeDrawingSpaces'] as List<dynamic>?;
    final freeDrawingSpaces = freeDrawingSpacesData
        ?.map((json) => FreeDrawingSpace.fromJson(json as Map<String, dynamic>))
        .toList();
    
    // Restore canvas properties if provided
    final canvasHeight = jsonData['canvasHeight'] as double?;
    final rowLineSpacing = jsonData['rowLineSpacing'] as double?;
    
    // Apply canvas properties
    if (canvasHeight != null) {
      setCanvasHeight(canvasHeight);
    }
    if (rowLineSpacing != null) {
      setRowLineSpacing(rowLineSpacing);
    }
    
    // Import the data using setSketch
    await setSketch(
      sketch: sketch,
      imageRows: imageRows,
      freeDrawingSpaces: freeDrawingSpaces,
      imageProviders: imageProviders,
      addToUndoHistory: addToUndoHistory,
    );
    
    // Recalculate normal indices after import to ensure row numbers are correct
    _recalculateNormalIndices();
  }

  @override
  ScribbleState transformHistoryValue(
    ScribbleState historyValue,
    ScribbleState currentState,
  ) {
    // Note: We no longer restore image rows and free drawing spaces from
    // sketch-based maps during undo/redo. They should persist independently
    // unless explicitly modified through dedicated operations.
    // This prevents image rows from disappearing when undoing strokes.
    
    return super.transformHistoryValue(historyValue, currentState);
  }

  // Row Range Export Methods

  /// Extracts content (sketch lines, free drawing spaces, and image rows) 
  /// within the specified row range for export.
  /// 
  /// [startRendererIndex] and [endRendererIndex] are 0-based renderer indices.
  /// Returns a RowRangeContent object containing all content in the range.
  RowRangeContent getContentInRowRange(int startRendererIndex, int endRendererIndex) {
    if (startRendererIndex < 0 || endRendererIndex < startRendererIndex) {
      throw ArgumentError('Invalid row range: $startRendererIndex to $endRendererIndex');
    }

    // Get Y coordinates for the row range using renderer indices
    final startRow = getRowByRendererIndex(startRendererIndex);
    final endRow = getRowByRendererIndex(endRendererIndex);
    
    if (startRow == null) {
      throw ArgumentError('Start row index $startRendererIndex does not exist');
    }
    
    final startY = startRow.startY;
    final endY = endRow?.endY ?? (startRow.startY + _rowLineSpacing);

    // Filter sketch lines within the Y range
    final filteredLines = <SketchLine>[];
    for (final line in value.sketch.lines) {
      final lineMinY = line.points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
      final lineMaxY = line.points.map((p) => p.y).reduce((a, b) => a > b ? a : b);
      
      // Include line if any part of it is within the row range
      if (lineMaxY >= startY && lineMinY <= endY) {
        filteredLines.add(line);
      }
    }

    // Filter free drawing spaces within the Y range
    final filteredSpaces = _freeDrawingSpaces.where((space) {
      return space.endY >= startY && space.startY <= endY;
    }).toList();

    // Filter image rows within the Y range
    final filteredImageRows = _imageRows.where((imageRow) {
      return imageRow.endY >= startY && imageRow.startY <= endY;
    }).toList();

    return RowRangeContent(
      startY: startY,
      endY: endY,
      sketchLines: filteredLines,
      freeDrawingSpaces: filteredSpaces,
      imageRows: filteredImageRows,
    );
  }

  /// Renders the content within the specified row range to an image using the actual painters.
  /// 
  /// [startRowIndex] and [endRowIndex] are 0-based row indices.
  /// [pixelRatio] can be used to increase the resolution of the output image.
  /// [theme] the theme to use for rendering (affects colors, etc.)
  /// Returns the image as ByteData in the specified format.
  /// 
  /// Note: This method does not include line numbers in the export.
  Future<ByteData> exportRowRangeToImage({
    required int startRowIndex,
    required int endRowIndex,
    required ScribbleTheme theme,
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
    bool simulatePressure = true,
  }) async {
    // Validate row indices
    if (startRowIndex < 0 || endRowIndex < startRowIndex || startRowIndex >= _rows.length) {
      throw ArgumentError('Invalid row range: $startRowIndex to $endRowIndex');
    }

    // Calculate Y coordinates for the row range
    final startRow = _rows[startRowIndex];
    final endRow = endRowIndex < _rows.length ? _rows[endRowIndex] : _rows.last;
    final startY = startRow.startY;
    final endY = endRow.endY;

    // Validate that Y coordinates are sensible
    if (startY < 0 || endY <= startY) {
      throw StateError('Invalid Y coordinates: startY=$startY, endY=$endY');
    }

    // Create the painter stack using the exact same painters as LineByLineCanvas
    // Use the same hardcoded margins as LineByLineCanvas for visual consistency
    final painterStack = ReusablePainterExport.createPainterStack(
      sketch: value.sketch,
      rows: _rows,
      freeDrawingSpaces: _freeDrawingSpaces,
      imageRows: _imageRows,
      loadedImages: _loadedImages,
      theme: theme,
      canvasWidth: _canvasWidth,
      canvasHeight: _canvasHeight,
      rowLineSpacing: _rowLineSpacing,
      rowLineWidth: 1,
      simulatePressure: simulatePressure,
    );

    // Render the row range using the reusable painters
    return ReusablePainterExport.renderRowRange(
      painters: painterStack,
      startY: startY,
      endY: endY,
      canvasWidth: _canvasWidth,
      pixelRatio: pixelRatio,
      format: format,
    );
  }

  /// Exports a row range to an image including line numbers by capturing the RepaintBoundary.
  /// 
  /// This method captures the full canvas including line number widgets and crops
  /// the specified row range. This ensures line numbers appear exactly as shown on screen.
  /// 
  /// [startRowIndex] and [endRowIndex] are 0-based renderer indices (internal array positions).
  /// To convert from user-visible line numbers, use [getRowIndexForLineNumber] first.
  /// Example: `startRowIndex = getRowIndexForLineNumber(2) ?? 0` for line number 2.
  /// 
  /// [pixelRatio] can be used to increase the resolution of the output image.
  /// [forceLightBackground] ensures exported images have white background for consistency.
  /// Returns the image as ByteData in the specified format.
  Future<ByteData> exportRowRangeWithLineNumbers({
    required int startRowIndex,
    required int endRowIndex,
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
    bool forceLightBackground = true,
  }) async {
    // Validate row indices
    if (startRowIndex < 0 || endRowIndex < startRowIndex || startRowIndex >= _rows.length) {
      throw ArgumentError('Invalid row range: $startRowIndex to $endRowIndex');
    }

    // Calculate Y coordinates for the row range
    final startRow = _rows[startRowIndex];
    final endRow = endRowIndex < _rows.length ? _rows[endRowIndex] : _rows.last;
    final startY = startRow.startY;
    final endY = endRow.endY;

    // Validate that Y coordinates are sensible
    if (startY < 0 || endY <= startY) {
      throw StateError('Invalid Y coordinates: startY=$startY, endY=$endY');
    }

    // Capture the full RepaintBoundary (includes line numbers and all content)
    final renderObject = repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (renderObject == null) {
      throw StateError(
        "Tried to export row range, but no valid RenderObject was found!",
      );
    }

    // Render the full canvas to an image
    final fullImage = await renderObject.toImage(pixelRatio: pixelRatio);
    
    // Convert to ByteData for manipulation
    final fullImageByteData = await fullImage.toByteData();
    if (fullImageByteData == null) {
      fullImage.dispose();
      throw StateError('Failed to convert full canvas to byte data');
    }

    // Calculate crop parameters
    // Row coordinates are already relative to the RepaintBoundary coordinate system
    // No additional margin adjustment needed since RepaintBoundary captures from (0,0)
    final cropStartY = startY * pixelRatio;
    final cropHeight = (endY - startY) * pixelRatio;
    final cropWidth = fullImage.width.toDouble();

    // Ensure crop dimensions are within bounds
    final validCropStartY = cropStartY.clamp(0, fullImage.height.toDouble()).toDouble();
    final validCropHeight = cropHeight.clamp(1, fullImage.height - validCropStartY).toDouble();

    // Create a new image with just the row range
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Create a source rect from the full image
    final srcRect = Rect.fromLTWH(
      0,
      validCropStartY,
      cropWidth,
      validCropHeight,
    );
    
    // Create a destination rect for the cropped image
    final destRect = Rect.fromLTWH(
      0,
      0,
      cropWidth,
      validCropHeight,
    );

    // Draw white background first if light background is forced
    if (forceLightBackground) {
      final backgroundPaint = Paint()..color = Colors.white;
      canvas.drawRect(destRect, backgroundPaint);
    }

    // Draw the cropped portion on top of the background
    canvas.drawImageRect(fullImage, srcRect, destRect, Paint());

    // Draw strokes with forced black color on top for consistency
    if (forceLightBackground) {
      // Create a modified sketch with all strokes in black
      final blackStrokesSketch = _createBlackStrokesSketch(value.sketch);
      
      // Create a ScribblePainter with light theme to render black strokes
      final scribblePainter = ScribblePainter(
        sketch: blackStrokesSketch,
        scaleFactor: pixelRatio, // Match the export scaling for consistent stroke size
        simulatePressure: true,
        theme: ScribbleTheme.light, // Force light theme for black strokes
      );

      // Apply canvas transform to match the crop region
      canvas.save();
      
      // Scale canvas to match final image pixel ratio
      canvas.scale(pixelRatio);
      
      // Create clip rectangle in scaled coordinate system
      final scaledDestRect = Rect.fromLTWH(
        0,
        0,
        cropWidth / pixelRatio,
        validCropHeight / pixelRatio,
      );
      canvas.clipRect(scaledDestRect);
      
      // Use original coordinates for transform
      canvas.translate(0, -startY);
      
      // Paint the black strokes on top using original canvas dimensions
      scribblePainter.paint(canvas, Size(_canvasWidth, _canvasHeight));
      
      canvas.restore();
    }

    // End recording and create the cropped image
    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(
      cropWidth.round(),
      validCropHeight.round(),
    );

    // Convert to final byte data
    final result = await croppedImage.toByteData(format: format);

    // Clean up
    fullImage.dispose();
    picture.dispose();
    croppedImage.dispose();

    if (result == null) {
      throw StateError('Failed to export row range to image');
    }

    return result;
  }

  /// Creates a copy of the sketch with all stroke colors forced to black.
  /// 
  /// This ensures consistent black strokes in exported images regardless of
  /// the original stroke colors or current theme.
  Sketch _createBlackStrokesSketch(Sketch originalSketch) {
    const blackColor = 0xFF000000; // Black color value
    
    final blackLines = originalSketch.lines.map((line) {
      return line.copyWith(color: blackColor);
    }).toList();
    
    return originalSketch.copyWith(lines: blackLines);
  }

  /// Checkpoint sketch state for comparison.
  Sketch? _checkpoint;

  /// Timestamp when the checkpoint was created.
  DateTime? _checkpointTimestamp;

  
  /// Gets all rows that contain sketch content.
  Set<NotebookRow> getRowsWithContent([Sketch? sketch]) {
    sketch ??= value.sketch;
    final rowsWithContent = <NotebookRow>{};
    
    for (final line in sketch.lines) {
      final yRange = _getLineYRange(line);
      if (yRange != null) {
        rowsWithContent.addAll(_getRowsInRange(yRange.$1, yRange.$2));
      }
    }
    
    return rowsWithContent;
  }
  
  /// Gets the Y-coordinate bounds of content within a specific row.
  (double minY, double maxY)? getContentBoundsForRow(NotebookRow row, [Sketch? sketch]) {
    sketch ??= value.sketch;
    
    double? minY;
    double? maxY;
    
    for (final line in sketch.lines) {
      for (final point in line.points) {
        if (row.containsY(point.y)) {
          minY = minY == null ? point.y : math.min(minY, point.y);
          maxY = maxY == null ? point.y : math.max(maxY, point.y);
        }
      }
    }
    
    if (minY != null && maxY != null) {
      return (minY, maxY);
    }
    return null;
  }
  
  /// Checks if the sketch has any content within the specified Y range.
  bool hasContentInRange(double startY, double endY, [Sketch? sketch]) {
    sketch ??= value.sketch;
    
    for (final line in sketch.lines) {
      for (final point in line.points) {
        if (point.y >= startY && point.y <= endY) {
          return true;
        }
      }
    }
    return false;
  }
  
  /// Gets rows that have content changes between two sketch states.
  Set<NotebookRow> getRowsWithChanges(Sketch oldSketch, Sketch newSketch) {
    final changedRows = <NotebookRow>{};
    
    // Get rows with content in old sketch
    final oldRows = getRowsWithContent(oldSketch);
    
    // Get rows with content in new sketch
    final newRows = getRowsWithContent(newSketch);
    
    // Rows that had content added or removed
    changedRows.addAll(oldRows.difference(newRows)); // Removed content
    changedRows.addAll(newRows.difference(oldRows)); // Added content
    
    // Check for modified content in rows that had content in both states
    final commonRows = oldRows.intersection(newRows);
    for (final row in commonRows) {
      final oldBounds = getContentBoundsForRow(row, oldSketch);
      final newBounds = getContentBoundsForRow(row, newSketch);
      
      // If bounds changed, content was modified
      if (oldBounds != newBounds) {
        changedRows.add(row);
      } else {
        // Check if actual points changed even if bounds are same
        final oldHasContent = hasContentInRange(row.startY, row.endY, oldSketch);
        final newHasContent = hasContentInRange(row.startY, row.endY, newSketch);
        if (oldHasContent != newHasContent) {
          changedRows.add(row);
        }
      }
    }
    
    return changedRows;
  }
  

  // Checkpoint Management Methods

  /// Sets a checkpoint at the current sketch state.
  /// This stores the current state for later comparison.
  void setCheckpoint() {
    _checkpoint = value.sketch;
    _checkpointTimestamp = DateTime.now();
  }

  /// Clears the current checkpoint.
  void clearCheckpoint() {
    _checkpoint = null;
    _checkpointTimestamp = null;
  }

  /// Checks if a checkpoint is currently set.
  bool hasCheckpoint() {
    return _checkpoint != null;
  }

  /// Gets the timestamp when the checkpoint was created.
  /// Returns null if no checkpoint is set.
  DateTime? getCheckpointTimestamp() {
    return _checkpointTimestamp;
  }

  // Checkpoint Comparison Methods

  /// Detects which rows have changed since the set checkpoint.
  /// 
  /// Returns change information comparing the current sketch with the
  /// stored checkpoint. If no checkpoint is set, returns empty change info.
  RowChangeInfo detectChangesSinceCheckpoint() {
    if (_checkpoint == null) {
      return const RowChangeInfo(
        affectedRendererIndices: {},
        affectedNormalIndices: {},
        changeType: RowChangeType.contentModified,
        isCheckpointComparison: true,
      );
    }

    final currentSketch = value.sketch;
    final checkpointSketch = _checkpoint!;

    // Quick check: if nothing changed, return empty change info
    if (_areSketchesEqual(checkpointSketch.lines, currentSketch.lines)) {
      return RowChangeInfo(
        affectedRendererIndices: const {},
        affectedNormalIndices: const {},
        changeType: RowChangeType.contentModified,
        isCheckpointComparison: true,
        checkpointTimestamp: _checkpointTimestamp,
      );
    }

    // Get only the rows that have actual changes
    final affectedRows = getRowsWithChanges(checkpointSketch, currentSketch);

    // Determine change type
    final changeType = _determineChangeType(
      checkpointSketch.lines,
      currentSketch.lines,
      affectedRows,
    );

    return _createChangeInfoWithCheckpoint(affectedRows, changeType);
  }

  /// Gets all rows that have changed since the checkpoint.
  /// Returns empty set if no checkpoint is set.
  Set<NotebookRow> getRowsChangedSinceCheckpoint() {
    if (_checkpoint == null) {
      return {};
    }

    return getRowsWithChanges(_checkpoint!, value.sketch);
  }

  /// Gets the Y-coordinate bounds of changes since the checkpoint.
  /// Returns null if no checkpoint is set or no changes found.
  (double minY, double maxY)? getContentBoundsSinceCheckpoint() {
    final changeInfo = detectChangesSinceCheckpoint();
    if (changeInfo.minY != null && changeInfo.maxY != null) {
      return (changeInfo.minY!, changeInfo.maxY!);
    }
    return null;
  }
  
  // Helper methods for change detection
  
  /// Gets the Y range of a sketch line.
  (double, double)? _getLineYRange(SketchLine line) {
    if (line.points.isEmpty) return null;
    
    var minY = line.points.first.y;
    var maxY = line.points.first.y;
    
    for (final point in line.points) {
      minY = math.min(minY, point.y);
      maxY = math.max(maxY, point.y);
    }
    
    return (minY, maxY);
  }
  
  /// Gets all rows that overlap with the given Y range.
  Set<NotebookRow> _getRowsInRange(double minY, double maxY) {
    final rows = <NotebookRow>{};
    
    for (final row in _rows) {
      if (row.overlaps(minY, maxY)) {
        rows.add(row);
      }
    }
    
    return rows;
  }
  
  /// Checks if two sketch line lists are equal.
  bool _areSketchesEqual(List<SketchLine> lines1, List<SketchLine> lines2) {
    if (lines1.length != lines2.length) return false;
    
    for (var i = 0; i < lines1.length; i++) {
      if (!_areLinesEqual(lines1[i], lines2[i])) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Checks if two sketch lines are equal.
  bool _areLinesEqual(SketchLine line1, SketchLine line2) {
    if (line1.color != line2.color || 
        line1.width != line2.width ||
        line1.points.length != line2.points.length) {
      return false;
    }
    
    for (var i = 0; i < line1.points.length; i++) {
      final p1 = line1.points[i];
      final p2 = line2.points[i];
      if (p1.x != p2.x || p1.y != p2.y || p1.pressure != p2.pressure) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Determines the type of change that occurred.
  RowChangeType _determineChangeType(
    List<SketchLine> oldLines,
    List<SketchLine> newLines,
    Set<NotebookRow> affectedRows,
  ) {
    if (oldLines.isEmpty && newLines.isNotEmpty) {
      return RowChangeType.contentAdded;
    } else if (oldLines.isNotEmpty && newLines.isEmpty) {
      return RowChangeType.contentRemoved;
    } else {
      // Check if content was added or removed in affected rows
      var hasAdditions = false;
      var hasRemovals = false;
      
      for (final row in affectedRows) {
        final oldHasContent = hasContentInRange(
          row.startY, 
          row.endY, 
          Sketch(lines: oldLines),
        );
        final newHasContent = hasContentInRange(
          row.startY,
          row.endY,
          Sketch(lines: newLines),
        );
        
        if (!oldHasContent && newHasContent) {
          hasAdditions = true;
        } else if (oldHasContent && !newHasContent) {
          hasRemovals = true;
        }
      }
      
      if (hasAdditions && hasRemovals) {
        return RowChangeType.mixed;
      } else if (hasAdditions) {
        return RowChangeType.contentAdded;
      } else if (hasRemovals) {
        return RowChangeType.contentRemoved;
      } else {
        return RowChangeType.contentModified;
      }
    }
  }
  

  /// Creates a RowChangeInfo from affected rows with checkpoint metadata.
  RowChangeInfo _createChangeInfoWithCheckpoint(
    Set<NotebookRow> affectedRows,
    RowChangeType changeType,
  ) {
    final rendererIndices = <int>{};
    final normalIndices = <int>{};
    double? minY;
    double? maxY;
    
    for (final row in affectedRows) {
      rendererIndices.add(row.rendererIndex);
      if (row.normalIndex != null) {
        normalIndices.add(row.normalIndex!);
      }
      
      minY = minY == null ? row.startY : math.min(minY, row.startY);
      maxY = maxY == null ? row.endY : math.max(maxY, row.endY);
    }
    
    return RowChangeInfo(
      affectedRendererIndices: rendererIndices,
      affectedNormalIndices: normalIndices,
      changeType: changeType,
      minY: minY,
      maxY: maxY,
      isCheckpointComparison: true,
      checkpointTimestamp: _checkpointTimestamp,
    );
  }

}
