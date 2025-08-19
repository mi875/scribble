import 'dart:convert';

import 'package:example/line_by_line_demo.dart';
import 'package:example/simple_scrollable_notebook_demo.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scribble',
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      darkTheme: ThemeData.dark(),
      home: const HomePage(title: 'Scribble'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScribbleNotifier notifier;

  bool _simulatePressure = true;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.title),
        actions: _buildActions(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          children: [
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.zero,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Scribble(
                  notifier: notifier,
                  drawPen: true,
                  simulatePressure: _simulatePressure,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildColorToolbar(context),
                            const VerticalDivider(width: 32),
                            _buildWidthToolbar(context),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch.adaptive(
                              value: _simulatePressure,
                              onChanged: (v) =>
                                  setState(() => _simulatePressure = v),
                            ),
                            const SizedBox(width: 8),
                            const Text("Simulate Pressure")
                          ],
                        ),
                        _buildPointerModeSwitcher(context),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 32,
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: notifier.select((value) => value.lines
                            .expand((element) => element.points)
                            .length),
                        builder: (context, value, child) =>
                            Text("Simplification:\n($value points)"),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: notifier
                              .select((value) => value.simplificationTolerance),
                          builder: (context, value, child) => Slider(
                            value: value,
                            max: 10,
                            onChanged: notifier.setSimplificationTolerance,
                            label: "${value.toStringAsFixed(2)} px",
                            divisions: 100,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: notifier.simplify,
                        child: const Text("Simplify"),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  // Line-by-Line Demo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LineByLineDemo(),
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Line-by-Line Writing Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Simple Scrollable Notebook Demo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SimpleScrollableNotebookDemo(),
                        ),
                      ),
                      icon: const Icon(Icons.note),
                      label: const Text('Simple Notebook Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(context) {
    return [
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => IconButton(
          icon: child as Icon,
          tooltip: "Undo",
          onPressed: notifier.canUndo ? notifier.undo : null,
        ),
        child: const Icon(Icons.undo),
      ),
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => IconButton(
          icon: child as Icon,
          tooltip: "Redo",
          onPressed: notifier.canRedo ? notifier.redo : null,
        ),
        child: const Icon(Icons.redo),
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        tooltip: "Clear",
        onPressed: notifier.clear,
      ),
      IconButton(
        icon: const Icon(Icons.image),
        tooltip: "Show PNG Image",
        onPressed: () => _showImage(context),
      ),
      IconButton(
        icon: const Icon(Icons.data_object),
        tooltip: "Show JSON",
        onPressed: () => _showJson(context),
      ),
    ];
  }

  void _showImage(BuildContext context) async {
    final image = notifier.renderImage();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Generated Image"),
        content: SizedBox.expand(
          child: FutureBuilder(
            future: image,
            builder: (context, snapshot) => snapshot.hasData
                ? Image.memory(snapshot.data!.buffer.asUint8List())
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _showJson(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sketch as JSON"),
        content: SizedBox.expand(
          child: SelectableText(
            jsonEncode(notifier.currentSketch.toJson()),
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _buildWidthToolbar(BuildContext context) {
    return ValueListenableBuilder<ScribbleState>(
      valueListenable: notifier,
      builder: (context, state, _) => Column(
        children: [
          // Show appropriate label based on mode
          Text(
            state.map(
              drawing: (_) => 'Pen Width',
              erasing: (_) => 'Eraser Width',
            ),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Show appropriate widths based on mode
              ...state.map(
                drawing: (_) => notifier.widths.map((w) => _buildStrokeButton(
                      context,
                      strokeWidth: w,
                      state: state,
                      isEraser: false,
                    )),
                erasing: (_) => notifier.eraserWidths.map((w) => _buildStrokeButton(
                      context,
                      strokeWidth: w,
                      state: state,
                      isEraser: true,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
    required bool isEraser,
  }) {
    final selected = isEraser 
        ? state.selectedEraserWidth == strokeWidth
        : state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => isEraser 
              ? notifier.setEraserWidth(strokeWidth)
              : notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
                color: isEraser 
                    ? Colors.transparent
                    : state.map(
                        drawing: (s) => Color(s.selectedColor),
                        erasing: (_) => Colors.transparent,
                      ),
                border: isEraser || state is Erasing
                    ? Border.all(width: 1)
                    : null,
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildColorButton(context, color: Colors.black),
        _buildColorButton(context, color: Colors.red),
        _buildColorButton(context, color: Colors.green),
        _buildColorButton(context, color: Colors.blue),
        _buildColorButton(context, color: Colors.yellow),
        _buildEraserButton(context),
        _buildDrawingButton(context),
      ],
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier.select(
          (value) => value.allowedPointersMode,
        ),
        builder: (context, value, child) {
          return SegmentedButton<ScribblePointerMode>(
            multiSelectionEnabled: false,
            emptySelectionAllowed: false,
            onSelectionChanged: (v) => notifier.setAllowedPointersMode(v.first),
            segments: const [
              ButtonSegment(
                value: ScribblePointerMode.all,
                icon: Icon(Icons.touch_app),
                label: Text("All pointers"),
              ),
              ButtonSegment(
                value: ScribblePointerMode.penOnly,
                icon: Icon(Icons.draw),
                label: Text("Pen only"),
              ),
            ],
            selected: {value},
          );
        });
  }

  Widget _buildEraserButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((value) => value is Erasing),
      builder: (context, value, child) => ColorButton(
        color: Colors.transparent,
        outlineColor: Colors.black,
        isActive: value,
        onPressed: () => notifier.setEraser(),
        child: const Icon(Icons.cleaning_services),
      ),
    );
  }

  Widget _buildDrawingButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((value) => value is Drawing),
      builder: (context, value, child) => ColorButton(
        color: Colors.purple,
        isActive: value,
        onPressed: () => notifier.setDrawing(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
  }) {
    return ValueListenableBuilder(
      valueListenable: notifier.select(
          (value) => value is Drawing && value.selectedColor == color.value),
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ColorButton(
          color: color,
          isActive: value,
          onPressed: () => notifier.setColor(color),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    required this.color,
    required this.isActive,
    required this.onPressed,
    this.outlineColor,
    this.child,
    super.key,
  });

  final Color color;

  final Color? outlineColor;

  final bool isActive;

  final VoidCallback onPressed;

  final Icon? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: switch (isActive) {
              true => outlineColor ?? color,
              false => Colors.transparent,
            },
            width: 2,
          ),
        ),
      ),
      child: IconButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          side: isActive
              ? const BorderSide(color: Colors.white, width: 2)
              : const BorderSide(color: Colors.transparent),
        ),
        onPressed: onPressed,
        icon: child ?? const SizedBox(),
      ),
    );
  }
}
