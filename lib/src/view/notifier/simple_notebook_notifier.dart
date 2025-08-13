import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/page/simple_page.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/view/painting/point_to_offset_x.dart';
import 'package:scribble/src/view/simplification/sketch_simplifier.dart';
import 'package:scribble/src/view/state/simple_notebook_state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

/// A simplified notifier that manages a notebook with multiple pages and
/// provides basic scribble functionality.
class SimpleNotebookNotifier extends ValueNotifier<SimpleNotebookState>
    with HistoryValueNotifierMixin<SimpleNotebookState> {
  /// Creates a new simple notebook notifier.
  SimpleNotebookNotifier({
    /// The initial pages to display. If empty, creates a blank A4 page.
    List<SimpleNotebookPage>? pages,

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
          SimpleNotebookState.drawing(
            pages: pages?.isNotEmpty ?? false
                ? pages!
                : [
                    SimpleNotebookPage.blank(
                      id: '0',
                      paperSize: PaperSize.a4,
                    ),
                  ],
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

  /// Returns the current pages.
  List<SimpleNotebookPage> get pages => value.pages;

  /// Returns the current page.
  SimpleNotebookPage get currentPage => value.currentPage;

  /// Returns the current sketch on the active page.
  Sketch get currentSketch => currentPage.sketch;

  /// Returns the paper size of the current page.
  PaperSize get currentPaperSize => currentPage.paperSize;

  /// Returns the current page index.
  int get currentPageIndex => value.currentPageIndex;

  @override
  @protected
  SimpleNotebookState transformHistoryValue(
    SimpleNotebookState newValue,
    SimpleNotebookState currentValue,
  ) {
    return newValue.copyWith(
      activePointerIds: currentValue.activePointerIds,
    );
  }

  /// Sets the drawing mode.
  void setDrawing() {
    if (value is! SimpleNotebookDrawing) {
      value = SimpleNotebookState.drawing(
        pages: value.pages,
        currentPageIndex: value.currentPageIndex,
        selectedColor: value.selectedColor,
        selectedWidth: value.selectedWidth,
        allowedPointersMode: value.allowedPointersMode,
        scaleFactor: value.scaleFactor,
        simplificationTolerance: value.simplificationTolerance,
        zoomLevel: value.zoomLevel,
        panOffset: value.panOffset,
      );
    }
  }

  /// Sets the erasing mode.
  void setErasing() {
    if (value is! SimpleNotebookErasing) {
      value = SimpleNotebookState.erasing(
        pages: value.pages,
        currentPageIndex: value.currentPageIndex,
        selectedWidth: value.selectedWidth,
        allowedPointersMode: value.allowedPointersMode,
        scaleFactor: value.scaleFactor,
        simplificationTolerance: value.simplificationTolerance,
        zoomLevel: value.zoomLevel,
        panOffset: value.panOffset,
      );
    }
  }

  /// Sets the color of the pen.
  void setColor(Color color) {
    value = value.copyWith(selectedColor: color.toARGB32());
  }

  /// Sets the width of the pen.
  void setStrokeWidth(double width) {
    value = value.copyWith(selectedWidth: width);
  }

  /// Sets the allowed pointers mode.
  void setAllowedPointersMode(ScribblePointerMode mode) {
    value = value.copyWith(allowedPointersMode: mode);
  }

  /// Adds a new blank page to the notebook.
  void addPage({PaperSize? paperSize}) {
    final newPage = SimpleNotebookPage.blank(
      id: '${pages.length}',
      paperSize: paperSize ?? PaperSize.a4,
    );
    value = value.copyWith(pages: [...pages, newPage]);
  }

  /// Removes a page at the specified index.
  void removePage(int index) {
    if (pages.length <= 1 || index < 0 || index >= pages.length) return;

    final newPages = List<SimpleNotebookPage>.from(pages)
      ..removeAt(index);

    var newCurrentIndex = value.currentPageIndex;
    if (index <= newCurrentIndex && newCurrentIndex > 0) {
      newCurrentIndex--;
    } else if (newCurrentIndex >= newPages.length) {
      newCurrentIndex = newPages.length - 1;
    }

    value = value.copyWith(
      pages: newPages,
      currentPageIndex: newCurrentIndex,
    );
  }

  /// Sets the current page index.
  void setCurrentPageIndex(int index) {
    if (index >= 0 && index < pages.length) {
      // Clear any active line when switching pages to prevent
      // strokes from appearing on the new page
      if (value is SimpleNotebookDrawing) {
        value = (value as SimpleNotebookDrawing).copyWith(
          currentPageIndex: index,
          activeLine: null,
        );
      } else {
        value = value.copyWith(currentPageIndex: index);
      }
    }
  }

  /// Clears the current page.
  void clear() {
    final updatedPages = List<SimpleNotebookPage>.from(pages);
    updatedPages[currentPageIndex] = currentPage.copyWith(
      sketch: const Sketch(lines: []),
    );
    value = value.copyWith(pages: updatedPages);
  }

  /// Clears all pages.
  void clearAll() {
    final clearedPages = pages
        .map((page) => page.copyWith(sketch: const Sketch(lines: [])))
        .toList();
    value = value.copyWith(pages: clearedPages);
  }

  /// Handles pointer down events.
  void onPointerDown(PointerDownEvent details) {
    if (!value.supportedPointerKinds.contains(details.kind)) return;
    if (!value.active) return;

    final localPosition = details.localPosition;
    final pressure = details.pressure.isNaN ? 0.5 : details.pressure;

    final point = Point(
      localPosition.dx,
      localPosition.dy,
      pressure: pressure,
    );

    value = value.copyWith(
      activePointerIds: [...value.activePointerIds, details.pointer],
      pointerPosition: point,
    );

    if (value is SimpleNotebookDrawing) {
      final line = SketchLine(
        points: [point],
        color: value.selectedColor,
        width: value.selectedWidth,
      );
      value = (value as SimpleNotebookDrawing).copyWith(activeLine: line);
    }
  }

  /// Handles pointer move events.
  void onPointerMove(PointerMoveEvent details) {
    if (!value.activePointerIds.contains(details.pointer)) return;

    final localPosition = details.localPosition;
    final pressure = details.pressure.isNaN ? 0.5 : details.pressure;

    final point = Point(
      localPosition.dx,
      localPosition.dy,
      pressure: pressure,
    );

    value = value.copyWith(pointerPosition: point);

    if (value is SimpleNotebookDrawing) {
      final drawing = value as SimpleNotebookDrawing;
      if (drawing.activeLine != null) {
        final updatedLine = drawing.activeLine!.copyWith(
          points: [...drawing.activeLine!.points, point],
        );
        value = (value as SimpleNotebookDrawing).copyWith(
            activeLine: updatedLine,);
      }
    }
  }

  /// Handles pointer up events.
  void onPointerUp(PointerUpEvent details) {
    if (!value.activePointerIds.contains(details.pointer)) return;

    final activePointers = value.activePointerIds
        .where((id) => id != details.pointer)
        .toList();

    if (value is SimpleNotebookDrawing) {
      final drawing = value as SimpleNotebookDrawing;
      if (drawing.activeLine != null) {
        final simplifiedLine = simplifier.simplify(
          drawing.activeLine!,
          pixelTolerance: value.simplificationTolerance,
        );

        final updatedPages = List<SimpleNotebookPage>.from(pages);
        final currentPageSketch = currentPage.sketch;
        final updatedSketch = currentPageSketch.copyWith(
          lines: [...currentPageSketch.lines, simplifiedLine],
        );
        updatedPages[currentPageIndex] = currentPage.copyWith(
          sketch: updatedSketch,
        );

        value = value.copyWith(
          pages: updatedPages,
          activePointerIds: activePointers,
          pointerPosition: null,
        );
      }
    } else if (value is SimpleNotebookErasing) {
      final erasing = value as SimpleNotebookErasing;
      if (erasing.pointerPosition != null) {
        _eraseAtPoint(erasing.pointerPosition!);
      }
      value = value.copyWith(
        activePointerIds: activePointers,
        pointerPosition: null,
      );
    }
  }

  /// Erases lines at the specified point.
  void _eraseAtPoint(Point point) {
    final currentPageSketch = currentPage.sketch;
    final linesToKeep = <SketchLine>[];

    for (final line in currentPageSketch.lines) {
      var shouldErase = false;
      for (final linePoint in line.points) {
        final distance = (point.asOffset - linePoint.asOffset).distance;
        if (distance <= value.selectedWidth) {
          shouldErase = true;
          break;
        }
      }
      if (!shouldErase) {
        linesToKeep.add(line);
      }
    }

    if (linesToKeep.length != currentPageSketch.lines.length) {
      final updatedPages = List<SimpleNotebookPage>.from(pages);
      final updatedSketch = currentPageSketch.copyWith(lines: linesToKeep);
      updatedPages[currentPageIndex] = currentPage.copyWith(
        sketch: updatedSketch,
      );

      value = value.copyWith(pages: updatedPages);
    }
  }

  /// Exports the current page as a PNG image.
  Future<ui.Image?> renderImage() async {
    final renderObject = _repaintBoundaryKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      return renderObject.toImage();
    }
    return null;
  }

  /// Sets auto add pages functionality.
  void setAutoAddPages({required bool enabled, double threshold = 50}) {
    // Implementation can be added here if needed
  }

  /// Sets the zoom level and pan offset.
  void setZoomAndPan({double? zoomLevel, Offset? panOffset}) {
    value = value.copyWith(
      zoomLevel: zoomLevel ?? value.zoomLevel,
      panOffset: panOffset ?? value.panOffset,
    );
  }

}
