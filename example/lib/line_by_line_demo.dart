import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scribble/scribble.dart';
import 'services/image_service.dart';

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
  double selectedWidth = 1.0;
  double selectedEraserWidth = 5.0;
  double rowLineSpacing = 64.0;
  bool sequentialMode = false;

  // Image insertion settings
  double selectedInsertPosition = 100.0;
  double selectedImageHeight = 96.0;
  bool shiftContentWhenInserting = true;

  @override
  void initState() {
    super.initState();
    notifier = LineByLineNotifier(
        allowedPointersMode: ScribblePointerMode.penOnly,
        rowLineSpacing: rowLineSpacing,
        initialCanvasHeight: 400,
        widths: [1],
        eraserWidths: [2, 5, 10]);
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

  /// Picks an image from gallery and inserts it as an image row.
  Future<void> _pickImageFromGallery() async {
    try {
      final imageBytes = await ImageService.pickImageFromGallery();
      if (imageBytes != null) {
        await _insertImageRow(imageBytes);
      }
    } catch (e) {
      _showErrorMessage('Failed to pick image from gallery: $e');
    }
  }

  /// Picks an image from camera and inserts it as an image row.
  Future<void> _pickImageFromCamera() async {
    try {
      final imageBytes = await ImageService.pickImageFromCamera();
      if (imageBytes != null) {
        await _insertImageRow(imageBytes);
      }
    } catch (e) {
      _showErrorMessage('Failed to pick image from camera: $e');
    }
  }

  /// Inserts an image row with the provided bytes.
  Future<void> _insertImageRow(Uint8List imageBytes) async {
    try {
      // Validate the image
      if (!ImageService.isValidImage(imageBytes)) {
        _showErrorMessage('Invalid image format');
        return;
      }

      // Get image dimensions to calculate appropriate height
      final dimensions = await ImageService.getImageDimensions(imageBytes);
      
      if (!mounted) return; // Check if widget is still mounted
      double height = selectedImageHeight;
      
      if (dimensions != null) {
        // Adjust height based on aspect ratio if needed
        const maxWidth = 300.0; // Approximate canvas width minus margins
        final scaledHeight = maxWidth / dimensions.aspectRatio;
        height = scaledHeight.clamp(48.0, 300.0);
      }

      notifier.insertImageRowWithBytes(
        selectedInsertPosition,
        imageBytes,
        height: height,
        shiftContent: shiftContentWhenInserting,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Image row inserted at Y: ${selectedInsertPosition.round()}'
            '${dimensions != null ? ' ($dimensions)' : ''}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      _showErrorMessage('Error inserting image row: $e');
    }
  }

  /// Shows an error message to the user.
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }


  /// Deletes an image row at the current position.
  void _deleteImageRowAtPosition() {
    try {
      notifier.deleteImageRow(selectedInsertPosition);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image row deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No image row found at position ${selectedInsertPosition.round()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: "Show PNG Image",
            onPressed: () => _showImage(context),
          ),
          IconButton(
              icon: const Icon(Icons.highlight),
              tooltip: "Highlight Line 3",
              onPressed: () {
                // Toggle highlight for line number 3 (what users see on screen)
                notifier..highlightRows([1, 2, 3]);
              })
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
                              Text(
                                  'Height: ${notifier.canvasHeight.round()}px'),
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
                                          ? (isDark
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade800)
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

                  // Eraser Controls
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eraser Controls',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          
                          // Mode Toggle Buttons
                          ValueListenableBuilder(
                            valueListenable: notifier,
                            builder: (context, state, _) {
                              final isErasing = state is Erasing;
                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => notifier.setDrawing(),
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Pen'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: !isErasing 
                                            ? Theme.of(context).colorScheme.primary
                                            : null,
                                        foregroundColor: !isErasing 
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => notifier.setEraser(),
                                      icon: const Icon(Icons.cleaning_services, size: 16),
                                      label: const Text('Eraser'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isErasing 
                                            ? Theme.of(context).colorScheme.secondary
                                            : null,
                                        foregroundColor: isErasing 
                                            ? Theme.of(context).colorScheme.onSecondary
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 12),
                          
                          // Eraser Width Slider
                          ValueListenableBuilder(
                            valueListenable: notifier,
                            builder: (context, state, _) {
                              final isErasing = state is Erasing;
                              return AnimatedOpacity(
                                opacity: isErasing ? 1.0 : 0.5,
                                duration: const Duration(milliseconds: 200),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Eraser Width: ${selectedEraserWidth.toStringAsFixed(1)}px',
                                        style: const TextStyle(fontSize: 12)),
                                    Slider(
                                      value: selectedEraserWidth,
                                      min: 2.0,
                                      max: 20.0,
                                      divisions: 18,
                                      onChanged: (v) {
                                        setState(() => selectedEraserWidth = v);
                                        notifier.setEraserWidth(v);
                                      },
                                    ),
                                  ],
                                ),
                              );
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
                            max: 72,
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

                  const SizedBox(height: 16),

                  // Image Row Settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Image Rows',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 12),

                          // Insert Position
                          Text(
                              'Insert Position: ${selectedInsertPosition.round()}px',
                              style: const TextStyle(fontSize: 12)),
                          Slider(
                            value: selectedInsertPosition,
                            min: 50,
                            max: 500,
                            divisions: 45,
                            onChanged: (v) {
                              setState(() => selectedInsertPosition = v);
                            },
                          ),

                          const SizedBox(height: 8),

                          // Image Height
                          Text('Image Height: ${selectedImageHeight.round()}px',
                              style: const TextStyle(fontSize: 12)),
                          Slider(
                            value: selectedImageHeight,
                            min: 48,
                            max: 200,
                            divisions: 19,
                            onChanged: (v) {
                              setState(() => selectedImageHeight = v);
                            },
                          ),

                          const SizedBox(height: 12),

                          // Shift Content Option
                          CheckboxListTile(
                            title: const Text('Shift content when inserting'),
                            subtitle: const Text('Move strokes down to make space'),
                            value: shiftContentWhenInserting,
                            onChanged: (value) {
                              setState(() => shiftContentWhenInserting = value ?? true);
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),

                          const SizedBox(height: 8),

                          // Insert Images
                          Text('Insert Image:',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          
                          // Gallery Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _pickImageFromGallery,
                              icon: const Icon(Icons.photo_library, size: 16),
                              label: const Text('From Gallery'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Camera Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _pickImageFromCamera,
                              icon: const Icon(Icons.photo_camera, size: 16),
                              label: const Text('From Camera'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Delete Image Row Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _deleteImageRowAtPosition,
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: const Text('Delete Image Row'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                                side: BorderSide(color: Colors.red.shade300),
                              ),
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

          // Right Panel - Canvas
          Expanded(
            child: Container(
              color: isDark
                  ? theme.colorScheme.surfaceContainerLowest
                  : Colors.grey.shade100,
              child: LineByLineCanvas(
                notifier: notifier,
                simulatePressure: false,
                drawEraser: true,
                showPaperShadow: true,
                showPaperBorder: true,
                canvasWidth: 700,
                themeMode: ScribbleThemeMode.system,
                sequentialMode: sequentialMode,
                rowLineWidth: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
