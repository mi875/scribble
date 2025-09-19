import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:scribble/src/domain/model/image_row/image_row.dart';

/// A custom painter that renders image rows within the canvas.
/// 
/// This painter handles the display of images within designated row spaces,
/// ensuring proper scaling and positioning within row constraints.
class ImageRowPainter extends CustomPainter {
  /// Creates a new image row painter.
  const ImageRowPainter({
    required this.imageRows,
    required this.canvasWidth,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderWidth = 1.0,
    this.showBorders = true,
  });

  /// List of image rows to render.
  final List<ImageRow> imageRows;

  /// Width of the canvas in logical pixels.
  final double canvasWidth;

  /// Left margin in logical pixels.
  final double leftMargin;

  /// Right margin in logical pixels.  
  final double rightMargin;

  /// Color for image row borders.
  final Color borderColor;

  /// Width of image row borders.
  final double borderWidth;

  /// Whether to show borders around image rows.
  final bool showBorders;

  @override
  void paint(Canvas canvas, Size size) {
    if (imageRows.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.9);

    for (final imageRow in imageRows) {
      final rowRect = Rect.fromLTWH(
        leftMargin,
        imageRow.startY,
        canvasWidth - leftMargin - rightMargin,
        imageRow.height,
      );

      // Draw background for image row
      canvas.drawRect(rowRect, fillPaint);

      // Draw image if available
      final imageProvider = imageRow.imageProvider;
      if (imageProvider != null) {
        _drawImageInRect(canvas, imageProvider, rowRect);
      }

      // Draw border if enabled
      if (showBorders) {
        canvas.drawRect(rowRect, paint);
      }
    }
  }

  /// Draws an image within the specified rectangle.
  void _drawImageInRect(Canvas canvas, ImageProvider imageProvider, Rect rect) {
    // Note: This is a simplified approach. In a production implementation,
    // you would need to handle image loading asynchronously and cache the
    // decoded images. For now, we'll draw a placeholder with image info.
    
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade200;
    
    // Draw placeholder background
    canvas.drawRect(rect, paint);
    
    // Draw placeholder text
    final textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
      fontFamily: 'monospace',
    );
    
    final textSpan = TextSpan(
      text: 'Image\n${rect.width.round()}x${rect.height.round()}',
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout();
    
    final textOffset = Offset(
      rect.left + (rect.width - textPainter.width) / 2,
      rect.top + (rect.height - textPainter.height) / 2,
    );
    
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant ImageRowPainter oldDelegate) {
    return imageRows != oldDelegate.imageRows ||
           canvasWidth != oldDelegate.canvasWidth ||
           leftMargin != oldDelegate.leftMargin ||
           rightMargin != oldDelegate.rightMargin ||
           borderColor != oldDelegate.borderColor ||
           borderWidth != oldDelegate.borderWidth ||
           showBorders != oldDelegate.showBorders;
  }
}

/// A custom painter that can render actual images asynchronously.
/// This is a more advanced implementation that handles real image rendering.
class AsyncImageRowPainter extends CustomPainter {
  /// Creates a new async image row painter.
  const AsyncImageRowPainter({
    required this.imageRows,
    required this.canvasWidth,
    required this.loadedImages,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderWidth = 1.0,
    this.showBorders = true,
  });

  /// List of image rows to render.
  final List<ImageRow> imageRows;

  /// Width of the canvas in logical pixels.
  final double canvasWidth;

  /// Map of loaded ui.Image objects keyed by image row ID.
  final Map<String, ui.Image> loadedImages;

  /// Left margin in logical pixels.
  final double leftMargin;

  /// Right margin in logical pixels.  
  final double rightMargin;

  /// Color for image row borders.
  final Color borderColor;

  /// Width of image row borders.
  final double borderWidth;

  /// Whether to show borders around image rows.
  final bool showBorders;

  @override
  void paint(Canvas canvas, Size size) {
    if (imageRows.isEmpty) return;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.9);

    for (final imageRow in imageRows) {
      final rowRect = Rect.fromLTWH(
        leftMargin,
        imageRow.startY,
        canvasWidth - leftMargin - rightMargin,
        imageRow.height,
      );

      // Draw background for image row
      canvas.drawRect(rowRect, fillPaint);

      // Draw actual image if loaded
      final imageId = imageRow.id;
      if (imageId != null && loadedImages.containsKey(imageId)) {
        final image = loadedImages[imageId]!;
        _drawLoadedImage(canvas, image, rowRect);
      }

      // Draw border if enabled
      if (showBorders) {
        canvas.drawRect(rowRect, borderPaint);
      }
    }
  }

  /// Draws a loaded ui.Image within the specified rectangle with proper scaling.
  void _drawLoadedImage(Canvas canvas, ui.Image image, Rect rect) {
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();
    final imageAspectRatio = imageWidth / imageHeight;
    final rectAspectRatio = rect.width / rect.height;

    final srcRect = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
    Rect destRect;

    // Scale to fit while maintaining aspect ratio
    if (imageAspectRatio > rectAspectRatio) {
      // Image is wider - fit to width
      final scaledHeight = rect.width / imageAspectRatio;
      final offsetY = (rect.height - scaledHeight) / 2;
      destRect = Rect.fromLTWH(
        rect.left,
        rect.top + offsetY,
        rect.width,
        scaledHeight,
      );
    } else {
      // Image is taller - fit to height
      final scaledWidth = rect.height * imageAspectRatio;
      final offsetX = (rect.width - scaledWidth) / 2;
      destRect = Rect.fromLTWH(
        rect.left + offsetX,
        rect.top,
        scaledWidth,
        rect.height,
      );
    }

    canvas.drawImageRect(image, srcRect, destRect, Paint());
  }

  @override
  bool shouldRepaint(covariant AsyncImageRowPainter oldDelegate) {
    return imageRows != oldDelegate.imageRows ||
           canvasWidth != oldDelegate.canvasWidth ||
           loadedImages != oldDelegate.loadedImages ||
           leftMargin != oldDelegate.leftMargin ||
           rightMargin != oldDelegate.rightMargin ||
           borderColor != oldDelegate.borderColor ||
           borderWidth != oldDelegate.borderWidth ||
           showBorders != oldDelegate.showBorders;
  }
}