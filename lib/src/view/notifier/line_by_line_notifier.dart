import 'package:flutter/widgets.dart';
import 'package:scribble/scribble.dart';
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
        _freeDrawingSpaces = [];

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

  /// List of free drawing spaces (line-free regions).
  final List<FreeDrawingSpace> _freeDrawingSpaces;

  /// Gets an immutable list of free drawing spaces.
  List<FreeDrawingSpace> get freeDrawingSpaces =>
      List.unmodifiable(_freeDrawingSpaces);

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
      _onCanvasHeightChanged?.call(height);
    }
  }

  /// Sets the canvas width for bounds checking.
  void setCanvasWidth(double width) {
    _canvasWidth = width;
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
    final currentRow = ((position.dy - _topMargin) / _rowLineSpacing).floor();
    final maxRow = ((maxContentY - _topMargin) / _rowLineSpacing).floor();

    // Allow drawing on current row or next row only
    return currentRow <= maxRow + 1;
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

    // Calculate which line the content has reached
    final contentLineIndex =
        ((maxContentY - _topMargin) / _rowLineSpacing).floor();

    // Show line numbers progressively: if content reached line N, show numbers 1 through N+2
    if (lineIndex <= contentLineIndex + 2) {
      return 1.0;
    } else {
      return 0.0;
    }
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

    // Allow drawing within current content area plus one extra row
    final allowedMaxY = maxContentY + _rowLineSpacing;

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
    _shiftSketchContentDown(yPosition, spaceHeight);

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

    // Shift all sketch content that is below this position up
    _shiftSketchContentUp(spaceStartY + spaceHeight, spaceHeight);

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
    _shiftSketchContentDown(shiftStartY, additionalHeight);

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
  void _shiftSketchContentDown(double startY, double shiftAmount) {
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
    setSketch(sketch: newSketch, addToUndoHistory: true);
  }

  /// Shifts all sketch content up by the specified amount starting from startY.
  void _shiftSketchContentUp(double startY, double shiftAmount) {
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
    setSketch(sketch: newSketch, addToUndoHistory: true);
  }

  /// Clears all free drawing spaces.
  void clearAllFreeDrawingSpaces() {
    _freeDrawingSpaces.clear();
    notifyListeners();
  }

  // Note: Free drawing space undo/redo is handled through the sketch operations
  // Since all free space operations trigger sketch modifications with addToUndoHistory: true,
  // the undo/redo functionality works through the existing sketch history system.

  /// Map to store free drawing spaces for each sketch state
  final Map<Sketch, List<FreeDrawingSpace>> _sketchToSpacesMap = {};

  @override
  void setSketch({required Sketch sketch, bool addToUndoHistory = true}) {
    if (addToUndoHistory) {
      // Store current free drawing spaces with current sketch
      _sketchToSpacesMap[value.sketch] = List.from(_freeDrawingSpaces);
    }
    super.setSketch(sketch: sketch, addToUndoHistory: addToUndoHistory);
  }

  @override
  ScribbleState transformHistoryValue(
    ScribbleState historyValue,
    ScribbleState currentValue,
  ) {
    // Restore free drawing spaces when transforming history
    final spaces =
        _sketchToSpacesMap[historyValue.sketch] ?? <FreeDrawingSpace>[];
    _freeDrawingSpaces.clear();
    _freeDrawingSpaces.addAll(spaces);

    return super.transformHistoryValue(historyValue, currentValue);
  }
}
