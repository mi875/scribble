import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/domain/model/page/simple_page.dart';
import 'package:scribble/src/view/notifier/simple_notebook_notifier.dart';
import 'package:scribble/src/view/simple_scrollable_notebook.dart';

/// A minimal demo page for the simple scrollable notebook.
class SimpleScrollableNotebookDemo extends StatefulWidget {
  const SimpleScrollableNotebookDemo({super.key});

  @override
  State<SimpleScrollableNotebookDemo> createState() =>
      _SimpleScrollableNotebookDemoState();
}

class _SimpleScrollableNotebookDemoState
    extends State<SimpleScrollableNotebookDemo> {
  late SimpleNotebookNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = SimpleNotebookNotifier(
      pages: [
        SimpleNotebookPage.blank(id: '0', paperSize: PaperSize.a4),
        SimpleNotebookPage.blank(id: '1', paperSize: PaperSize.a4),
        SimpleNotebookPage.blank(id: '2', paperSize: PaperSize.a4),
      ],
      allowedPointersMode: ScribblePointerMode.penOnly,
    );
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
        title: const Text('Simple Notebook'),
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
              notifier.currentPageIndex,
            ),
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            tooltip: 'Clear Current Page',
            onPressed: notifier.clear,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: SimpleScrollableNotebook(
        notifier: notifier,
        // Rely on internal theming with no extra configuration
      ),
    );
  }
}
