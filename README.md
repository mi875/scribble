# Scribble

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg)](https://github.com/invertase/melos)
![coverage](./coverage.svg)

Scribble is a comprehensive Flutter package for freehand drawing with advanced features including pressure-sensitive drawing, multi-page notebooks, line-by-line writing, and powerful state management.

![Scribble Demo](https://raw.githubusercontent.com/timcreatedit/scribble/main/scribble_demo.gif)

## Table of Contents
- [Installation](#installation-)
- [Features](#features)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
  - [ScribbleNotifier](#scribblenotifier)
  - [LineByLineNotifier](#linebylinenotifier) 
  - [SimpleNotebookNotifier](#simplenotebooknotifier)
  - [State Management](#state-management)
- [Advanced Usage](#advanced-usage)
- [Examples](#examples)
- [Additional Information](#additional-information)

## Installation 💻

**❗ In order to start using Scribble you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add scribble
```

---

## Features

### Core Drawing Features
* **Pressure-sensitive drawing** with configurable pressure curves
* **Variable line width** that responds to drawing speed and pressure
* **Multi-device support** (touch, pen, mouse) with device filtering
* **Line eraser functionality** with line-based erasing
* **Full undo/redo support** using [value_notifier_tools](https://pub.dev/packages/value_notifier_tools)

### Advanced Capabilities
* **Multi-page notebooks** with page management and navigation
* **Line-by-line writing** with dynamic canvas extension
* **Free drawing spaces** and image insertion for mixed content
* **Row highlighting** and sequential writing modes
* **Line simplification** to reduce file sizes and improve performance
* **JSON serialization** for sketch persistence and data exchange
* **PNG export** with configurable resolution and quality
* **Zoom and pan support** with scale factor adjustments

### Developer Experience
* **Domain-driven architecture** with immutable state management
* **Comprehensive API** with three specialized notifier classes
* **Flexible theming** and customization options
* **Extensive test coverage** and documentation

## Quick Start

> **Complete examples:** Check the [example](./example) directory for full working demonstrations including basic drawing, line-by-line writing, and multi-page notebooks.

### Basic Drawing Setup

Create a drawing surface by adding the `Scribble` widget with a `ScribbleNotifier`:

```dart
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scribble Drawing'),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: notifier.canUndo ? notifier.undo : null,
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: notifier.clear,
          ),
        ],
      ),
      body: Scribble(
        notifier: notifier,
        drawPen: true,  // Enable pen input
        simulatePressure: true,  // Simulate pressure for devices without pressure support
      ),
    );
  }
}
```

### Essential Controls

```dart
// Drawing controls
notifier.setColor(Colors.blue);
notifier.setStrokeWidth(5.0);
notifier.setEraser();  // Switch to eraser mode

// Canvas management
notifier.clear();  // Clear all content
notifier.undo();   // Undo last action
notifier.redo();   // Redo last undone action

// Export capabilities
Future<ByteData> imageData = notifier.renderImage(pixelRatio: 2.0);
String jsonData = jsonEncode(notifier.currentSketch.toJson());

// Line simplification
notifier.setSimplificationTolerance(2.0);
notifier.simplify();  // Apply to existing sketch
```

## API Reference

### ScribbleNotifier

The primary controller for basic drawing functionality with undo/redo support.

#### Constructor
```dart
ScribbleNotifier({
  Sketch? sketch,                                     // Initial sketch
  ScribblePointerMode allowedPointersMode = ScribblePointerMode.all,
  int maxHistoryLength = 30,                         // Undo/redo history
  List<double> widths = const [5, 10, 15],          // Available stroke widths
  Curve pressureCurve = Curves.linear,              // Pressure mapping curve
  SketchSimplifier simplifier = const VisvalingamSimplifier(),
  double simplificationTolerance = 0,                // Line simplification
})
```

#### Drawing State Management
```dart
// Drawing controls
void setColor(Color color)                         // Set pen color
void setStrokeWidth(double strokeWidth)            // Set pen width
void setEraser()                                   // Switch to eraser mode
void clear()                                       // Clear all content

// Canvas state
void setSketch({required Sketch sketch, bool addToUndoHistory = true})
void setAllowedPointersMode(ScribblePointerMode mode)  // Control input devices
void setScaleFactor(double factor)                 // Adjust for zoom levels

// Line simplification
void setSimplificationTolerance(double degree)    // Set simplification threshold
void simplify({bool addToUndoHistory = true})     // Apply to existing lines
```

#### Undo/Redo Operations
```dart
bool get canUndo                                   // Check if undo is available
bool get canRedo                                   // Check if redo is available
void undo()                                        // Undo last action
void redo()                                        // Redo last undone action
```

#### Export Capabilities
```dart
Future<ByteData> renderImage({
  double pixelRatio = 1.0,
  ui.ImageByteFormat format = ui.ImageByteFormat.png
})                                                 // Export as image

Sketch get currentSketch                           // Get current sketch for JSON export
```

#### Properties
```dart
GlobalKey get repaintBoundaryKey                   // Access render boundary
List<double> get widths                            // Available stroke widths
Curve get pressureCurve                            // Pressure to width mapping
```

### LineByLineNotifier

Advanced drawing controller with line-by-line writing, dynamic canvas extension, and region management.

#### Constructor
```dart
LineByLineNotifier({
  // Inherits all ScribbleNotifier parameters plus:
  double rowLineSpacing = 24.0,                    // Line spacing
  double topMargin = 30.0,                         // Top margin
  double bottomMargin = 60.0,                      // Bottom margin buffer
  double initialCanvasHeight = 400.0,              // Starting height
})
```

#### Canvas Management
```dart
// Canvas dimensions
void setCanvasHeight(double height)               // Set canvas height manually
void setCanvasWidth(double width)                 // Set canvas width for bounds
void setRowLineSpacing(double spacing)            // Update line spacing

// Callbacks
void setCanvasHeightChangeCallback(void Function(double newHeight)? callback)

// Mode control
void setSequentialMode(bool enabled)              // Enable sequential writing
```

#### Row Operations
```dart
// Row access
NotebookRow? getRowByIndex(int index)             // Get row by index
NotebookRow? getRowAt(double y)                   // Get row at Y coordinate
int getRowIndexForY(double y)                     // Get row index for Y position
bool isPositionInDrawingArea(double y)            // Check if position allows drawing

// Visual feedback
double getLineNumberOpacity(int lineIndex)        // Progressive line number visibility
int getVisibleRowCount()                          // Number of visible rows
```

#### Free Drawing Space Management
```dart
// Create and modify free spaces
void insertFreeDrawingSpace(double yPosition, {double? height})
void deleteFreeDrawingSpace(double yPosition)
void expandFreeDrawingSpace(double yPosition, {double additionalHeight = 72.0})
void clearAllFreeDrawingSpaces()

// Query free spaces
bool isInFreeDrawingSpace(double y)
FreeDrawingSpace? getFreeDrawingSpaceAt(double y)
```

#### Image Row Management  
```dart
// Insert images
void insertImageRow(double yPosition, ImageProvider image, {double? height})
void insertImageRowWithBytes(double yPosition, List<int> imageBytes, {double? height})
void deleteImageRow(double yPosition)
void clearAllImageRows()

// Query images
bool isInImageRow(double y)
ImageRow? getImageRowAt(double y)
```

#### Row Highlighting
```dart
// Single row highlighting
void highlightRow(int lineNumber)
void unhighlightRow(int lineNumber)
void toggleRowHighlight(int lineNumber)
bool isRowHighlighted(int lineNumber)

// Multiple row highlighting
void highlightRows(Iterable<int> lineNumbers)
void unhighlightRows(Iterable<int> lineNumbers)
void clearAllHighlights()
```

#### Properties
```dart
double get rowLineSpacing                          // Current line spacing
double get topMargin                               // Top canvas margin
double get bottomMargin                            // Bottom canvas margin
double get canvasHeight                            // Current canvas height
bool get sequentialMode                            // Sequential writing state
List<NotebookRow> get rows                         // Immutable list of rows
List<FreeDrawingSpace> get freeDrawingSpaces      // Line-free regions
List<ImageRow> get imageRows                       // Image insertion regions
Set<int> get highlightedRows                       // Currently highlighted rows
```

### SimpleNotebookNotifier

Multi-page notebook controller with simplified state management.

#### Constructor
```dart
SimpleNotebookNotifier({
  List<SimpleNotebookPage>? pages,                 // Initial pages
  ScribblePointerMode allowedPointersMode = ScribblePointerMode.all,
  int maxHistoryLength = 30,
  List<double> widths = const [5, 10, 15],
  Curve pressureCurve = Curves.linear,
  SketchSimplifier simplifier = const VisvalingamSimplifier(),
  double simplificationTolerance = 0,
})
```

#### Drawing State Management
```dart
void setDrawing()                                  // Switch to drawing mode
void setErasing()                                  // Switch to erasing mode
void setColor(Color color)                         // Set pen color
void setStrokeWidth(double width)                  // Set pen width
void setAllowedPointersMode(ScribblePointerMode mode) // Set input devices
```

#### Page Management
```dart
void addPage({PaperSize? paperSize})              // Add new blank page
void removePage(int index)                         // Remove page at index
void setCurrentPageIndex(int index)               // Switch to different page
void clear()                                       // Clear current page
void clearAll()                                    // Clear all pages
```

#### Auto-Features
```dart
void setAutoAddPages({required bool enabled, double threshold = 50}) // Auto-add pages
void setZoomAndPan({double? zoomLevel, Offset? panOffset})          // Zoom and pan
```

#### Properties
```dart
List<SimpleNotebookPage> get pages                // All notebook pages
SimpleNotebookPage get currentPage               // Currently active page
Sketch get currentSketch                          // Sketch on current page
PaperSize get currentPaperSize                    // Paper size of current page
int get currentPageIndex                          // Index of current page
Future<ui.Image?> renderImage()                   // Export current page
```

### State Management

#### ScribblePointerMode
```dart
ScribblePointerMode.all          // Allow all input devices
ScribblePointerMode.mouseOnly    // Mouse input only
ScribblePointerMode.penOnly      // Stylus/pen input only
ScribblePointerMode.mouseAndPen  // Mouse and pen only
```

#### ScribbleState (Union Type)
```dart
ScribbleState.drawing(
  sketch,                        // Current sketch data
  allowedPointersMode,           // Input device restrictions
  activePointerIds,              // Active pointer tracking
  pointerPosition,               // Current pointer location
  selectedWidth,                 // Current pen width
  selectedColor,                 // Current pen color (ARGB)
  activeLine,                    // Line currently being drawn
  scaleFactor,                   // Zoom adjustment factor
  simplificationTolerance,       // Line simplification threshold
)

ScribbleState.erasing(...)       // Same properties without color/activeLine
```

#### Core Data Models
```dart
Sketch                           // Container for multiple sketch lines (JSON serializable)
SketchLine                       // Individual stroke with points, color, and width
Point                            // Coordinate with pressure information (x, y, pressure)
NotebookRow                      // Row positioning for LineByLineNotifier
FreeDrawingSpace                 // Line-free regions for mixed content
ImageRow                         // Image insertion regions
SimpleNotebookPage              // Page container with sketch and paper size
```

## Advanced Usage

### Pressure Sensitivity Configuration
```dart
final notifier = ScribbleNotifier(
  pressureCurve: Curves.easeInOut,  // Custom pressure response
  widths: [1, 3, 5, 8, 12],        // Fine-grained width options
);
```

### Device-Specific Drawing
```dart
// Pen-only drawing for precise input
notifier.setAllowedPointersMode(ScribblePointerMode.penOnly);

// Handle different pointer types
Scribble(
  notifier: notifier,
  drawPen: true,      // Enable pen input
  drawTouch: false,   // Disable touch input
  drawMouse: true,    // Enable mouse input
)
```

### Line Simplification for Performance
```dart
// Configure automatic simplification
notifier.setSimplificationTolerance(2.0);  // Reduce points within 2px tolerance

// Manual simplification
notifier.simplify(addToUndoHistory: true);
```

### JSON Persistence
```dart
// Export sketch data
final sketchJson = notifier.currentSketch.toJson();
final jsonString = jsonEncode(sketchJson);

// Import sketch data
final sketchData = jsonDecode(jsonString);
final sketch = Sketch.fromJson(sketchData);
notifier.setSketch(sketch: sketch);
```

## Examples

The [example](./example) directory contains comprehensive demonstrations:

- **Basic Drawing** (`main.dart`): Core drawing features, color selection, undo/redo
- **Line-by-Line Writing** (`line_by_line_demo.dart`): Advanced text writing with dynamic canvas
- **Multi-Page Notebook** (`simple_scrollable_notebook_demo.dart`): Page management and navigation

To run the examples:
```bash
cd example
flutter run
```

## Additional Information

Scribble is actively maintained and used in production applications. The package follows domain-driven design principles with comprehensive test coverage.

**Contributing:** Feel free to contribute or open issues in our [GitHub repo](https://github.com/timcreatedit/scribble).

**Version:** 0.10.0+1 - See [CHANGELOG.md](CHANGELOG.md) for update history.

[dart_install_link]: https://dart.dev/get-dart
