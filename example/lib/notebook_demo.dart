import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/view/controls/page_navigation_controls.dart';
import 'package:scribble/src/view/controls/zoom_controls.dart';
import 'package:scribble/src/view/notebook_canvas.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';

/// A demo page showcasing the notebook functionality.
class NotebookDemo extends StatefulWidget {
  const NotebookDemo({super.key});

  @override
  State<NotebookDemo> createState() => _NotebookDemoState();
}

class _NotebookDemoState extends State<NotebookDemo> {
  late NotebookNotifier notifier;
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;

  @override
  void initState() {
    super.initState();
    notifier =
        NotebookNotifier(allowedPointersMode: ScribblePointerMode.penOnly);
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Drawing Tools
          IconButton(
            onPressed: () {
              notifier.setColor(selectedColor);
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Draw',
          ),
          IconButton(
            onPressed: notifier.setEraser,
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'Eraser',
          ),
          IconButton(
            onPressed: notifier.clearCurrentPage,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear Page',
          ),
          const SizedBox(width: 8),

          // Undo/Redo
          ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, state, _) => Row(
              children: [
                IconButton(
                  onPressed: notifier.canUndo ? notifier.undo : null,
                  icon: const Icon(Icons.undo),
                  tooltip: 'Undo',
                ),
                IconButton(
                  onPressed: notifier.canRedo ? notifier.redo : null,
                  icon: const Icon(Icons.redo),
                  tooltip: 'Redo',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Controls
          Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Paper Size Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paper Size',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder(
                          valueListenable: notifier,
                          builder: (context, state, _) {
                            final paperSize = notifier.currentPaperSize;
                            return DropdownButton<PaperSize>(
                              value: paperSize,
                              isExpanded: true,
                              items: PaperSize.predefinedSizes
                                  .map((size) => DropdownMenuItem(
                                        value: size,
                                        child: Text(size.name),
                                      ))
                                  .toList(),
                              onChanged: (newSize) {
                                if (newSize != null) {
                                  // For demo purposes, we'll keep the current paper size
                                  // In a real app, you might want to convert the page
                                  // or ask the user what to do
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Paper size change not implemented '
                                        'in this demo',
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Color Picker
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pen Color',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Colors.black,
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.purple,
                            Colors.orange,
                          ].map((color) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = color;
                                });
                                notifier.setColor(color);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selectedColor == color
                                      ? Border.all(
                                          color: Colors.grey.shade800,
                                          width: 3,
                                        )
                                      : Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stroke Width
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stroke Width',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: selectedWidth,
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: selectedWidth.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              selectedWidth = value;
                            });
                            notifier.setStrokeWidth(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Zoom Controls
                ZoomControls(notifier: notifier),

                const SizedBox(height: 16),

                // Page Navigation
                PageNavigationControls(notifier: notifier),
              ],
            ),
          ),

          // Right Panel - Canvas
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                child: NotebookCanvas(
                  notifier: notifier,
                  showPaperShadow: true,
                  showPaperBorder: true,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'export',
            onPressed: () => _exportImage(),
            tooltip: 'Export Current Page',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  /// Exports the current page as an image.
  Future<void> _exportImage() async {
    try {
      final imageData = await notifier.renderImage();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Image exported (${imageData.lengthInBytes} bytes)',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
