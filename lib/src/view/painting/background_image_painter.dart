import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A [CustomPainter] that draws a background image with proper scaling and positioning.
class BackgroundImagePainter extends CustomPainter {
  /// Creates a [BackgroundImagePainter] with the given parameters.
  const BackgroundImagePainter({
    required this.image,
    required this.scaleFactor,
    required this.panOffset,
    this.canvasSize,
    this.backgroundImageSize,
    this.backgroundImageOffset = Offset.zero,
    this.fit = BoxFit.contain,
  });

  /// The image to paint as background.
  final ui.Image image;

  /// The current scale factor for zoom.
  final double scaleFactor;

  /// The current pan offset.
  final Offset panOffset;

  /// The canvas size constraint, if any.
  final Size? canvasSize;

  /// The size of the background image, if specified.
  final Size? backgroundImageSize;

  /// The position/offset of the background image.
  final Offset backgroundImageOffset;

  /// How the image should be fit within the canvas.
  final BoxFit fit;

  @override
  void paint(Canvas canvas, Size size) {
    // Apply transformations in the same order as the sketch painter
    canvas.save();

    // If canvas size is specified, clip to it
    if (canvasSize != null) {
      canvas
          .clipRect(Rect.fromLTWH(0, 0, canvasSize!.width, canvasSize!.height));
    }

    // Apply pan offset
    canvas.translate(panOffset.dx, panOffset.dy);

    // Apply scale
    canvas.scale(scaleFactor);

    // Apply background image offset
    canvas.translate(backgroundImageOffset.dx, backgroundImageOffset.dy);

    // Calculate the destination rectangle
    final targetSize = backgroundImageSize ?? canvasSize ?? size;
    final destRect = Rect.fromLTWH(0, 0, targetSize.width, targetSize.height);

    // Calculate source rectangle based on fit
    final sourceRect = _calculateSourceRect(image, destRect, fit);

    // Paint the image
    canvas.drawImageRect(
      image,
      sourceRect,
      destRect,
      Paint()
        ..filterQuality = FilterQuality.high
        ..isAntiAlias = true,
    );

    canvas.restore();
  }

  /// Calculates the source rectangle for the image based on the fit mode.
  Rect _calculateSourceRect(ui.Image image, Rect destRect, BoxFit fit) {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final destSize = destRect.size;

    switch (fit) {
      case BoxFit.fill:
        // Use the entire image
        return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);

      case BoxFit.contain:
        // Scale the image to fit entirely within the destination while maintaining aspect ratio
        final scale = (destSize.width / imageSize.width)
                    .compareTo(destSize.height / imageSize.height) <=
                0
            ? destSize.width / imageSize.width
            : destSize.height / imageSize.height;

        if (scale >= 1.0) {
          // Image is smaller than destination, use entire image
          return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
        } else {
          // Image is larger, use entire image and let it be scaled by the paint operation
          return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
        }

      case BoxFit.cover:
        // Scale the image to cover the entire destination while maintaining aspect ratio
        final scale = (destSize.width / imageSize.width)
                    .compareTo(destSize.height / imageSize.height) >=
                0
            ? destSize.width / imageSize.width
            : destSize.height / imageSize.height;

        final scaledImageSize =
            Size(imageSize.width * scale, imageSize.height * scale);

        // Calculate which part of the image to show (center crop)
        final offsetX = (scaledImageSize.width - destSize.width) / (2 * scale);
        final offsetY =
            (scaledImageSize.height - destSize.height) / (2 * scale);

        return Rect.fromLTWH(
          offsetX.clamp(0, imageSize.width),
          offsetY.clamp(0, imageSize.height),
          (destSize.width / scale).clamp(0, imageSize.width - offsetX),
          (destSize.height / scale).clamp(0, imageSize.height - offsetY),
        );

      case BoxFit.fitWidth:
        final scale = destSize.width / imageSize.width;
        final scaledHeight = imageSize.height * scale;

        if (scaledHeight <= destSize.height) {
          // Entire image fits vertically
          return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
        } else {
          // Crop vertically from center
          final cropHeight = destSize.height / scale;
          final offsetY = (imageSize.height - cropHeight) / 2;
          return Rect.fromLTWH(0, offsetY, imageSize.width, cropHeight);
        }

      case BoxFit.fitHeight:
        final scale = destSize.height / imageSize.height;
        final scaledWidth = imageSize.width * scale;

        if (scaledWidth <= destSize.width) {
          // Entire image fits horizontally
          return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
        } else {
          // Crop horizontally from center
          final cropWidth = destSize.width / scale;
          final offsetX = (imageSize.width - cropWidth) / 2;
          return Rect.fromLTWH(offsetX, 0, cropWidth, imageSize.height);
        }

      case BoxFit.none:
        // Use image at original size, centered
        final offsetX = (imageSize.width - destSize.width) / 2;
        final offsetY = (imageSize.height - destSize.height) / 2;

        return Rect.fromLTWH(
          offsetX.clamp(0, imageSize.width),
          offsetY.clamp(0, imageSize.height),
          destSize.width.clamp(0, imageSize.width),
          destSize.height.clamp(0, imageSize.height),
        );

      case BoxFit.scaleDown:
        // Like contain, but never scale up
        if (imageSize.width <= destSize.width &&
            imageSize.height <= destSize.height) {
          // Image fits entirely, use entire image
          return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
        } else {
          // Scale down like contain
          return _calculateSourceRect(image, destRect, BoxFit.contain);
        }
    }
  }

  @override
  bool shouldRepaint(BackgroundImagePainter oldDelegate) {
    return image != oldDelegate.image ||
        scaleFactor != oldDelegate.scaleFactor ||
        panOffset != oldDelegate.panOffset ||
        canvasSize != oldDelegate.canvasSize ||
        backgroundImageSize != oldDelegate.backgroundImageSize ||
        backgroundImageOffset != oldDelegate.backgroundImageOffset ||
        fit != oldDelegate.fit;
  }
}
