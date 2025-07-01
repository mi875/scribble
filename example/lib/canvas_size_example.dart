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
  Size? displaySize;
  bool useFiniteCanvas = true;
  bool hasBackgroundImage = false;
  Size? backgroundImageSize;
  Offset backgroundImageOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier(
        fixedStrokeWidth: 2.0,
        allowedPointersMode: ScribblePointerMode.mouseAndPen,
        canvasSize: canvasSize);
  }

  void _resetView() {
    ScribbleInteractive.resetView(context);
  }

  void _updateCanvasSize(Size? newSize) {
    setState(() {
      if (newSize != null) {
        canvasSize = newSize;
      }
      final oldSketch = notifier.currentSketch;
      notifier.dispose();
      notifier = ScribbleNotifier(
        fixedStrokeWidth: 2.0,
        allowedPointersMode: ScribblePointerMode.mouseAndPen,
        canvasSize: useFiniteCanvas ? (newSize ?? canvasSize) : null,
        sketch: oldSketch,
      );
    });
  }

  void _updateDisplaySize(Size? newSize) {
    setState(() {
      displaySize = newSize;
    });
  }

  void _toggleBackgroundImage() {
    setState(() {
      hasBackgroundImage = !hasBackgroundImage;
      if (hasBackgroundImage) {
        notifier.setBackgroundImageWithSizeAndOffset(
          _createGradientImageProvider(),
          backgroundImageSize,
          backgroundImageOffset,
        );
      } else {
        notifier.clearBackgroundImage();
      }
    });
  }

  void _updateBackgroundImageSize(Size? newSize) {
    setState(() {
      backgroundImageSize = newSize;
      if (hasBackgroundImage) {
        notifier.setBackgroundImageSize(newSize);
      }
    });
  }

  void _updateBackgroundImageOffset(Offset newOffset) {
    setState(() {
      backgroundImageOffset = newOffset;
      if (hasBackgroundImage) {
        notifier.setBackgroundImageOffset(newOffset);
      }
    });
  }

  ImageProvider _createGradientImageProvider() {
    return const NetworkImage(
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Canvas & Display Size Example with Background Image'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
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
                ElevatedButton(
                  onPressed: _toggleBackgroundImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasBackgroundImage ? Colors.orange : Colors.grey,
                  ),
                  child: Text(hasBackgroundImage
                      ? 'Remove Background'
                      : 'Add Background'),
                ),
                if (hasBackgroundImage) ...[
                  const SizedBox(height: 16),
                  const Text('Background Image Size:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Checkbox(
                        value: backgroundImageSize != null,
                        onChanged: (value) {
                          if (value == true) {
                            _updateBackgroundImageSize(const Size(200, 150));
                          } else {
                            _updateBackgroundImageSize(null);
                          }
                        },
                      ),
                      const Text('Use custom size'),
                    ],
                  ),
                  if (backgroundImageSize != null) ...[
                    Text(
                        'Background Size: ${backgroundImageSize!.width.toInt()} x ${backgroundImageSize!.height.toInt()}'),
                    Row(
                      children: [
                        const Text('Width: '),
                        Expanded(
                          child: Slider(
                            value: backgroundImageSize!.width,
                            min: 50,
                            max: 600,
                            divisions: 55,
                            onChanged: (value) {
                              final newSize =
                                  Size(value, backgroundImageSize!.height);
                              _updateBackgroundImageSize(newSize);
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
                            value: backgroundImageSize!.height,
                            min: 50,
                            max: 500,
                            divisions: 45,
                            onChanged: (value) {
                              final newSize =
                                  Size(backgroundImageSize!.width, value);
                              _updateBackgroundImageSize(newSize);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text('Background Image Position:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'Offset: (${backgroundImageOffset.dx.toInt()}, ${backgroundImageOffset.dy.toInt()})'),
                  Row(
                    children: [
                      const Text('X: '),
                      Expanded(
                        child: Slider(
                          value: backgroundImageOffset.dx,
                          min: -200,
                          max: 200,
                          divisions: 80,
                          onChanged: (value) {
                            final newOffset =
                                Offset(value, backgroundImageOffset.dy);
                            _updateBackgroundImageOffset(newOffset);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Y: '),
                      Expanded(
                        child: Slider(
                          value: backgroundImageOffset.dy,
                          min: -200,
                          max: 200,
                          divisions: 80,
                          onChanged: (value) {
                            final newOffset =
                                Offset(backgroundImageOffset.dx, value);
                            _updateBackgroundImageOffset(newOffset);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
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
                  Row(children: [
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
                  ]),
                ],
                const SizedBox(height: 16),
                const Text('Display Size Controls:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('Controls the widget size. When unchecked, widget expands to fill available space.',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Row(
                  children: [
                    Checkbox(
                      value: displaySize != null,
                      onChanged: (value) {
                        if (value == true) {
                          _updateDisplaySize(const Size(300, 200));
                        } else {
                          _updateDisplaySize(null);
                        }
                      },
                    ),
                    const Text('Use custom display size'),
                  ],
                ),
                if (displaySize != null) ...[
                  Text(
                      'Display Size: ${displaySize!.width.toInt()} x ${displaySize!.height.toInt()}'),
                  Row(
                    children: [
                      const Text('Width: '),
                      Expanded(
                        child: Slider(
                          value: displaySize!.width,
                          min: 150,
                          max: 800,
                          divisions: 65,
                          onChanged: (value) {
                            final newSize = Size(value, displaySize!.height);
                            _updateDisplaySize(newSize);
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
                          value: displaySize!.height,
                          min: 100,
                          max: 600,
                          divisions: 50,
                          onChanged: (value) {
                            final newSize = Size(displaySize!.width, value);
                            _updateDisplaySize(newSize);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ])),
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
                        width: (displaySize ?? canvasSize).width,
                        height: (displaySize ?? canvasSize).height,
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
                            canvasSize: canvasSize,
                            displaySize: displaySize,
                            backgroundImageFit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: ScribbleInteractive(
                          notifier: notifier,
                          fixedStrokeWidth: 2.0,
                          canvasSize: canvasSize,
                          displaySize: displaySize,
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
