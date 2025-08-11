import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/notebook/notebook.dart';
import 'package:scribble/src/domain/model/page/page.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/view/painting/point_to_offset_x.dart';
import 'package:scribble/src/view/scrollable_notebook_canvas.dart';
import 'package:scribble/src/view/simplification/sketch_simplifier.dart';
import 'package:scribble/src/view/state/notebook_state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

/// A notifier that manages a notebook with multiple pages and provides
/// scribble functionality for the current page.
class NotebookNotifier extends ValueNotifier<NotebookState>
    with HistoryValueNotifierMixin<NotebookState> {
  /// Creates a new notebook notifier.
  NotebookNotifier({
    /// The initial notebook to display. If null, creates a blank A4 notebook.
    Notebook? notebook,

    /// Which pointers can be drawn with and are captured.
    ScribblePointerMode allowedPointersMode = ScribblePointerMode.all,

    /// How many states you want stored in the undo history, 30 by default.
    int maxHistoryLength = 30,
    this.widths = const [5, 10, 15],
    this.pressureCurve = Curves.linear,
    this.simplifier = const VisvalingamSimplifier(),

    /// The simplification tolerance for sketch lines.
    double simplificationTolerance = 0,
  }) : super(
          NotebookState.drawing(
            notebook: notebook ??
                Notebook.blank(
                  id: 'notebook_${DateTime.now().millisecondsSinceEpoch}',
                  paperSize: PaperSize.a4,
                ),
            selectedWidth: widths[0],
            allowedPointersMode: allowedPointersMode,
            simplificationTolerance: simplificationTolerance,
          ),
        ) {
    this.maxHistoryLength = maxHistoryLength;
  }

  /// The supported widths for drawing.
  final List<double> widths;

  /// The curve used to map pen pressure.
  final Curve pressureCurve;

  /// The sketch simplifier used to simplify lines.
  final SketchSimplifier simplifier;

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  /// Whether to automatically add pages when writing near the bottom.
  bool _autoAddPages = false;

  /// Distance from bottom edge that triggers new page creation.
  double _bottomMarginThreshold = 50.0;

  /// Current row constraint mode for controlling writing behavior.
  RowConstraintMode _rowConstraintMode = RowConstraintMode.none;

  /// Row line spacing used for constraint calculations.
  double _rowLineSpacing = 24.0;

  /// Top margin used for constraint calculations.
  double _topMargin = 30.0;

  /// The repaint boundary key for accessing the render object.
  GlobalKey get repaintBoundaryKey => _repaintBoundaryKey;

  /// Returns the current notebook.
  Notebook get currentNotebook => value.notebook;

  /// Returns the current page.
  NotebookPage get currentPage => value.notebook.currentPage;

  /// Returns the current sketch on the active page.
  Sketch get currentSketch => currentPage.sketch;

  /// Returns the paper size of the current page.
  PaperSize get currentPaperSize => currentPage.paperSize;

  @override
  @protected
  NotebookState transformHistoryValue(
    NotebookState newValue,
    NotebookState currentValue,
  ) {
    return currentValue.copyWith(
      notebook: newValue.notebook,
    );
  }

  /// Updates the current page's sketch.
  void _updateCurrentPageSketch(Sketch sketch) {
    final updatedPage = currentPage.copyWith(sketch: sketch);
    final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
    temporaryValue = value.copyWith(notebook: updatedNotebook);
  }

  /// Sets the notebook to a new notebook.
  void setNotebook({
    required Notebook notebook,
    bool addToUndoHistory = true,
  }) {
    final newState = value.copyWith(notebook: notebook);
    if (addToUndoHistory) {
      value = newState;
    } else {
      temporaryValue = newState;
    }
  }

  /// Goes to the next page in the notebook.
  void nextPage() {
    if (!currentNotebook.isLastPage) {
      temporaryValue = value.copyWith(
        notebook: currentNotebook.nextPage(),
      );
    }
  }

  /// Goes to the previous page in the notebook.
  void previousPage() {
    if (!currentNotebook.isFirstPage) {
      temporaryValue = value.copyWith(
        notebook: currentNotebook.previousPage(),
      );
    }
  }

  /// Goes to the page at the specified index.
  void goToPage(int pageIndex) {
    try {
      temporaryValue = value.copyWith(
        notebook: currentNotebook.goToPage(pageIndex),
      );
    } catch (e) {
      // Index out of bounds, ignore
    }
  }

  /// Adds a new blank page to the notebook.
  void addPage({
    PaperSize? paperSize,
    int? index,
  }) {
    final newPage = NotebookPage.blank(
      id: '${currentNotebook.id}_page_${DateTime.now().millisecondsSinceEpoch}',
      paperSize: paperSize ?? currentPaperSize,
    );

    value = value.copyWith(
      notebook: currentNotebook.addPage(newPage, index: index),
    );
  }

  /// Checks if writing is near the bottom of the current page and adds a new page if needed.
  void _checkAndAddPageIfNeeded(Offset writingPosition, double bottomThreshold) {
    final paperSize = currentPaperSize;
    final distanceFromBottom = paperSize.height - writingPosition.dy;
    
    // If writing within threshold distance from bottom and we're on the last page
    if (distanceFromBottom <= bottomThreshold && currentNotebook.isLastPage) {
      addPage(paperSize: paperSize);
    }
  }

  /// Removes the page at the specified index.
  void removePage(int index) {
    try {
      value = value.copyWith(
        notebook: currentNotebook.removePage(index),
      );
    } catch (e) {
      // Cannot remove or index out of bounds, ignore
    }
  }

  /// Clears the current page.
  void clearCurrentPage() {
    final updatedPage = currentPage.copyWith(sketch: const Sketch(lines: []));
    final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
    value = value.copyWith(notebook: updatedNotebook);
  }

  /// Deletes a row and moves all content below it up by one row spacing.
  void deleteRow(int rowIndex, {double? rowLineSpacing, double? topMargin}) {
    final spacing = rowLineSpacing ?? 24.0;
    final margin = topMargin ?? 30.0;
    
    // Calculate the Y bounds for this row
    final rowTop = margin + (rowIndex * spacing);
    final rowBottom = rowTop + spacing;
    
    final currentSketch = currentPage.sketch;
    
    // Process all lines
    final newLines = <SketchLine>[];
    
    for (final line in currentSketch.lines) {
      // Check if line has any points in the deleted row
      final hasPointsInDeletedRow = line.points.any((point) => 
        point.y >= rowTop && point.y < rowBottom,
      );
      
      if (hasPointsInDeletedRow) {
        // Skip lines that are in the deleted row
        continue;
      }
      
      // Check if line is below the deleted row
      final hasPointsBelowDeletedRow = line.points.any((point) => 
        point.y >= rowBottom,
      );
      
      if (hasPointsBelowDeletedRow) {
        // Move this line up by one row spacing
        final movedPoints = line.points.map((point) {
          return point.y >= rowBottom 
              ? Point(point.x, point.y - spacing, pressure: point.pressure)
              : point;
        }).toList();
        
        newLines.add(line.copyWith(points: movedPoints));
      } else {
        // Keep lines above the deleted row unchanged
        newLines.add(line);
      }
    }
    
    // Only update if there are changes
    if (newLines.length != currentSketch.lines.length || 
        newLines.any((newLine) {
          final originalLine = currentSketch.lines.firstWhere(
            (orig) => orig.color == newLine.color && orig.width == newLine.width,
            orElse: () => newLine,
          );
          return originalLine != newLine;
        })) {
      final newSketch = currentSketch.copyWith(lines: newLines);
      final updatedPage = currentPage.copyWith(sketch: newSketch);
      final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
      
      // Use the main value setter to ensure proper state management and history
      value = value.copyWith(notebook: updatedNotebook);
    }
  }

  /// Deletes a row with animation by gradually moving content up.
  Future<void> deleteRowAnimated(
    int rowIndex, {
    double? rowLineSpacing,
    double? topMargin,
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    final spacing = rowLineSpacing ?? 24.0;
    final margin = topMargin ?? 30.0;
    
    // Calculate the Y bounds for this row
    final rowTop = margin + (rowIndex * spacing);
    final rowBottom = rowTop + spacing;
    
    final currentSketch = currentPage.sketch;
    
    // First, identify lines that will be affected
    final linesToDelete = <SketchLine>[];
    final linesToMove = <SketchLine>[];
    final linesToKeep = <SketchLine>[];
    
    for (final line in currentSketch.lines) {
      final hasPointsInDeletedRow = line.points.any((point) => 
        point.y >= rowTop && point.y < rowBottom,
      );
      
      final hasPointsBelowDeletedRow = line.points.any((point) => 
        point.y >= rowBottom,
      );
      
      if (hasPointsInDeletedRow) {
        linesToDelete.add(line);
      } else if (hasPointsBelowDeletedRow) {
        linesToMove.add(line);
      } else {
        linesToKeep.add(line);
      }
    }
    
    // If no changes needed, return early
    if (linesToDelete.isEmpty && linesToMove.isEmpty) return;
    
    // Animate the movement over several frames
    const int animationSteps = 15;
    const stepDelay = Duration(milliseconds: 20);
    
    for (int step = 0; step < animationSteps; step++) {
      final progress = (step + 1) / animationSteps;
      final currentOffset = spacing * progress;
      
      // Create the animated frame
      final animatedLines = <SketchLine>[
        ...linesToKeep, // Keep lines above unchanged
        // Move lines below gradually
        ...linesToMove.map((line) {
          final movedPoints = line.points.map((point) {
            return point.y >= rowBottom 
                ? Point(point.x, point.y - currentOffset, pressure: point.pressure)
                : point;
          }).toList();
          return line.copyWith(points: movedPoints);
        }),
      ];
      
      // Update the sketch with the current animation frame
      final animatedSketch = currentSketch.copyWith(lines: animatedLines);
      final updatedPage = currentPage.copyWith(sketch: animatedSketch);
      final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
      
      // Use temporaryValue for intermediate animation frames
      temporaryValue = value.copyWith(notebook: updatedNotebook);
      
      // Wait for next frame
      if (step < animationSteps - 1) {
        await Future.delayed(stepDelay);
      }
    }
    
    // Set the final state and save to history
    final finalLines = <SketchLine>[
      ...linesToKeep,
      ...linesToMove.map((line) {
        final movedPoints = line.points.map((point) {
          return point.y >= rowBottom 
              ? Point(point.x, point.y - spacing, pressure: point.pressure)
              : point;
        }).toList();
        return line.copyWith(points: movedPoints);
      }),
    ];
    
    final finalSketch = currentSketch.copyWith(lines: finalLines);
    final finalPage = currentPage.copyWith(sketch: finalSketch);
    final finalNotebook = currentNotebook.updateCurrentPage(finalPage);
    
    // Save to history
    value = value.copyWith(notebook: finalNotebook);
  }

  /// Erases all content within a specific row range on the current page (legacy method).
  void eraseRow(int rowIndex, {double? rowLineSpacing, double? topMargin}) {
    // For backward compatibility, call deleteRow
    deleteRow(rowIndex, rowLineSpacing: rowLineSpacing, topMargin: topMargin);
  }

  /// Sets the width of the next line.
  void setStrokeWidth(double strokeWidth) {
    temporaryValue = value.copyWith(selectedWidth: strokeWidth);
  }

  /// Switches to eraser mode.
  void setEraser() {
    temporaryValue = NotebookState.erasing(
      notebook: value.notebook,
      selectedWidth: value.selectedWidth,
      scaleFactor: value.scaleFactor,
      allowedPointersMode: value.allowedPointersMode,
      activePointerIds: value.activePointerIds,
      zoomLevel: value.zoomLevel,
      panOffset: value.panOffset,
      activeRowIndex: value.activeRowIndex,
    );
  }

  /// Sets the current mode of allowed pointers.
  void setAllowedPointersMode(ScribblePointerMode allowedPointersMode) {
    temporaryValue = value.copyWith(
      allowedPointersMode: allowedPointersMode,
    );
  }

  /// Sets the internal scale factor for line width adjustments.
  void setScaleFactor(double factor) {
    assert(factor > 0, "The scale factor must be greater than 0.");
    temporaryValue = value.copyWith(scaleFactor: factor);
  }

  /// Sets the visual zoom level of the canvas.
  void setZoomLevel(double zoomLevel) {
    assert(zoomLevel > 0, "The zoom level must be greater than 0.");
    temporaryValue = value.copyWith(
      zoomLevel: zoomLevel,
      scaleFactor: zoomLevel,
    );
  }

  /// Sets the pan offset for the canvas.
  void setPanOffset(Offset panOffset) {
    temporaryValue = value.copyWith(panOffset: panOffset);
  }

  /// Enables or disables automatic page addition.
  void setAutoAddPages(bool enabled, {double? bottomThreshold}) {
    _autoAddPages = enabled;
    if (bottomThreshold != null) {
      _bottomMarginThreshold = bottomThreshold;
    }
  }

  /// Sets the row constraint mode and related parameters.
  void setRowConstraintMode(
    RowConstraintMode mode, {
    double? rowLineSpacing,
    double? topMargin,
  }) {
    _rowConstraintMode = mode;
    if (rowLineSpacing != null) {
      _rowLineSpacing = rowLineSpacing;
    }
    if (topMargin != null) {
      _topMargin = topMargin;
    }
  }

  /// Sets the active row index.
  void setActiveRow(int rowIndex) {
    temporaryValue = value.copyWith(activeRowIndex: rowIndex);
  }

  /// Advances to the next row.
  void nextRow() {
    temporaryValue = value.copyWith(activeRowIndex: value.activeRowIndex + 1);
  }

  /// Goes to the previous row.
  void previousRow() {
    if (value.activeRowIndex > 0) {
      temporaryValue = value.copyWith(activeRowIndex: value.activeRowIndex - 1);
    }
  }

  /// Returns the bounds of the current active row.
  Rect getCurrentRowBounds() {
    final rowIndex = value.activeRowIndex;
    final rowTop = _topMargin + (rowIndex * _rowLineSpacing);
    final rowBottom = rowTop + _rowLineSpacing;
    return Rect.fromLTRB(0, rowTop, currentPaperSize.width, rowBottom);
  }

  /// Checks if a drawing position is allowed based on the current constraint mode.
  bool isPositionAllowed(Offset position) {
    switch (_rowConstraintMode) {
      case RowConstraintMode.none:
        return true;
      case RowConstraintMode.current:
        final rowBounds = getCurrentRowBounds();
        return rowBounds.contains(position);
      case RowConstraintMode.sequential:
        final rowIndex = value.activeRowIndex;
        final maxAllowedRow = _findLastRowWithContent() + 1;
        final positionRowIndex = ((position.dy - _topMargin) / _rowLineSpacing).floor();
        return positionRowIndex <= maxAllowedRow && positionRowIndex >= 0;
    }
  }

  /// Finds the last row that has content on the current page.
  int _findLastRowWithContent() {
    var lastRowWithContent = -1;
    
    for (final line in currentSketch.lines) {
      for (final point in line.points) {
        final rowIndex = ((point.y - _topMargin) / _rowLineSpacing).floor();
        if (rowIndex > lastRowWithContent) {
          lastRowWithContent = rowIndex;
        }
      }
    }
    
    return lastRowWithContent;
  }

  /// Auto-advances to the next row if the current row has content.
  void _autoAdvanceRowIfNeeded() {
    if (_rowConstraintMode == RowConstraintMode.current) {
      final currentRowBounds = getCurrentRowBounds();
      final hasContentInCurrentRow = currentSketch.lines.any(
        (line) => line.points.any(
          (point) => currentRowBounds.contains(Offset(point.x, point.y)),
        ),
      );
      
      if (hasContentInCurrentRow) {
        // Small delay to allow the current drawing to finish
        Future.delayed(const Duration(milliseconds: 100), () {
          nextRow();
        });
      }
    }
  }

  /// Sets the color of the pen.
  void setColor(Color color) {
    temporaryValue = value.map(
      drawing: (s) => NotebookState.drawing(
        notebook: s.notebook,
        selectedColor: color.toARGB32(),
        selectedWidth: s.selectedWidth,
        allowedPointersMode: s.allowedPointersMode,
        scaleFactor: s.scaleFactor,
        zoomLevel: s.zoomLevel,
        panOffset: s.panOffset,
        activeRowIndex: s.activeRowIndex,
      ),
      erasing: (s) => NotebookState.drawing(
        notebook: s.notebook,
        selectedColor: color.toARGB32(),
        selectedWidth: s.selectedWidth,
        allowedPointersMode: s.allowedPointersMode,
        scaleFactor: s.scaleFactor,
        activePointerIds: s.activePointerIds,
        zoomLevel: s.zoomLevel,
        panOffset: s.panOffset,
        activeRowIndex: s.activeRowIndex,
      ),
    );
  }

  /// Sets the simplification tolerance.
  void setSimplificationTolerance(double degree) {
    temporaryValue = value.copyWith(simplificationTolerance: degree);
  }

  /// Simplifies the current page's sketch.
  void simplify({bool addToUndoHistory = true}) {
    final newSketch = simplifier.simplifySketch(
      currentSketch,
      pixelTolerance: value.simplificationTolerance,
    );
    final updatedPage = currentPage.copyWith(sketch: newSketch);
    final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
    final newState = value.copyWith(notebook: updatedNotebook);

    if (addToUndoHistory) {
      value = newState;
    } else {
      temporaryValue = newState;
    }
  }

  /// Used to render the image to ByteData for the current page.
  Future<ByteData> renderImage({
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final renderObject = repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (renderObject == null) {
      throw StateError(
        "Tried to convert Notebook page to Image, but no valid RenderObject "
        "was found!",
      );
    }
    final img = await renderObject.toImage(pixelRatio: pixelRatio);
    return (await img.toByteData(format: format))!;
  }

  /// Pointer event handlers.
  void onPointerHover(PointerHoverEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    temporaryValue = value.copyWith(
      pointerPosition:
          event.distance > 10000 ? null : _getPointFromEvent(event),
    );
  }

  /// Handles pointer down events to start drawing.
  void onPointerDown(PointerDownEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    
    // Check if this position is allowed based on constraint mode
    if (!isPositionAllowed(event.localPosition)) {
      return; // Ignore the event if position is not allowed
    }
    
    var s = value;

    if (value.activePointerIds.isNotEmpty) {
      s = value.map(
        drawing: (s) =>
            (s.activeLine != null && s.activeLine!.points.length > 2)
                ? _finishLineForState(s)
                : s.copyWith(activeLine: null),
        erasing: (s) => s,
      );
    } else if (value is NotebookDrawing) {
      s = (value as NotebookDrawing).copyWith(
        pointerPosition: _getPointFromEvent(event),
        activeLine: SketchLine(
          points: [_getPointFromEvent(event)],
          color: (value as NotebookDrawing).selectedColor,
          width: value.selectedWidth,
        ),
      );
    }
    temporaryValue = s.copyWith(
      activePointerIds: [...value.activePointerIds, event.pointer],
    );
  }

  /// Handles pointer move events during drawing.
  void onPointerUpdate(PointerMoveEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    if (!value.active) {
      temporaryValue = value.copyWith(pointerPosition: null);
      return;
    }
    
    // Check if this position is allowed based on constraint mode
    if (!isPositionAllowed(event.localPosition)) {
      return; // Ignore the event if position is not allowed
    }
    
    if (value is NotebookDrawing) {
      // Check if we need to add a new page when drawing near the bottom
      if (_autoAddPages) {
        _checkAndAddPageIfNeeded(event.localPosition, _bottomMarginThreshold);
      }
      
      temporaryValue = _addPoint(event, value).copyWith(
        pointerPosition: _getPointFromEvent(event),
      );
    } else if (value is NotebookErasing) {
      temporaryValue = _erasePoint(event).copyWith(
        pointerPosition: _getPointFromEvent(event),
      );
    }
  }

  /// Handles pointer up events to finish drawing.
  void onPointerUp(PointerUpEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    final pos =
        event.kind == PointerDeviceKind.mouse ? value.pointerPosition : null;
    if (value is NotebookDrawing) {
      value = _finishLineForState(_addPoint(event, value)).copyWith(
        pointerPosition: pos,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
      
      // Auto-advance to next row if needed
      _autoAdvanceRowIfNeeded();
    } else if (value is NotebookErasing) {
      value = _erasePoint(event).copyWith(
        pointerPosition: pos,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    }
  }

  /// Handles pointer cancel events.
  void onPointerCancel(PointerCancelEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    if (value is NotebookDrawing) {
      value = _finishLineForState(_addPoint(event, value)).copyWith(
        pointerPosition: null,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    } else if (value is NotebookErasing) {
      value = _erasePoint(event).copyWith(
        pointerPosition: null,
        activePointerIds:
            value.activePointerIds.where((id) => id != event.pointer).toList(),
      );
    }
  }

  /// Handles pointer exit events.
  void onPointerExit(PointerExitEvent event) {
    if (!value.supportedPointerKinds.contains(event.kind)) return;
    temporaryValue = _finishLineForState(value).copyWith(
      pointerPosition: null,
      activePointerIds:
          value.activePointerIds.where((id) => id != event.pointer).toList(),
    );
  }

  NotebookState _addPoint(PointerEvent event, NotebookState s) {
    if (s is NotebookErasing || !s.active) return s;
    if (s is NotebookDrawing && s.activeLine == null) return s;
    final currentLine = (s as NotebookDrawing).activeLine!;
    final distanceToLast = currentLine.points.isEmpty
        ? double.infinity
        : (currentLine.points.last.asOffset - event.localPosition).distance;
    if (distanceToLast <= kPrecisePointerPanSlop / s.scaleFactor) return s;
    return s.copyWith(
      activeLine: currentLine.copyWith(
        points: [
          ...currentLine.points,
          _getPointFromEvent(event),
        ],
      ),
    );
  }

  NotebookState _erasePoint(PointerEvent event) {
    final currentSketch = currentPage.sketch;
    final newSketch = currentSketch.copyWith(
      lines: currentSketch.lines
          .where(
            (l) => l.points.every(
              (p) =>
                  (event.localPosition - p.asOffset).distance >
                  l.width + value.selectedWidth,
            ),
          )
          .toList(),
    );
    final updatedPage = currentPage.copyWith(sketch: newSketch);
    final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
    final newState = value.copyWith(notebook: updatedNotebook);
    temporaryValue = newState;
    return newState;
  }

  Point _getPointFromEvent(PointerEvent event) {
    final p = kIsWeb || event.pressureMin == event.pressureMax
        ? 0.5
        : (event.pressure - event.pressureMin) /
            (event.pressureMax - event.pressureMin);
    return Point(
      event.localPosition.dx,
      event.localPosition.dy,
      pressure: pressureCurve.transform(p),
    );
  }

  NotebookState _finishLineForState(NotebookState s) {
    if (s case NotebookDrawing(activeLine: final activeLine?)) {
      final currentSketch = currentPage.sketch;
      final newSketch = currentSketch.copyWith(
        lines: [
          ...currentSketch.lines,
          simplifier.simplify(
            activeLine,
            pixelTolerance: s.simplificationTolerance,
          ),
        ],
      );
      final updatedPage = currentPage.copyWith(sketch: newSketch);
      final updatedNotebook = currentNotebook.updateCurrentPage(updatedPage);
      final newState = value.copyWith(notebook: updatedNotebook);
      temporaryValue = newState;
      return (newState as NotebookDrawing).copyWith(activeLine: null);
    }
    return s;
  }
}
