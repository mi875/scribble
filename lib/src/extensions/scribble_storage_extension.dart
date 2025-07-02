import 'dart:convert';
import 'package:scribble/scribble.dart';

/// Extension methods to make stroke storage and restoration even more convenient
extension ScribbleNotifierStorageExtension on ScribbleNotifier {
  /// Export the current sketch as a JSON string
  ///
  /// This is a convenience method that handles the JSON encoding for you.
  /// Returns an empty sketch JSON if there are no strokes.
  String exportAsJson() {
    try {
      return jsonEncode(currentSketch.toJson());
    } catch (e) {
      // Return empty sketch on error
      return jsonEncode(const Sketch(lines: []).toJson());
    }
  }

  /// Import a sketch from a JSON string
  ///
  /// [jsonString] - The JSON string containing the sketch data
  /// [addToHistory] - Whether to add this operation to the undo history (default: true)
  /// [clearFirst] - Whether to clear existing strokes before importing (default: false)
  ///
  /// Returns true if the import was successful, false otherwise.
  bool importFromJson(
    String jsonString, {
    bool addToHistory = true,
    bool clearFirst = false,
  }) {
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final importedSketch = Sketch.fromJson(jsonMap);

      Sketch finalSketch;

      if (clearFirst) {
        finalSketch = importedSketch;
      } else {
        // Merge with existing sketch
        final existingLines = currentSketch.lines;
        final newLines = [...existingLines, ...importedSketch.lines];
        finalSketch = Sketch(lines: newLines);
      }

      setSketch(sketch: finalSketch, addToUndoHistory: addToHistory);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add a single stroke to the current sketch
  ///
  /// This is useful for programmatically adding strokes without replacing
  /// the entire sketch.
  void addStroke(SketchLine stroke, {bool addToHistory = true}) {
    final updatedLines = [...currentSketch.lines, stroke];
    final updatedSketch = Sketch(lines: updatedLines);
    setSketch(sketch: updatedSketch, addToUndoHistory: addToHistory);
  }

  /// Add multiple strokes to the current sketch
  void addStrokes(List<SketchLine> strokes, {bool addToHistory = true}) {
    final updatedLines = [...currentSketch.lines, ...strokes];
    final updatedSketch = Sketch(lines: updatedLines);
    setSketch(sketch: updatedSketch, addToUndoHistory: addToHistory);
  }

  /// Remove strokes that match a condition
  ///
  /// [predicate] - Function that returns true for strokes to remove
  void removeStrokesWhere(
    bool Function(SketchLine) predicate, {
    bool addToHistory = true,
  }) {
    final filteredLines =
        currentSketch.lines.where((line) => !predicate(line)).toList();
    final updatedSketch = Sketch(lines: filteredLines);
    setSketch(sketch: updatedSketch, addToUndoHistory: addToHistory);
  }

  /// Get sketch statistics
  SketchStats getStats() {
    final lines = currentSketch.lines;

    if (lines.isEmpty) {
      return SketchStats(
        strokeCount: 0,
        totalPoints: 0,
        averageStrokeWidth: 0,
        colorsUsed: {},
        boundingBox: null,
      );
    }

    int totalPoints = 0;
    double totalWidth = 0;
    final Set<int> colors = {};
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (final line in lines) {
      totalPoints += line.points.length;
      totalWidth += line.width;
      colors.add(line.color);

      for (final point in line.points) {
        if (point.x < minX) minX = point.x;
        if (point.x > maxX) maxX = point.x;
        if (point.y < minY) minY = point.y;
        if (point.y > maxY) maxY = point.y;
      }
    }

    return SketchStats(
      strokeCount: lines.length,
      totalPoints: totalPoints,
      averageStrokeWidth: totalWidth / lines.length,
      colorsUsed: colors,
      boundingBox: SketchBounds(
        left: minX,
        top: minY,
        right: maxX,
        bottom: maxY,
      ),
    );
  }

  /// Check if the sketch has any content
  bool get hasContent => currentSketch.lines.isNotEmpty;

  /// Get the total number of strokes
  int get strokeCount => currentSketch.lines.length;

  /// Get the total number of points across all strokes
  int get totalPoints =>
      currentSketch.lines.fold(0, (sum, line) => sum + line.points.length);
}

/// Statistics about a sketch
class SketchStats {
  const SketchStats({
    required this.strokeCount,
    required this.totalPoints,
    required this.averageStrokeWidth,
    required this.colorsUsed,
    required this.boundingBox,
  });

  final int strokeCount;
  final int totalPoints;
  final double averageStrokeWidth;
  final Set<int> colorsUsed;
  final SketchBounds? boundingBox;

  @override
  String toString() {
    return 'SketchStats(strokes: $strokeCount, points: $totalPoints, '
        'avgWidth: ${averageStrokeWidth.toStringAsFixed(1)}, '
        'colors: ${colorsUsed.length}, bounds: $boundingBox)';
  }
}

/// Bounding box for a sketch
class SketchBounds {
  const SketchBounds({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;

  @override
  String toString() {
    return 'SketchBounds(${left.toStringAsFixed(1)}, ${top.toStringAsFixed(1)}, '
        '${width.toStringAsFixed(1)}x${height.toStringAsFixed(1)})';
  }
}
