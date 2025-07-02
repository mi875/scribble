import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

/// Example demonstrating how to store and restore strokes using the Scribble library.
///
/// The Scribble library already provides comprehensive stroke storage and restoration
/// capabilities through its JSON serialization features.
class StrokeStorageExample extends StatefulWidget {
  const StrokeStorageExample({super.key});

  @override
  State<StrokeStorageExample> createState() => _StrokeStorageExampleState();
}

class _StrokeStorageExampleState extends State<StrokeStorageExample> {
  late ScribbleNotifier notifier;
  String? _savedSketchJson; // In-memory storage for demo purposes

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  /// Save the current sketch to memory as JSON
  void _saveSketchToMemory() {
    try {
      // Get current sketch and convert to JSON
      final sketch = notifier.currentSketch;
      _savedSketchJson = jsonEncode(sketch.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sketch saved to memory!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving sketch: $e')),
      );
    }
  }

  /// Load a previously saved sketch from memory
  void _loadSketchFromMemory() {
    try {
      if (_savedSketchJson != null) {
        // Convert JSON back to Sketch object
        final jsonMap = jsonDecode(_savedSketchJson!) as Map<String, dynamic>;
        final sketch = Sketch.fromJson(jsonMap);

        // Restore the sketch to the notifier
        notifier.setSketch(sketch: sketch);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sketch loaded from memory!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No saved sketch found in memory')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading sketch: $e')),
      );
    }
  }

  /// Clear the current sketch
  void _clearSketch() {
    notifier.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sketch cleared!')),
    );
  }

  /// Export sketch as JSON string (useful for sharing or cloud storage)
  String _exportSketchAsJson() {
    return notifier.exportAsJson();
  }

  /// Create a sample sketch programmatically
  void _createSampleSketch() {
    final sampleSketch = Sketch(
      lines: [
        // Red line
        SketchLine(
          points: [
            const Point(100, 100),
            const Point(200, 150),
            const Point(300, 100),
          ],
          color: Colors.red.value,
          width: 5.0,
        ),
        // Blue circle-like shape
        SketchLine(
          points:
              _generateCirclePoints(center: const Offset(200, 200), radius: 50),
          color: Colors.blue.value,
          width: 3.0,
        ),
        // Green horizontal line
        SketchLine(
          points: [
            const Point(50, 300),
            const Point(350, 300),
          ],
          color: Colors.green.value,
          width: 8.0,
        ),
      ],
    );

    notifier.setSketch(sketch: sampleSketch);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample sketch created!')),
    );
  }

  /// Generate points for a circle shape
  List<Point> _generateCirclePoints(
      {required Offset center, required double radius}) {
    final points = <Point>[];
    const steps = 32;

    for (int i = 0; i <= steps; i++) {
      final angle = (i * 2 * math.pi) / steps;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      points.add(Point(x, y));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stroke Storage Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Drawing canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Scribble(
                notifier: notifier,
                drawPen: true,
                drawEraser: true,
              ),
            ),
          ),

          // Control buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveSketchToMemory,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                ElevatedButton.icon(
                  onPressed: _loadSketchFromMemory,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Load'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearSketch,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
                ElevatedButton.icon(
                  onPressed: _createSampleSketch,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Sample'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final json = _exportSketchAsJson();
                    // In a real app, you might share this or copy to clipboard
                    print('Exported JSON: $json');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('JSON exported to console')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Export'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Import a sample sketch JSON for demonstration
                    const sampleJson =
                        '{"lines":[{"points":[{"x":150,"y":150,"pressure":0.5},{"x":250,"y":200,"pressure":0.5}],"color":4294901760,"width":5}]}';
                    final success =
                        notifier.importFromJson(sampleJson, clearFirst: false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Sample sketch imported successfully!'
                            : 'Failed to import sample sketch'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Import Sample'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (notifier.canUndo) {
                      notifier.undo();
                    }
                  },
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (notifier.canRedo) {
                      notifier.redo();
                    }
                  },
                  icon: const Icon(Icons.redo),
                  label: const Text('Redo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final stats = notifier.getStats();
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sketch Statistics'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Strokes: ${stats.strokeCount}'),
                            Text('Total Points: ${stats.totalPoints}'),
                            Text(
                                'Average Width: ${stats.averageStrokeWidth.toStringAsFixed(1)}'),
                            Text('Colors Used: ${stats.colorsUsed.length}'),
                            if (stats.boundingBox != null)
                              Text(
                                  'Size: ${stats.boundingBox!.width.toStringAsFixed(0)} x ${stats.boundingBox!.height.toStringAsFixed(0)}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.analytics),
                  label: const Text('Stats'),
                ),
              ],
            ),
          ),

          // Information panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stroke Storage Features:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('• Save/Load: Strokes stored as JSON in memory'),
                const Text(
                    '• Export/Import: JSON format with extension methods'),
                const Text('• Undo/Redo: Built-in history management'),
                const Text('• Programmatic Creation: Create strokes from code'),
                const Text(
                    '• Statistics: Analyze stroke count, points, colors'),
                const Text(
                    '• Full Serialization: Points, colors, widths, pressure'),
                const SizedBox(height: 8),
                ValueListenableBuilder<ScribbleState>(
                  valueListenable: notifier,
                  builder: (context, state, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current: ${notifier.strokeCount} strokes, ${notifier.totalPoints} points',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Has content: ${notifier.hasContent ? "Yes" : "No"}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Example app to demonstrate the stroke storage functionality
class StrokeStorageApp extends StatelessWidget {
  const StrokeStorageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scribble Stroke Storage Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StrokeStorageExample(),
    );
  }
}

void main() {
  runApp(const StrokeStorageApp());
}
