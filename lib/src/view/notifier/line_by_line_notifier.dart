import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/simplification/sketch_simplifier.dart';
import 'package:scribble/src/domain/model/image_row/image_row.dart';
import 'package:scribble/src/domain/model/row/row.dart';

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
    // Initialize rows based on initial canvas height
    _initializeRows();
  }

  /// Row line spacing for line-by-line writing.
  double _rowLineSpacing;
  double get rowLineSpacing => _rowLineSpacing;

  /// Top margin for the canvas.
  double _topMargin;
  double get topMargin => _topMargin;

  /// Bottom margin buffer for the canvas.
  double _bottomMargin;
  double get bottomMargin => _bottomMargin;

  /// Current canvas height.
  double _canvasHeight;
  double get canvasHeight => _canvasHeight;

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

  /// Set of highlighted row indices.
  final Set<int> _highlightedRows = <int>{};

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
  Set<int> get highlightedRows => Set.unmodifiable(_highlightedRows);

  /// Sets the callback for canvas height changes.
  void setCanvasHeightChangeCallback(
      void Function(double newHeight)? callback) {
    _onCanvasHeightChanged = callback;
  }

  /// Sets the row line spacing.
  void setRowLineSpacing(double spacing) {
    _rowLineSpacing = spacing;
    _checkAndExtendCanvas();
  }

  /// Sets the sequential writing mode.
  void setSequentialMode(bool enabled) {
    _sequentialMode = enabled;
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
    
    for (int i = 0; i < numberOfRows; i++) {
      final rowY = _topMargin + (i * _rowLineSpacing);
      _rows.add(NotebookRow(
        startY: rowY,
        index: i,
        height: _rowLineSpacing,
        id: 'row_$i',
      ));
    }
  }

  /// Gets a row by its index, returns null if not found.
  NotebookRow? getRowByIndex(int index) {
    if (index < 0 || index >= _rows.length) return null;
    return _rows[index];
  }

  /// Gets the row that contains the specified Y position, returns null if not found.
  NotebookRow? getRowAt(double y) {
    return _rows.cast<NotebookRow?>().firstWhere(
      (row) => row?.containsY(y) == true,
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
    if (!value.sketch.lines.isNotEmpty) {
      return _topMargin;
    }

    double maxY = _topMargin;
    for (final line in value.sketch.lines) {
      for (final point in line.points) {
        if (point.y > maxY) {
          maxY = point.y;
        }
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

  /// Checks if canvas needs to be extended and extends it if necessary.
  void _checkAndExtendCanvas() {
    final requiredRows = _getRequiredRows();
    final requiredHeight =
        _topMargin + (requiredRows * _rowLineSpacing) + _bottomMargin;

    if (requiredHeight > _canvasHeight) {
      setCanvasHeight(requiredHeight);
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
    _checkAndExtendCanvas();
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
    _checkAndExtendCanvas();
  }

  @override
  void onPointerUp(PointerUpEvent event) {
    super.onPointerUp(event);
    _checkAndExtendCanvas();
  }

  /// Gets the progress-based opacity for a line number.
  double getLineNumberOpacity(int lineIndex) {
    // Always show the first two line numbers at full opacity
    if (lineIndex == 0 || lineIndex == 1) {
      return 1.0;
    }

    final maxContentY = _getMaxContentY();
    if (maxContentY <= _topMargin) {
      // No content yet, only show first two lines
      return 0.0;
    }

    // Calculate which visible line number the content has reached
    final contentRowIndex = getRowIndexForY(maxContentY);
    final contentVisibleLineNumber = _getVisibleLineNumberForRowIndex(contentRowIndex);

    // Show line numbers progressively: if content reached visible line N, show numbers 1 through N+2
    if (lineIndex <= contentVisibleLineNumber + 1) { // +1 because lineIndex is 0-based
      return 1.0;
    } else {
      return 0.0;
    }
  }

  /// Converts a raw row index to a visible line number (0-based).
  /// Returns -1 if the row index corresponds to an image row or invalid position.
  int _getVisibleLineNumberForRowIndex(int rowIndex) {
    if (rowIndex < 0) return -1;
    
    // Count how many visible text lines come before this row index
    int visibleLineCount = 0;
    
    for (int i = 0; i <= rowIndex; i++) {
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
    final maxRow = getRowByIndex(maxRowIndex);
    
    if (maxRow == null) return y >= _topMargin;
    
    // Allow drawing within current content area plus one extra row
    final allowedMaxY = maxRow.endY + _rowLineSpacing;

    return y >= _topMargin && y <= allowedMaxY;
  }

  // Free Drawing Space Management Methods

  /// Default height for plenty of free drawing space (equivalent to ~6 rows).
  static const double _defaultFreeSpaceHeight = 144.0; // 6 * 24px

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
    _shiftSketchContentDown(yPosition, spaceHeight, addToUndoHistory: true);

    // Extend canvas to accommodate the new space
    _checkAndExtendCanvas();

    // Notify listeners
    notifyListeners();
  }

  /// Deletes a free drawing space at the specified Y position.
  void deleteFreeDrawingSpace(double yPosition) {
    // Find the free drawing space that contains this Y position
    final spaceToDelete = _freeDrawingSpaces.firstWhere(
      (space) => space.containsY(yPosition),
      orElse: () => throw StateError(
          'No free drawing space found at Y position $yPosition'),
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
    _shiftSketchContentUp(spaceStartY + spaceHeight, spaceHeight, addToUndoHistory: true);

    // Recalculate canvas height
    _checkAndExtendCanvas();

    // Notify listeners
    notifyListeners();
  }

  /// Expands an existing free drawing space by the specified additional height.
  void expandFreeDrawingSpace(double yPosition,
      {double additionalHeight = 72.0}) {
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
    for (int i = spaceIndex + 1; i < _freeDrawingSpaces.length; i++) {
      _freeDrawingSpaces[i] = _freeDrawingSpaces[i].moveBy(additionalHeight);
    }

    // Shift all sketch content that is below the end of this space down
    final shiftStartY = currentSpace.endY;
    _shiftSketchContentDown(shiftStartY, additionalHeight, addToUndoHistory: true);

    // Extend canvas to accommodate the expanded space
    _checkAndExtendCanvas();

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
              pressure: point.pressure);
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
          point.y >= startY && point.y <= endY);

      // Only keep lines that have no points in the deletion region
      if (!hasPointInRegion) {
        filteredLines.add(line);
      }
    }

    final newSketch = currentSketch.copyWith(lines: filteredLines);
    setSketch(sketch: newSketch, addToUndoHistory: true);
  }

  /// Shifts all sketch content up by the specified amount starting from startY.
  void _shiftSketchContentUp(double startY, double shiftAmount, {bool addToUndoHistory = true}) {
    final currentSketch = value.sketch;
    final shiftedLines = <SketchLine>[];

    for (final line in currentSketch.lines) {
      final shiftedPoints = line.points.map((point) {
        if (point.y >= startY) {
          return Point(point.x, point.y - shiftAmount,
              pressure: point.pressure);
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
  static const double _defaultImageRowHeight = 96.0; // 4 * 24px

  /// Inserts an image row above the specified Y position.
  Future<void> insertImageRow(double yPosition, ImageProvider image, {double? height, bool shiftContent = true, bool addToUndoHistory = false}) async {
    final rowHeight = height ?? _defaultImageRowHeight;

    try {
      // Convert ImageProvider to bytes
      final imageBytes = await _imageProviderToBytes(image);
      if (imageBytes == null) {
        throw Exception('Failed to load image from ImageProvider');
      }

      // Create the new image row with the image bytes
      final newImageRow = ImageRow(
        startY: yPosition,
        height: rowHeight,
        imageBytes: imageBytes,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
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
        _shiftSketchContentDown(yPosition, rowHeight, addToUndoHistory: addToUndoHistory);
      } else {
        // Just add the image row without shifting anything
        _imageRows.add(newImageRow);
        _imageRows.sort((a, b) => a.startY.compareTo(b.startY));
      }

      // Extend canvas to accommodate the new image row
      _checkAndExtendCanvas();

      // Load the image asynchronously for rendering (fire and forget)
      if (newImageRow.id != null && newImageRow.imageBytes != null) {
        loadImageForRow(newImageRow.id!, newImageRow.imageBytes!).ignore();
      }

      // Notify listeners
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to insert image row: $e');
      rethrow; // Re-throw so calling code can handle the error
    }
  }

  /// Inserts an image row with byte data above the specified Y position.
  void insertImageRowWithBytes(double yPosition, List<int> imageBytes, {double? height, bool shiftContent = true, bool addToUndoHistory = false}) {
    final rowHeight = height ?? _defaultImageRowHeight;

    // Create the new image row
    final newImageRow = ImageRow(
      startY: yPosition,
      height: rowHeight,
      imageBytes: Uint8List.fromList(imageBytes),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
      _shiftSketchContentDown(yPosition, rowHeight, addToUndoHistory: addToUndoHistory);
    } else {
      // Just add the image row without shifting anything
      _imageRows.add(newImageRow);
      _imageRows.sort((a, b) => a.startY.compareTo(b.startY));
    }

    // Extend canvas to accommodate the new image row
    _checkAndExtendCanvas();

    // Load the image asynchronously (fire and forget)
    if (newImageRow.id != null && newImageRow.imageBytes != null) {
      loadImageForRow(newImageRow.id!, newImageRow.imageBytes!).ignore();
    }

    // Notify listeners
    notifyListeners();
  }

  /// Deletes an image row at the specified Y position.
  void deleteImageRow(double yPosition, {bool addToUndoHistory = false}) {
    // Find the image row that contains this Y position
    final imageRowToDelete = _imageRows.firstWhere(
      (imageRow) => imageRow.containsY(yPosition),
      orElse: () => throw StateError(
          'No image row found at Y position $yPosition'),
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
    _shiftSketchContentUp(rowStartY + rowHeight, rowHeight, addToUndoHistory: addToUndoHistory);

    // Recalculate canvas height
    _checkAndExtendCanvas();

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
      final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
      final Completer<Uint8List?> completer = Completer<Uint8List?>();
      
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
        }).catchError((Object error) {
          completer.completeError(error);
        });
      }, onError: (Object error, StackTrace? stackTrace) {
        stream.removeListener(listener);
        completer.completeError(error);
      });
      
      stream.addListener(listener);
      
      return await completer.future;
    } catch (e) {
      debugPrint('Failed to convert ImageProvider to bytes: $e');
      return null;
    }
  }

  // Row Highlighting Methods

  /// Highlights the specified line number (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void highlightRow(int lineNumber) {
    final rowIndex = _getRowIndexForLineNumber(lineNumber);
    if (rowIndex == null) return; // Invalid line number
    
    if (_highlightedRows.add(rowIndex)) {
      notifyListeners();
    }
  }

  /// Removes highlight from the specified line number (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void unhighlightRow(int lineNumber) {
    final rowIndex = _getRowIndexForLineNumber(lineNumber);
    if (rowIndex == null) return; // Invalid line number
    
    if (_highlightedRows.remove(rowIndex)) {
      notifyListeners();
    }
  }

  /// Toggles the highlight state of the specified line number (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void toggleRowHighlight(int lineNumber) {
    final rowIndex = _getRowIndexForLineNumber(lineNumber);
    if (rowIndex == null) return; // Invalid line number
    
    if (_highlightedRows.contains(rowIndex)) {
      unhighlightRow(lineNumber);
    } else {
      highlightRow(lineNumber);
    }
  }

  /// Highlights multiple line numbers (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void highlightRows(Iterable<int> lineNumbers) {
    bool changed = false;
    for (final lineNumber in lineNumbers) {
      final rowIndex = _getRowIndexForLineNumber(lineNumber);
      if (rowIndex != null) {
        if (_highlightedRows.add(rowIndex)) {
          changed = true;
        }
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Removes highlights from multiple line numbers (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  void unhighlightRows(Iterable<int> lineNumbers) {
    bool changed = false;
    for (final lineNumber in lineNumbers) {
      final rowIndex = _getRowIndexForLineNumber(lineNumber);
      if (rowIndex != null) {
        if (_highlightedRows.remove(rowIndex)) {
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
    final rowIndex = _getRowIndexForLineNumber(lineNumber);
    if (rowIndex == null) return false; // Invalid line number
    
    return _highlightedRows.contains(rowIndex);
  }

  /// Converts a line number (1, 2, 3...) to the corresponding row index (0, 1, 2...).
  /// 
  /// Line numbers are what users see displayed on the UI, while row indices
  /// are internal array positions. This method skips free drawing spaces and
  /// image rows when counting line numbers.
  /// 
  /// Returns null if the line number doesn't exist or is invalid.
  int? _getRowIndexForLineNumber(int lineNumber) {
    if (lineNumber < 1) return null; // Line numbers start at 1
    
    int sequentialLineNumber = 1;
    
    for (var i = 0; i < _rows.length; i++) {
      final row = _rows[i];
      final currentRowY = row.startY;
      final freeSpace = getFreeDrawingSpaceAt(currentRowY);
      final imageRow = getImageRowAt(currentRowY);
      
      // Skip rows that are within free drawing spaces or image rows
      if (freeSpace != null || imageRow != null) {
        continue;
      }
      
      // This is a regular text row with a line number
      if (sequentialLineNumber == lineNumber) {
        return i; // Return the row index
      }
      sequentialLineNumber++;
    }
    
    return null; // Line number not found
  }

  // Note: Free drawing space undo/redo is handled through the sketch operations
  // Since all free space operations trigger sketch modifications with addToUndoHistory: true,
  // the undo/redo functionality works through the existing sketch history system.

  /// Map to store free drawing spaces for each sketch state
  final Map<Sketch, List<FreeDrawingSpace>> _sketchToSpacesMap = {};

  /// Map to store image rows for each sketch state
  final Map<Sketch, List<ImageRow>> _sketchToImageRowsMap = {};

  @override
  void setSketch({required Sketch sketch, bool addToUndoHistory = true}) {
    if (addToUndoHistory) {
      // Store current free drawing spaces and image rows with current sketch
      _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
      _sketchToImageRowsMap[value.sketch] = List.from(_imageRows);
    }
    super.setSketch(sketch: sketch, addToUndoHistory: addToUndoHistory);
  }

  @override
  ScribbleState transformHistoryValue(
    ScribbleState historyValue,
    ScribbleState currentValue,
  ) {
    // Restore free drawing spaces and image rows when transforming history
    final spaces =
        _sketchToSpacesMap[historyValue.sketch] ?? <FreeDrawingSpace>[];
    final imageRows =
        _sketchToImageRowsMap[historyValue.sketch] ?? <ImageRow>[];
    
    _freeDrawingSpaces.clear();
    _freeDrawingSpaces.addAll(spaces);
    _imageRows.clear();
    _imageRows.addAll(imageRows);

    return super.transformHistoryValue(historyValue, currentValue);
  }

}
