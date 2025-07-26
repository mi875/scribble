import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/view/controls/zoom_controls.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';

/// A demo page showcasing the scrollable notebook functionality.
class ScrollableNotebookDemo extends StatefulWidget {
  const ScrollableNotebookDemo({super.key});

  @override
  State<ScrollableNotebookDemo> createState() => _ScrollableNotebookDemoState();
}

class _ScrollableNotebookDemoState extends State<ScrollableNotebookDemo> {
  late NotebookNotifier notifier;
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;

  @override
  void initState() {
    super.initState();
    notifier = NotebookNotifier(
      allowedPointersMode: ScribblePointerMode.penOnly,
    );
    
    // Add a few pages to demonstrate scrolling
    notifier.addPage(paperSize: PaperSize.a4);
    notifier.addPage(paperSize: PaperSize.a4);
    notifier.addPage(paperSize: PaperSize.a4);
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
        title: const Text('Scrollable Notebook Demo'),
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
            tooltip: 'Clear Current Page',
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instructions',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Scroll vertically to navigate between pages\n'
                            '• Tap on a page to select it\n'
                            '• Draw/erase only works on the active page\n'
                            '• Use TWO FINGERS to zoom in/out at finger position\n'
                            '• Pan with single finger when zoomed in\n'
                            '• Zoom centers exactly where you place fingers (accounts for scroll position)',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Page Info
                  ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (context, state, _) {
                      final notebook = state.notebook;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Page Info',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Current: ${notebook.currentPageIndex + 1} / '
                                '${notebook.pages.length}',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Size: ${notebook.currentPage.paperSize.name}',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Zoom: ${(state.zoomLevel * 100).round()}%',
                                style: TextStyle(
                                  color: state.zoomLevel != 1.0 
                                      ? Colors.blue 
                                      : null,
                                  fontWeight: state.zoomLevel != 1.0 
                                      ? FontWeight.bold 
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Page Management
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Page Management',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => notifier.addPage(),
                                  child: const Text('Add Page'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ValueListenableBuilder(
                                valueListenable: notifier,
                                builder: (context, state, _) {
                                  final canRemove = 
                                      state.notebook.pages.length > 1;
                                  return Expanded(
                                    child: ElevatedButton(
                                      onPressed: canRemove 
                                          ? () => notifier.removePage(
                                              state.notebook.currentPageIndex,
                                            ) 
                                          : null,
                                      child: const Text('Remove'),
                                    ),
                                  );
                                },
                              ),
                            ],
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
                ],
              ),
            ),
          ),

          // Right Panel - Scrollable Canvas
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: ScrollableNotebookCanvas(
                notifier: notifier,
                showPaperShadow: true,
                showPaperBorder: true,
                pageSpacing: 40,
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
            onPressed: () => _exportCurrentPage(),
            tooltip: 'Export Current Page',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  /// Exports the current page as an image.
  Future<void> _exportCurrentPage() async {
    try {
      final imageData = await notifier.renderImage();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Page ${notifier.currentNotebook.currentPageIndex + 1} '
              'exported (${imageData.lengthInBytes} bytes)',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}