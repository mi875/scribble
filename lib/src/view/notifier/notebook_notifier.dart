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
    temporaryValue = value.copyWith(zoomLevel: zoomLevel);
  }

  /// Sets the pan offset for the canvas.
  void setPanOffset(Offset panOffset) {
    temporaryValue = value.copyWith(panOffset: panOffset);
  }

  /// Sets the color of the pen.
  void setColor(Color color) {
    temporaryValue = value.map(
      drawing: (s) => NotebookState.drawing(
        notebook: s.notebook,
        selectedColor: color.value,
        selectedWidth: s.selectedWidth,
        allowedPointersMode: s.allowedPointersMode,
        scaleFactor: s.scaleFactor,
        zoomLevel: s.zoomLevel,
        panOffset: s.panOffset,
      ),
      erasing: (s) => NotebookState.drawing(
        notebook: s.notebook,
        selectedColor: color.value,
        selectedWidth: s.selectedWidth,
        allowedPointersMode: s.allowedPointersMode,
        scaleFactor: s.scaleFactor,
        activePointerIds: s.activePointerIds,
        zoomLevel: s.zoomLevel,
        panOffset: s.panOffset,
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
          width: value.selectedWidth / value.scaleFactor,
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
    if (value is NotebookDrawing) {
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
