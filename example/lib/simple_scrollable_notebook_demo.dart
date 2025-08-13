import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/domain/model/page/simple_page.dart';
import 'package:scribble/src/view/notifier/simple_notebook_notifier.dart';
import 'package:scribble/src/view/simple_scrollable_notebook.dart';

/// A demo page showcasing the simple scrollable notebook functionality.
class SimpleScrollableNotebookDemo extends StatefulWidget {
  const SimpleScrollableNotebookDemo({super.key});

  @override
  State<SimpleScrollableNotebookDemo> createState() => 
      _SimpleScrollableNotebookDemoState();
}

class _SimpleScrollableNotebookDemoState 
    extends State<SimpleScrollableNotebookDemo> {
  late SimpleNotebookNotifier notifier;
  late ScribbleThemeController themeController;
  Color selectedColor = Colors.black;
  double selectedWidth = 2.0;

  @override
  void initState() {
    super.initState();
    themeController = ScribbleThemeController(followSystemTheme: true);
    notifier = SimpleNotebookNotifier(
      pages: [
        SimpleNotebookPage.blank(id: '0', paperSize: PaperSize.a4),
        SimpleNotebookPage.blank(id: '1', paperSize: PaperSize.a4),
        SimpleNotebookPage.blank(id: '2', paperSize: PaperSize.a4),
      ],
      widths: [selectedWidth],
      allowedPointersMode: ScribblePointerMode.penOnly,
    );
  }

  @override
  void dispose() {
    notifier.dispose();
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScribbleThemeBuilder(
      controller: themeController,
      builder: (context, theme) {
        return Scaffold(
          backgroundColor: theme.paperColor,
          appBar: AppBar(
            title: const Text('Simple Scrollable Notebook Demo'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // Theme Toggle Button
              IconButton(
                onPressed: themeController.toggleTheme,
                icon: Icon(
                  theme == ScribbleTheme.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                tooltip: theme == ScribbleTheme.light
                    ? 'Switch to Dark Mode'
                    : 'Switch to Light Mode',
              ),
              // Drawing Tools
              IconButton(
                onPressed: () {
                  notifier.setDrawing();
                  notifier.setColor(selectedColor);
                },
                icon: const Icon(Icons.edit),
                tooltip: 'Draw',
              ),
              IconButton(
                onPressed: notifier.setErasing,
                icon: const Icon(Icons.auto_fix_high),
                tooltip: 'Eraser',
              ),
              IconButton(
                onPressed: notifier.clear,
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
                                'Simple Notebook',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• Clean multi-page scrolling\n'
                                '• No row lines or constraints\n'
                                '• Basic drawing and erasing\n'
                                '• Pressure-sensitive drawing\n'
                                '• Undo/redo support\n'
                                '• Theme support\n'
                                '• Simple page management',
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
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Page Info',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Current: ${state.currentPageIndex + 1} / '
                                    '${state.pages.length}',
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Size: ${state.currentPage.paperSize.name}',
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
                                      final canRemove = state.pages.length > 1;
                                      return Expanded(
                                        child: ElevatedButton(
                                          onPressed: canRemove
                                              ? () => notifier.removePage(
                                                    state.currentPageIndex,
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
                              Text(
                                'Width: ${selectedWidth.toStringAsFixed(1)}px',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Slider(
                                value: selectedWidth,
                                min: 1.0,
                                max: 10.0,
                                divisions: 18,
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

                      // Clear All Button
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Actions',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: notifier.clearAll,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade100,
                                    foregroundColor: Colors.red.shade800,
                                  ),
                                  child: const Text('Clear All Pages'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Panel - Simple Scrollable Canvas
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: SimpleScrollableNotebook(
                    notifier: notifier,
                    theme: theme,
                    simulatePressure: false,
                    showPaperShadow: true,
                    showPaperBorder: true,
                    pageSpacing: 40,
                    autoAddPages: true,
                    bottomMarginThreshold: 50.0,
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
      },
    );
  }

  /// Exports the current page as an image.
  Future<void> _exportCurrentPage() async {
    try {
      final image = await notifier.renderImage();
      
      if (image != null && mounted) {
        final imageData = await image.toByteData();
        if (imageData != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Page ${notifier.currentPageIndex + 1} '
                'exported (${imageData.lengthInBytes} bytes)',
              ),
            ),
          );
        }
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