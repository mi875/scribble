import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/notifier/scribble_notifier.dart';
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
  }) : _rowLineSpacing = rowLineSpacing,
       _topMargin = topMargin,
       _bottomMargin = bottomMargin,
       _canvasHeight = initialCanvasHeight;

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

  /// Sets the callback for canvas height changes.
  void setCanvasHeightChangeCallback(void Function(double newHeight)? callback) {
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
    final requiredHeight = _topMargin + (requiredRows * _rowLineSpacing) + _bottomMargin;
    
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

  @override
  void onPointerDown(PointerDownEvent event) {
    final position = event.localPosition;
    
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
    final contentLineIndex = ((maxContentY - _topMargin) / _rowLineSpacing).floor();
    
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
}
