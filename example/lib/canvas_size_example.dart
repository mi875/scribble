import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

void main() {
  runApp(const CanvasSizeExampleApp());
}

class CanvasSizeExampleApp extends StatelessWidget {
  const CanvasSizeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Size Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CanvasSizeExamplePage(),
    );
  }
}

class CanvasSizeExamplePage extends StatefulWidget {
  const CanvasSizeExamplePage({super.key});

  @override
  State<CanvasSizeExamplePage> createState() => _CanvasSizeExamplePageState();
}

class _CanvasSizeExamplePageState extends State<CanvasSizeExamplePage> {
  late ScribbleNotifier notifier;
  Size canvasSize = const Size(400, 300);
  bool useFiniteCanvas = true;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier(
        fixedStrokeWidth: 2.0,
        allowedPointersMode: ScribblePointerMode.mouseAndPen,
        canvasSize: canvasSize);
  }

  void _resetView() {
    // Use the ScribbleInteractive widget's static reset method
    ScribbleInteractive.resetView(context);
  }

  void _updateCanvasSize(Size? newSize) {
    setState(() {
      if (newSize != null) {
        canvasSize = newSize;
      }
      // Create a new notifier with the updated canvas size
      final oldSketch = notifier.currentSketch;

      notifier.dispose();
      notifier = ScribbleNotifier(
        fixedStrokeWidth: 2.0,
        allowedPointersMode: ScribblePointerMode.mouseAndPen,
        canvasSize: useFiniteCanvas ? (newSize ?? canvasSize) : null,
        sketch: oldSketch,
      );

      // Don't restore zoom and pan - let the ScribbleInteractive widget
      // handle setting appropriate initial values based on the new canvas size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas Size Example'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        notifier.setColor(Colors.black);
                        notifier.setDrawing();
                      },
                      child: const Text('Draw'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        notifier.setEraser();
                      },
                      child: const Text('Erase'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        notifier.clear();
                      },
                      child: const Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: _resetView,
                      child: const Text('Reset View'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: useFiniteCanvas,
                      onChanged: (value) {
                        final newUseFinite = value ?? true;
                        setState(() {
                          useFiniteCanvas = newUseFinite;
                        });
                        _updateCanvasSize(newUseFinite ? canvasSize : null);
                      },
                    ),
                    const Text('Use finite canvas size'),
                  ],
                ),
                if (useFiniteCanvas) ...[
                  const SizedBox(height: 8),
                  Text(
                      'Canvas Size: ${canvasSize.width.toInt()} x ${canvasSize.height.toInt()}'),
                  Row(
                    children: [
                      const Text('Width: '),
                      Expanded(
                        child: Slider(
                          value: canvasSize.width,
                          min: 200,
                          max: 600,
                          divisions: 20,
                          onChanged: (value) {
                            final newSize = Size(value, canvasSize.height);
                            _updateCanvasSize(newSize);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Height: '),
                      Expanded(
                        child: Slider(
                          value: canvasSize.height,
                          min: 200,
                          max: 500,
                          divisions: 15,
                          onChanged: (value) {
                            final newSize = Size(canvasSize.width, value);
                            _updateCanvasSize(newSize);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Canvas
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.all(8),
                child: useFiniteCanvas
                    ? Container(
                        width: canvasSize.width,
                        height: canvasSize.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRect(
                          child: ScribbleInteractive(
                            notifier: notifier,
                            fixedStrokeWidth: 2.0,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: ScribbleInteractive(
                          notifier: notifier,
                          fixedStrokeWidth: 2.0,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }
}
