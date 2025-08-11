import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/notebook/notebook.dart';

part 'notebook_state.freezed.dart';

/// Represents the state of a notebook with multiple pages.
@freezed
sealed class NotebookState with _$NotebookState {
  /// Drawing state for the notebook.
  const factory NotebookState.drawing({
    /// The current notebook with multiple pages
    required Notebook notebook,

    /// The line that is currently being drawn
    SketchLine? activeLine,

    /// Which pointers are allowed for drawing and will be captured
    @Default(ScribblePointerMode.all) ScribblePointerMode allowedPointersMode,

    /// The ids of all supported pointers that are currently interacting
    @Default([]) List<int> activePointerIds,

    /// The current position of the pointer
    Point? pointerPosition,

    /// The color that is currently being drawn with
    @Default(0xFF000000) int selectedColor,

    /// The current width of the pen
    @Default(5) double selectedWidth,

    /// How much the widget is scaled at the moment
    @Default(1) double scaleFactor,

    /// The current tolerance of simplification, in pixels
    @Default(0) double simplificationTolerance,

    /// The visual zoom level of the canvas (separate from scaleFactor)
    @Default(1) double zoomLevel,

    /// The pan offset for the canvas when zoomed
    @Default(Offset.zero) Offset panOffset,

    /// The currently active row index for line-by-line constraint mode
    @Default(0) int activeRowIndex,
  }) = NotebookDrawing;

  /// Erasing state for the notebook.
  const factory NotebookState.erasing({
    /// The current notebook with multiple pages
    required Notebook notebook,

    /// Which pointers are allowed for drawing and will be captured
    @Default(ScribblePointerMode.all) ScribblePointerMode allowedPointersMode,

    /// The ids of all supported pointers that are currently interacting
    @Default([]) List<int> activePointerIds,

    /// The current position of the pointer
    Point? pointerPosition,

    /// The current width of the pen
    @Default(5) double selectedWidth,

    /// How much the widget is scaled at the moment
    @Default(1) double scaleFactor,

    /// The current tolerance of simplification, in pixels
    @Default(0) double simplificationTolerance,

    /// The visual zoom level of the canvas (separate from scaleFactor)
    @Default(1) double zoomLevel,

    /// The pan offset for the canvas when zoomed
    @Default(Offset.zero) Offset panOffset,

    /// The currently active row index for line-by-line constraint mode
    @Default(0) int activeRowIndex,
  }) = NotebookErasing;

  const NotebookState._();

  /// Returns the current sketch from the active page.
  Sketch get currentSketch => notebook.currentPage.sketch;

  /// Returns true if there are active pointers on the screen.
  bool get active => activePointerIds.length <= 1;

  /// Returns the supported pointer kinds based on the allowed pointers mode.
  Set<PointerDeviceKind> get supportedPointerKinds {
    switch (allowedPointersMode) {
      case ScribblePointerMode.all:
        return Set.from(PointerDeviceKind.values);
      case ScribblePointerMode.mouseOnly:
        return const {PointerDeviceKind.mouse};
      case ScribblePointerMode.penOnly:
        return const {
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
        };
      case ScribblePointerMode.mouseAndPen:
        return const {
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
        };
    }
  }

  /// Returns the list of lines that should be drawn on the canvas.
  List<SketchLine> get lines => map(
        drawing: (d) => d.activeLine == null
            ? currentSketch.lines
            : [...currentSketch.lines, d.activeLine!],
        erasing: (d) => d.currentSketch.lines,
      );
}
