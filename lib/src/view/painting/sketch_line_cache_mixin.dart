import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
    required double scaleFactor,
    required bool simulatePressure,
    double? devicePixelRatio,
  }) async {
    if (line.points.length < 2) return null;

    final pathGenerator = LinePathGenerator(
      simulatePressure: simulatePressure,
    );

    // Generate the logical path using the same scaleFactor as live drawing
    // This ensures stroke width consistency between live and cached rendering
    final logicalPath = pathGenerator.getPathForLine(line, scaleFactor: scaleFactor);
    if (logicalPath == null) {
      return null;
    }
    final strokeBounds = logicalPath.getBounds();

    // Padding calculation using actual stroke width scaled properly
    final padding = (line.width * scaleFactor) / 2;
    // Use device pixel ratio for cache resolution, not the scaleFactor
    const baseResolution = 1.5; // Increased from 1.25
    final actualDevicePixelRatio = (devicePixelRatio ?? 1.0).clamp(1.0, 3.0);
    final resolution = baseResolution * actualDevicePixelRatio;

    // Calculate the dimensions of the cache image itself
    final cacheImageWidthUnclamped =
        (strokeBounds.width + padding * 2) * resolution;
    final cacheImageHeightUnclamped =
        (strokeBounds.height + padding * 2) * resolution;

    // Ensure dimensions are valid and clamp to a max size
    // Increased max size for better quality on high-DPI displays
    final clampedWidth =
        cacheImageWidthUnclamped.clamp(1.0, 4096.0);
    final clampedHeight =
        cacheImageHeightUnclamped.clamp(1.0, 4096.0);

    // If the clamped size is too small, don't bother caching.
    if (clampedWidth <= 1.0 || clampedHeight <= 1.0) {
      return null;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, clampedWidth, clampedHeight),
    );

    // Scale the canvas for the desired resolution only
    // The path was generated with scaleFactor, so we only need resolution scaling
    canvas
      ..scale(resolution, resolution)
      ..translate(-strokeBounds.left + padding, -strokeBounds.top + padding);

    // Draw the logical path with enhanced quality
    final paint = Paint()
      ..color = Color(line.color)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(logicalPath, paint);

    // End the recording
    final picture = recorder.endRecording();

    // Create image from the picture
    try {
      return await picture.toImage(clampedWidth.toInt(), clampedHeight.toInt());
    } catch (e) {
      // If there's an error (e.g., out of memory), return null
      // In production, use proper logging instead of print
      debugPrint('Failed to create image for line: $e');
      return null;
    }
  }

  /// Draw a cached line into the canvas
  void drawCachedLine(Canvas canvas, SketchLine line, Rect bounds) {
    if (line.cachedImage == null) return;

    final cachedImage = line.cachedImage!;
    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

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

/// Helper class to access the path generation functionality.
/// 
/// This class provides access to the [SketchLinePathMixin] methods
/// for generating smooth paths from sketch lines.
class LinePathGenerator with SketchLinePathMixin {
  /// Creates a new [LinePathGenerator] instance.
  /// 
  /// The [simulatePressure] parameter determines whether pressure
  /// simulation should be applied to lines without pressure data.
  LinePathGenerator({required this.simulatePressure});

  @override
  final bool simulatePressure;
}
