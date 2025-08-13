import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

/// A demo page for the simplified line-by-line canvas widget.
class LineByLineDemo extends StatefulWidget {
  const LineByLineDemo({super.key});

  @override
  State<LineByLineDemo> createState() => _LineByLineDemoState();
}

class _LineByLineDemoState extends State<LineByLineDemo> {
  late LineByLineNotifier notifier;

  // Control settings
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;
  double rowLineSpacing = 24.0;
  bool sequentialMode = false;

  @override
  void initState() {
    super.initState();
    notifier = LineByLineNotifier(
      allowedPointersMode: ScribblePointerMode.penOnly,
      rowLineSpacing: rowLineSpacing,
      initialCanvasHeight: 400,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set initial color based on theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (selectedColor == Colors.black && isDark) {
      selectedColor = Colors.white;
      notifier.setColor(selectedColor);
    } else if (selectedColor == Colors.white && !isDark) {
      selectedColor = Colors.black;
      notifier.setColor(selectedColor);
    }
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Line-by-Line Writing'),
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
            tooltip: 'Clear Canvas',
            onPressed: () => notifier.clear(),
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            tooltip: 'Toggle Theme',
            onPressed: () {
              // This would need to be handled by the parent app
              // For now, just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toggle theme in system settings'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Controls
          Container(
            width: 220,
            padding: const EdgeInsets.all(16),
            color: isDark ? theme.colorScheme.surface : Colors.grey.shade50,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Canvas Info
                  ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (context, state, _) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Canvas Info',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 8),
                              Text('Height: ${notifier.canvasHeight.round()}px'),
                              const SizedBox(height: 4),
                              Text('Lines: ${state.sketch.lines.length}'),
                              const SizedBox(height: 4),
                              Text(
                                'Mode: ${sequentialMode ? "Sequential" : "Free"}',
                                style: TextStyle(
                                  color: sequentialMode
                                      ? Colors.orange
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Writing Mode
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Writing Mode',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            title: const Text('Sequential Mode'),
                            subtitle: const Text('Force line-by-line writing'),
                            value: sequentialMode,
                            onChanged: (value) {
                              setState(() => sequentialMode = value);
                            },
                            contentPadding: EdgeInsets.zero,
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
                              Colors.white,
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
                                          ? (isDark ? Colors.grey.shade300 : Colors.grey.shade800)
                                          : (color == Colors.white
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade300),
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

                  // Pen Width
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pen Width',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          Text('Width: ${selectedWidth.toStringAsFixed(1)}px',
                              style: const TextStyle(fontSize: 12)),
                          Slider(
                            value: selectedWidth,
                            min: 1.0,
                            max: 20.0,
                            divisions: 19,
                            onChanged: (v) {
                              setState(() => selectedWidth = v);
                              notifier.setStrokeWidth(v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Row Line Settings
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
                            min: 16,
                            max: 48,
                            divisions: 16,
                            onChanged: (v) {
                              setState(() => rowLineSpacing = v);
                              notifier.setRowLineSpacing(v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Panel - Canvas
          Expanded(
            child: Container(
              color: isDark 
                  ? theme.colorScheme.surfaceContainerLowest 
                  : Colors.grey.shade100,
              child: LineByLineCanvas(
                notifier: notifier,
                simulatePressure: false,
                showPaperShadow: true,
                showPaperBorder: true,
                canvasWidth: 600,
                themeMode: ScribbleThemeMode.system,
                sequentialMode: sequentialMode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}