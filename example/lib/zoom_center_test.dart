import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

void main() {
  runApp(const ZoomCenterTestApp());
}

class ZoomCenterTestApp extends StatelessWidget {
  const ZoomCenterTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoom Center Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ZoomCenterTest(),
    );
  }
}

class ZoomCenterTest extends StatefulWidget {
  const ZoomCenterTest({super.key});

  @override
  State<ZoomCenterTest> createState() => _ZoomCenterTestState();
}

class _ZoomCenterTestState extends State<ZoomCenterTest> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier(
      fixedStrokeWidth: 2.0,
      allowedPointersMode: ScribblePointerMode.mouseAndPen,
      canvasSize: const Size(400, 300),
    );

    // Add a grid pattern to make zoom behavior more visible
    _addGridPattern();
  }

  void _addGridPattern() {
    final lines = <SketchLine>[];

    // Add vertical lines every 50 pixels
    for (double x = 50; x <= 350; x += 50) {
      lines.add(SketchLine(
        points: [
          Point(x, 0),
          Point(x, 300),
        ],
        color: 0xFF808080, // Gray
        width: 1.0,
      ));
    }

    // Add horizontal lines every 50 pixels
    for (double y = 50; y <= 250; y += 50) {
      lines.add(SketchLine(
        points: [
          Point(0, y),
          Point(400, y),
        ],
        color: 0xFF808080, // Gray
        width: 1.0,
      ));
    }

    // Add a red cross in the center for reference
    lines.add(SketchLine(
      points: [
        const Point(190, 150),
        const Point(210, 150),
      ],
      color: 0xFFFF0000, // Red
      width: 3.0,
    ));

    lines.add(SketchLine(
      points: [
        const Point(200, 140),
        const Point(200, 160),
      ],
      color: 0xFFFF0000, // Red
      width: 3.0,
    ));

    // Add corner markers
    final corners = [
      const Point(10, 10), // Top-left
      const Point(390, 10), // Top-right
      const Point(10, 290), // Bottom-left
      const Point(390, 290), // Bottom-right
    ];

    for (final corner in corners) {
      lines.add(SketchLine(
        points: [
          Point(corner.x - 5, corner.y),
          Point(corner.x + 5, corner.y),
        ],
        color: 0xFF00FF00, // Green
        width: 2.0,
      ));

      lines.add(SketchLine(
        points: [
          Point(corner.x, corner.y - 5),
          Point(corner.x, corner.y + 5),
        ],
        color: 0xFF00FF00, // Green
        width: 2.0,
      ));
    }

    final currentSketch = notifier.currentSketch;
    final newSketch = currentSketch.copyWith(lines: lines);
    notifier.setSketch(sketch: newSketch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Center Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.yellow[100],
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zoom Center Test Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                    '1. Position your mouse cursor over any point on the canvas'),
                Text('2. Use mouse wheel or trackpad to zoom in/out'),
                Text('3. The point under your cursor should remain stationary'),
                Text('4. The red cross marks the canvas center (200, 150)'),
                Text('5. Green crosses mark the corners of the canvas'),
                Text('6. Gray grid lines help visualize zoom behavior'),
              ],
            ),
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ValueListenableBuilder<ScribbleState>(
                  valueListenable: notifier,
                  builder: (context, state, _) {
                    return Text(
                      'Zoom: ${(state.scaleFactor * 100).toInt()}%',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    ScribbleInteractive.resetView(context);
                  },
                  child: const Text('Reset View'),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.clear();
                    _addGridPattern();
                  },
                  child: const Text('Reset Grid'),
                ),
              ],
            ),
          ),
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
                    // Disable the dot grid so we can see our test grid better
                    showDotGrid: false,
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
