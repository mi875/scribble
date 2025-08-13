import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:scribble/scribble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScrollableMediaCanvas Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScrollableMediaCanvasDemo(),
    );
  }
}

class ScrollableMediaCanvasDemo extends StatefulWidget {
  const ScrollableMediaCanvasDemo({super.key});

  @override
  State<ScrollableMediaCanvasDemo> createState() =>
      _ScrollableMediaCanvasDemoState();
}

class _ScrollableMediaCanvasDemoState extends State<ScrollableMediaCanvasDemo> {
  late final MediaCanvasNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = MediaCanvasNotifier(pages: []);
    _loadPages();
  }

  Future<void> _loadPages() async {
    // Page 1: Sketch only
    _notifier.addPage(
      const MediaPage(
        sketch: Sketch(lines: []),
        size: Size(400, 600),
      ),
    );

    // Page 2: PDF
    final pdfPath = await _loadPdf();
    if (pdfPath != null) {
      _notifier.addPage(
        MediaPage(
          sketch: const Sketch(lines: []),
          size: const Size(400, 600),
          mediaType: MediaType.pdf,
          pdfPath: pdfPath,
        ),
      );
    }
    setState(() {});
  }

  Future<String?> _loadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/sample.pdf');
      if (await file.exists()) {
        return file.path;
      }
      final response = await http.get(Uri.parse('https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'));
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e) {
      print('Failed to load PDF: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScrollableMediaCanvas Demo'),
      ),
      body: ScrollableMediaCanvas(
        notifier: _notifier,
        showRowLines: true,
      ),
    );
  }
}
