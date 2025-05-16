import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/sketch_line_path_mixin.dart';

/// A mixin for caching sketch lines as images.
mixin SketchLineCacheMixin {
  /// Create a cache image for a sketch line.
  ///
  /// The resolution is automatically calculated based on device pixel ratio.
  /// This ensures optimal quality across different screens.
  Future<ui.Image?> createCacheForLine(
    SketchLine line, {
    required double
        scaleFactor, // This is the device pixel ratio, not used directly for logical path
    required bool simulatePressure,
  }) async {
    if (line.points.length < 2) return null;

    final pathGenerator = LinePathGenerator(
        simulatePressure: simulatePressure); // Changed to LinePathGenerator

    // Generate the logical path for the line (scaleFactor: 1.0 for logical coordinates)
    final logicalPath = pathGenerator.getPathForLine(line, scaleFactor: 1.0);
    if (logicalPath == null) {
      return null;
    }
    final strokeBounds = logicalPath.getBounds();

    // Padding in logical pixels, assuming line.width is the logical diameter
    final padding = line.width / 2;
    const resolution = 1.25; // Fixed resolution factor for cache image quality

    // Calculate the dimensions of the cache image itself (in physical pixels for toImage)
    final double cacheImageWidthUnclamped =
        (strokeBounds.width + padding * 2) * resolution;
    final double cacheImageHeightUnclamped =
        (strokeBounds.height + padding * 2) * resolution;

    // Ensure dimensions are valid and clamp to a max size (in cache image pixels)
    final double clampedWidth = cacheImageWidthUnclamped.clamp(1.0, 3000.0);
    final double clampedHeight = cacheImageHeightUnclamped.clamp(1.0, 3000.0);

    // If the clamped size is too small, don't bother caching.
    if (clampedWidth <= 1.0 || clampedHeight <= 1.0) {
      return null;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromLTWH(0, 0, clampedWidth.toDouble(), clampedHeight.toDouble()));

    // Scale the canvas for the desired resolution.
    // All drawing operations after this are in a coordinate system scaled by 'resolution'.
    canvas.scale(resolution, resolution);

    // Translate so the logical (0,0) of the padded strokeBounds is at (0,0) of this scaled canvas.
    // We are drawing in a space that is (strokeBounds.width + padding*2) wide logically.
    canvas.translate(-strokeBounds.left + padding, -strokeBounds.top + padding);

    // Draw the logical path. The canvas scaling will make it sharp.
    // Paint should use logical line.width, which is handled by getPathForLine.
    final paint = Paint()
      ..color = Color(line.color)
      ..style =
          PaintingStyle.fill // SketchLinePathMixin generates a fillable path
      ..isAntiAlias = true; // Enable anti-aliasing for smoother edges
    canvas.drawPath(logicalPath, paint);

    // End the recording
    final picture = recorder.endRecording();

    // Create image from the picture
    try {
      return await picture.toImage(clampedWidth.toInt(), clampedHeight.toInt());
    } catch (e) {
      // If there's an error (e.g., out of memory for very large lines), return null
      print("Failed to create image for line: $e");
      return null;
    }
  }

  /// Draw a cached line into the canvas
  void drawCachedLine(Canvas canvas, SketchLine line, Rect bounds) {
    if (line.cachedImage == null) return;

    final cachedImage = line.cachedImage!;
    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium; // Balance quality and performance

    // Create a rectangle for the source (entire cached image)
    final src = Rect.fromLTWH(
      0,
      0,
      cachedImage.width.toDouble(),
      cachedImage.height.toDouble(),
    );

    // Draw the cached image using drawImageRect to maintain proper scaling
    canvas.drawImageRect(cachedImage, src, bounds, paint);
  }
}

/// Helper class to access the path generation
class LinePathGenerator with SketchLinePathMixin {
  LinePathGenerator({required this.simulatePressure});

  @override
  final bool simulatePressure;
}
