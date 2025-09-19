import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

/// Demonstrates the row change detection feature.
///
/// This example shows how to detect which rows have changed when the user
/// draws on the canvas, enabling optimized rendering and processing.
class RowChangeDetectionDemo extends StatefulWidget {
  const RowChangeDetectionDemo({super.key});

  @override
  State<RowChangeDetectionDemo> createState() => _RowChangeDetectionDemoState();
}

class _RowChangeDetectionDemoState extends State<RowChangeDetectionDemo> {
  late final LineByLineNotifier _notifier;
  String _changeInfo = 'No changes detected yet';
  String _checkpointInfo = 'No checkpoint set';

  @override
  void initState() {
    super.initState();
    _notifier = LineByLineNotifier(
      rowLineSpacing: 60.0,
      topMargin: 30.0,
      bottomMargin: 60.0,
      initialCanvasHeight: 600.0,
    );

    // Listen for changes to automatically detect changes since checkpoint
    _notifier.addListener(_detectChangesFromCheckpoint);
  }

  @override
  void dispose() {
    _notifier.removeListener(_detectChangesFromCheckpoint);
    _notifier.dispose();
    super.dispose();
  }

  void _detectChangesFromCheckpoint() {
    // Detect which rows have changed since checkpoint
    final changeInfo = _notifier.detectChangesSinceCheckpoint();

    if (changeInfo.hasChanges) {
      final rendererRange = changeInfo.rendererIndexRange;
      final normalRange = changeInfo.normalIndexRange;
      final checkpointTime = changeInfo.checkpointTimestamp;
      final timeSince = checkpointTime != null 
          ? DateTime.now().difference(checkpointTime).inSeconds 
          : 0;

      setState(() {
        _changeInfo = '''
Changes Since Checkpoint (${timeSince}s ago):
- Change Type: ${changeInfo.changeType.name}
- Affected Renderer Indices: ${changeInfo.affectedRendererIndices}
- Affected Line Numbers: ${changeInfo.affectedNormalIndices}
- Renderer Range: ${rendererRange != null ? '${rendererRange.min}-${rendererRange.max}' : 'None'}
- Line Number Range: ${normalRange != null ? '${normalRange.min}-${normalRange.max}' : 'None'}
- Y Coordinate Range: ${changeInfo.minY?.toStringAsFixed(1) ?? 'N/A'} - ${changeInfo.maxY?.toStringAsFixed(1) ?? 'N/A'}
''';
      });
    } else if (!_notifier.hasCheckpoint()) {
      setState(() {
        _changeInfo = 'No checkpoint set';
      });
    } else {
      setState(() {
        _changeInfo = 'No changes since checkpoint';
      });
    }
  }

  void _setCheckpoint() {
    _notifier.setCheckpoint();
    final timestamp = _notifier.getCheckpointTimestamp();
    setState(() {
      _checkpointInfo = 'Checkpoint set at ${timestamp?.toLocal().toString().split('.')[0] ?? 'unknown'}';
      _changeInfo = 'Checkpoint created - draw to see changes';
    });
  }

  void _clearCheckpoint() {
    _notifier.clearCheckpoint();
    setState(() {
      _checkpointInfo = 'No checkpoint set';
      _changeInfo = 'Checkpoint cleared';
    });
  }

  void _clearCanvas() {
    _notifier.clear();
    setState(() {
      _changeInfo = 'Canvas cleared';
    });
  }

  void _undoLastChange() {
    _notifier.undo();
    setState(() {
      _changeInfo = 'Undo performed';
    });
  }

  void _getRowsWithContent() {
    final rowsWithContent = _notifier.getRowsWithContent();
    setState(() {
      if (rowsWithContent.isEmpty) {
        _changeInfo = 'No rows contain content';
      } else {
        final normalIndices = rowsWithContent
            .where((row) => row.normalIndex != null)
            .map((row) => row.normalIndex!)
            .toList()
          ..sort();
        _changeInfo = '''
Rows with content:
- Total rows: ${rowsWithContent.length}
- Line numbers: ${normalIndices.isEmpty ? 'None' : normalIndices.join(', ')}
''';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Row Change Detection Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _notifier.canUndo ? _undoLastChange : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _notifier.canRedo
                ? () {
                    _notifier.redo();
                  }
                : null,
            tooltip: 'Redo',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearCanvas,
            tooltip: 'Clear Canvas',
          ),
        ],
      ),
      body: Column(
        children: [
          // Change detection info panel
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Checkpoint Change Detection',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _checkpointInfo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _notifier.hasCheckpoint() ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _changeInfo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _setCheckpoint,
                      icon: const Icon(Icons.flag),
                      label: const Text('Set Checkpoint'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _notifier.hasCheckpoint() ? _clearCheckpoint : null,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Checkpoint'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _notifier.hasCheckpoint() ? _detectChangesFromCheckpoint : null,
                      icon: const Icon(Icons.compare),
                      label: const Text('Compare with Checkpoint'),
                    ),
                    ElevatedButton(
                      onPressed: _getRowsWithContent,
                      child: const Text('Get Content Rows'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Drawing canvas
          Expanded(
            child: LineByLineCanvas(
              notifier: _notifier,
              drawPen: false,
              drawEraser: true,
              paperColor: Colors.white,
              rowLineColor: Colors.grey[400]!,
              rowLineWidth: 1.0,
            ),
          ),
          // Drawing controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Drawing mode toggle
                SegmentedButton<ScribbleMode>(
                  segments: const [
                    ButtonSegment(
                      value: ScribbleMode.drawing,
                      icon: Icon(Icons.draw),
                      label: Text('Draw'),
                    ),
                    ButtonSegment(
                      value: ScribbleMode.erasing,
                      icon: Icon(Icons.cleaning_services),
                      label: Text('Erase'),
                    ),
                  ],
                  selected: {
                    _notifier.value.map(
                      drawing: (_) => ScribbleMode.drawing,
                      erasing: (_) => ScribbleMode.erasing,
                    ),
                  },
                  onSelectionChanged: (modes) {
                    if (modes.first == ScribbleMode.drawing) {
                      _notifier.setDrawing();
                    } else {
                      _notifier.setEraser();
                    }
                  },
                ),
                // Color picker
                IconButton(
                  icon: Icon(
                    Icons.circle,
                    color: Color(_notifier.value.map(
                      drawing: (state) => state.selectedColor,
                      erasing: (_) => 0xFF000000,
                    )),
                  ),
                  onPressed: () async {
                    // Simple color picker dialog
                    final colors = [
                      Colors.black,
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                    ];
                    final selected = await showDialog<Color>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Select Color'),
                        children: colors.map((color) {
                          return SimpleDialogOption(
                            onPressed: () => Navigator.pop(context, color),
                            child: Container(
                              height: 40,
                              color: color,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                    if (selected != null) {
                      _notifier.setColor(selected);
                    }
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

/// Scribble drawing mode enum
enum ScribbleMode {
  drawing,
  erasing,
}
