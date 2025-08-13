import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';
import 'package:scribble/src/view/controls/zoom_controls.dart';

/// A minimal demo page for the scrollable notebook with side controls.
class ScrollableNotebookDemo extends StatefulWidget {
  const ScrollableNotebookDemo({super.key});

  @override
  State<ScrollableNotebookDemo> createState() => _ScrollableNotebookDemoState();
}

class _ScrollableNotebookDemoState extends State<ScrollableNotebookDemo> {
  late NotebookNotifier notifier;

  // Side controls state
  Color selectedColor = Colors.black;
  double rowLineSpacing = 24.0;
  Color rowLineColor = const Color(0xFFBDBDBD);
  double rowLineWidth = 1.0;
  RowConstraintMode rowConstraintMode = RowConstraintMode.none;

  @override
  void initState() {
    super.initState();
    notifier = NotebookNotifier(
      allowedPointersMode: ScribblePointerMode.penOnly,
    );
    // Start with a few pages
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
        title: const Text('Scrollable Notebook'),
        actions: [
          // Undo/Redo
          ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, state, _) => Row(children: [
              IconButton(
                tooltip: 'Undo',
                onPressed: notifier.canUndo ? notifier.undo : null,
                icon: const Icon(Icons.undo),
              ),
              IconButton(
                tooltip: 'Redo',
                onPressed: notifier.canRedo ? notifier.redo : null,
                icon: const Icon(Icons.redo),
              ),
            ]),
          ),
          IconButton(
            tooltip: 'Add Page',
            onPressed: () => notifier.addPage(),
            icon: const Icon(Icons.note_add),
          ),
          IconButton(
            tooltip: 'Remove Page',
            onPressed: () => notifier.removePage(
              notifier.currentNotebook.currentPageIndex,
            ),
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            tooltip: 'Clear Current Page',
            onPressed: notifier.clearCurrentPage,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Controls
          Container(
            width: 220,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                              Text('Page Info',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 8),
                              Text(
                                  'Current: ${notebook.currentPageIndex + 1} / ${notebook.pages.length}'),
                              const SizedBox(height: 4),
                              Text(
                                  'Size: ${notebook.currentPage.paperSize.name}'),
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
                          Text('Pages',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => notifier.addPage(),
                                  child: const Text('Add'),
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
                                              state.notebook.currentPageIndex)
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

                  // Pen Color
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pen Color',
                              style: Theme.of(context).textTheme.titleSmall),
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
                              final selected = selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedColor = color);
                                  notifier.setColor(color);
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade300,
                                      width: selected ? 3 : 1,
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

                  // Row Line Style
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Row Lines',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          Text('Spacing: ${rowLineSpacing.round()}px',
                              style: const TextStyle(fontSize: 12)),
                          Slider(
                            value: rowLineSpacing,
                            min: 12,
                            max: 48,
                            divisions: 18,
                            onChanged: (v) =>
                                setState(() => rowLineSpacing = v),
                          ),
                          const SizedBox(height: 8),
                          Text('Width: ${rowLineWidth.toStringAsFixed(1)}px',
                              style: const TextStyle(fontSize: 12)),
                          Slider(
                            value: rowLineWidth,
                            min: 0.5,
                            max: 3.0,
                            divisions: 10,
                            onChanged: (v) => setState(() => rowLineWidth = v),
                          ),
                          const SizedBox(height: 8),
                          const Text('Color:', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final c in const [
                                Color(0xFFBDBDBD), // Gray (default)
                                Color(0xFFE3F2FD), // Light Blue
                                Color(0xFFE8F5E8), // Light Green
                                Color(0xFFFFF3E0), // Light Orange
                                Color(0xFFE1F5FE), // Light Cyan
                                Color(0xFFF3E5F5), // Light Purple
                              ])
                                GestureDetector(
                                  onTap: () => setState(() => rowLineColor = c),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: c,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: rowLineColor == c
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300,
                                        width: rowLineColor == c ? 3 : 1,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Writing Constraints
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Writing Constraints',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          SegmentedButton<RowConstraintMode>(
                            segments: const [
                              ButtonSegment(
                                  value: RowConstraintMode.none,
                                  label: Text('None')),
                              ButtonSegment(
                                  value: RowConstraintMode.sequential,
                                  label: Text('Sequential')),
                            ],
                            selected: {rowConstraintMode},
                            onSelectionChanged: (v) =>
                                setState(() => rowConstraintMode = v.first),
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

          // Right Panel - Canvas
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: ScrollableNotebookCanvas(
                notifier: notifier,
                simulatePressure: false,
                showPaperShadow: true,
                showPaperBorder: true,
                pageSpacing: 40,
                rowLineSpacing: rowLineSpacing,
                rowLineColor: rowLineColor,
                rowLineWidth: rowLineWidth,
                rowConstraintMode: rowConstraintMode,
                autoAddPages: true,
                bottomMarginThreshold: 50.0,
                onEraseRow: (rowIndex) {
                  // Optional: handle row erase action
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
