import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/row/row.dart';
import 'package:scribble/src/view/painting/dynamic_row_line_painter.dart';
import 'package:scribble/src/view/painting/image_row_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';

/// Utility class for reusing the actual painters from LineByLineCanvas for export.
/// 
/// This ensures 100% visual consistency between the live canvas and exported images
/// by using the exact same rendering pipeline.
class ReusablePainterExport {
  /// Creates painters identical to those used in LineByLineCanvas.
  static PainterStack createPainterStack({
    required Sketch sketch,
    required List<NotebookRow> rows,
    required List<FreeDrawingSpace> freeDrawingSpaces,
    required List<ImageRow> imageRows,
    required Map<String, ui.Image> loadedImages,
    required ScribbleTheme theme,
    required double canvasWidth,
    required double canvasHeight,
    required double rowLineSpacing,
    required double rowLineWidth,
    double leftMargin = 60.0,
    double rightMargin = 20.0,
    double topMargin = 30.0,
    double bottomMargin = 30.0,
    bool simulatePressure = true,
  }) {
    // Create DynamicRowLinePainter (base layer)
    final rowLinePainter = DynamicRowLinePainter(
      paperWidth: canvasWidth,
      paperHeight: canvasHeight,
      lineSpacing: rowLineSpacing,
      lineColor: theme.rowLineColor,
      lineWidth: rowLineWidth,
      sketch: sketch,
      rows: rows,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
      proximityRadius: 40,
      fadeDistance: 80,
      freeDrawingSpaces: freeDrawingSpaces,
      imageRows: imageRows,
    );

    // Create ImageRowPainter (middle layer)
    final imageRowPainter = loadedImages.isNotEmpty
        ? AsyncImageRowPainter(
            imageRows: imageRows,
            canvasWidth: canvasWidth,
            loadedImages: loadedImages,
            leftMargin: leftMargin,
            rightMargin: rightMargin,
            borderColor: theme.rowLineColor.withValues(alpha: 0.5),
          )
        : ImageRowPainter(
            imageRows: imageRows,
            canvasWidth: canvasWidth,
            leftMargin: leftMargin,
            rightMargin: rightMargin,
            borderColor: theme.rowLineColor.withValues(alpha: 0.5),
          );

    // Create ScribblePainter (content layer)
    final scribblePainter = ScribblePainter(
      sketch: sketch,
      scaleFactor: 1,
      simulatePressure: simulatePressure,
      theme: theme,
    );

    return PainterStack(
      rowLinePainter: rowLinePainter,
      imageRowPainter: imageRowPainter,
      scribblePainter: scribblePainter,
    );
  }

  /// Renders a row range using the actual painters with canvas clipping.
  static Future<ByteData> renderRowRange({
    required PainterStack painters,
    required double startY,
    required double endY,
    required double canvasWidth,
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    // Calculate the canvas size for the row range
    final rangeHeight = endY - startY;
    final exportWidth = canvasWidth;
    final exportHeight = rangeHeight;

    // Create a picture recorder to render the content
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Apply clipping to only render the row range
    final clipRect = Rect.fromLTWH(0, 0, exportWidth, exportHeight);
    canvas.clipRect(clipRect);

    // Translate the canvas so that the row range starts at (0, 0)
    canvas.translate(0, -startY);

    // Create the full canvas size for painters (they expect full dimensions)
    final fullCanvasSize = Size(canvasWidth, startY + rangeHeight + 100); // Add buffer

    // Paint each layer in the correct order (same as LineByLineCanvas)
    painters.rowLinePainter.paint(canvas, fullCanvasSize);
    painters.imageRowPainter.paint(canvas, fullCanvasSize);
    painters.scribblePainter.paint(canvas, fullCanvasSize);

    // End recording and create the image
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (exportWidth * pixelRatio).round(),
      (exportHeight * pixelRatio).round(),
    );

    // Convert to byte data
    final byteData = await image.toByteData(format: format);

    // Clean up
    picture.dispose();
    image.dispose();

    if (byteData == null) {
      throw StateError('Failed to render row range to image');
    }

    return byteData;
  }
}

/// Container for the painter stack used in export.
class PainterStack {
  const PainterStack({
    required this.rowLinePainter,
    required this.imageRowPainter,
    required this.scribblePainter,
  });

  final DynamicRowLinePainter rowLinePainter;
  final CustomPainter imageRowPainter; // Can be ImageRowPainter or AsyncImageRowPainter
  final ScribblePainter scribblePainter;
}