import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

void main() {
  runApp(const ZoomTestApp());
}

class ZoomTestApp extends StatelessWidget {
  const ZoomTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoom Test Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ZoomTestExample(),
    );
  }
}

class ZoomTestExample extends StatefulWidget {
  const ZoomTestExample({super.key});

  @override
  State<ZoomTestExample> createState() => _ZoomTestExampleState();
}

class _ZoomTestExampleState extends State<ZoomTestExample> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier(
      fixedStrokeWidth: 2.0,
      allowedPointersMode: ScribblePointerMode.mouseAndPen,
      canvasSize: const Size(400, 300),
    );

    // Add some initial content to test zoom centering
    _addTestContent();
  }

  void _addTestContent() {
    // Add a simple cross in the center to test zoom focal point
    final centerX = 200.0;
    final centerY = 150.0;

    // Horizontal line
    final horizontalLine = SketchLine(
      points: [
        Point(centerX - 50, centerY),
        Point(centerX - 25, centerY),
        Point(centerX, centerY),
        Point(centerX + 25, centerY),
        Point(centerX + 50, centerY),
      ],
      color: 0xFFFF0000, // Colors.red
      width: 3.0,
    );

    // Vertical line
    final verticalLine = SketchLine(
      points: [
        Point(centerX, centerY - 50),
        Point(centerX, centerY - 25),
        Point(centerX, centerY),
        Point(centerX, centerY + 25),
        Point(centerX, centerY + 50),
      ],
      color: 0xFF0000FF, // Colors.blue
      width: 3.0,
    );

    // Add corner markers
    final topLeft = SketchLine(
      points: [
        const Point(20, 20),
        const Point(30, 20),
        const Point(30, 30),
        const Point(20, 30),
        const Point(20, 20),
      ],
      color: 0xFF00FF00, // Colors.green
      width: 2.0,
    );

    final topRight = SketchLine(
      points: [
        const Point(370, 20),
        const Point(380, 20),
        const Point(380, 30),
        const Point(370, 30),
        const Point(370, 20),
      ],
      color: 0xFF00FF00, // Colors.green
      width: 2.0,
    );

    final bottomLeft = SketchLine(
      points: [
        const Point(20, 270),
        const Point(30, 270),
        const Point(30, 280),
        const Point(20, 280),
        const Point(20, 270),
      ],
      color: 0xFF00FF00, // Colors.green
      width: 2.0,
    );

    final bottomRight = SketchLine(
      points: [
        const Point(370, 270),
        const Point(380, 270),
        const Point(380, 280),
        const Point(370, 280),
        const Point(370, 270),
      ],
      color: 0xFF00FF00, // Colors.green
      width: 2.0,
    );

    // Add lines to the sketch
    final currentSketch = notifier.currentSketch;
    final newSketch = currentSketch.copyWith(
      lines: [
        ...currentSketch.lines,
        horizontalLine,
        verticalLine,
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
      ],
    );

    notifier.setSketch(sketch: newSketch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Test - Focal Point Centering'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Instructions
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Test interactions:\n'
              '• Single finger drag to PAN the canvas (strictly clamped - no overshoot)\n'
              '• Pinch/zoom with two fingers to ZOOM (centers on focal point)\n'
              '• Minimum zoom is 100% - cannot zoom out below actual size\n'
              '• Canvas cannot be dragged out of bounds, even temporarily\n'
              '• Tap Draw to switch to drawing mode\n'
              '• Red cross marks center, green squares mark corners',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          // Control buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
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
                    ScribbleInteractive.resetView(context);
                  },
                  child: const Text('Reset View'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Canvas
          Expanded(
            child: Center(
              child: Container(
                width: 400,
                height: 300,
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
              ),
            ),
          ),
          const SizedBox(height: 20),
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
