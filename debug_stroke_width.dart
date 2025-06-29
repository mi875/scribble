import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/sketch_line_cache_mixin.dart';
import 'package:scribble/src/view/painting/sketch_line_path_mixin.dart';

/// Debug script to trace exact numerical flow from live drawing to cached rendering
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print("=== STROKE WIDTH CACHING DEBUG ANALYSIS ===\n");
  
  // Create a test stroke line
  final testLine = SketchLine(
    points: [
      Point(10.0, 10.0, pressure: 0.5),
      Point(50.0, 20.0, pressure: 0.7),
      Point(90.0, 30.0, pressure: 0.5),
    ],
    color: 0xFF000000,
    width: 8.0, // Base width
  );
  
  // Test parameters
  const scaleFactor = 1.5;
  const devicePixelRatio = 2.0;
  const simulatePressure = true;
  
  print("TEST PARAMETERS:");
  print("- Line base width: ${testLine.width}");
  print("- Scale factor: $scaleFactor");
  print("- Device pixel ratio: $devicePixelRatio");
  print("- Simulate pressure: $simulatePressure");
  print("");
  
  // === STEP 1: LIVE DRAWING PATH ===
  print("=== STEP 1: LIVE DRAWING PATH ===");
  
  final livePathGenerator = LivePathGenerator(simulatePressure: simulatePressure);
  final livePath = livePathGenerator.getPathForLine(testLine, scaleFactor: scaleFactor);
  
  if (livePath != null) {
    final liveBounds = livePath.getBounds();
    print("Live path bounds: $liveBounds");
    print("Live path effective width: ${liveBounds.width}");
    print("Live path effective height: ${liveBounds.height}");
    
    // Calculate the effective stroke width from perfect_freehand
    final liveStrokeSize = testLine.width * 2 * scaleFactor;
    print("Live perfect_freehand stroke size: $liveStrokeSize");
  }
  print("");
  
  // === STEP 2: CACHE GENERATION PATH ===
  print("=== STEP 2: CACHE GENERATION PATH ===");
  
  final cacheGenerator = CacheGenerator(simulatePressure: simulatePressure);
  
  // Generate logical path (same as live)
  final cacheLogicalPath = cacheGenerator.getPathForLine(testLine, scaleFactor: scaleFactor);
  
  if (cacheLogicalPath != null) {
    final cacheLogicalBounds = cacheLogicalPath.getBounds();
    print("Cache logical path bounds: $cacheLogicalBounds");
    print("Cache logical path matches live: ${cacheLogicalBounds == livePath?.getBounds()}");
    
    // Calculate cache padding
    final cachePadding = (testLine.width * scaleFactor) / 2;
    print("Cache padding calculation: (${testLine.width} * $scaleFactor) / 2 = $cachePadding");
    
    // Calculate resolution multiplier
    const baseResolution = 1.5;
    final actualDevicePixelRatio = devicePixelRatio.clamp(1.0, 3.0);
    final resolution = baseResolution * actualDevicePixelRatio;
    print("Cache resolution: $baseResolution * $actualDevicePixelRatio = $resolution");
    
    // Calculate cache image dimensions
    final cacheImageWidth = (cacheLogicalBounds.width + cachePadding * 2) * resolution;
    final cacheImageHeight = (cacheLogicalBounds.height + cachePadding * 2) * resolution;
    print("Cache image dimensions: ${cacheImageWidth}x$cacheImageHeight");
    
    // Calculate canvas scaling in cache generation
    final canvasScaleX = resolution / scaleFactor;
    final canvasScaleY = resolution / scaleFactor;
    print("Cache canvas scale: ($resolution / $scaleFactor) = $canvasScaleX, $canvasScaleY");
    
    // The critical scaling issue analysis
    print("\n--- CRITICAL SCALING ANALYSIS ---");
    print("Path generated with stroke size: ${testLine.width * 2 * scaleFactor}");
    print("Canvas scaled by: $canvasScaleX");
    print("Effective cached stroke size: ${(testLine.width * 2 * scaleFactor) * canvasScaleX}");
    print("Should be: ${testLine.width * 2 * resolution}");
    
    final discrepancy = ((testLine.width * 2 * scaleFactor) * canvasScaleX) - (testLine.width * 2 * resolution);
    print("Scaling discrepancy: $discrepancy");
  }
  print("");
  
  // === STEP 3: CACHE DISPLAY PATH ===
  print("=== STEP 3: CACHE DISPLAY PATH ===");
  
  if (livePath != null) {
    final liveBounds = livePath.getBounds();
    final displayPadding = (testLine.width * scaleFactor) / 2;
    
    final displayBounds = Rect.fromLTRB(
      liveBounds.left - displayPadding,
      liveBounds.top - displayPadding,
      liveBounds.right + displayPadding,
      liveBounds.bottom + displayPadding,
    );
    
    print("Display bounds calculation:");
    print("- Live bounds: $liveBounds");
    print("- Display padding: $displayPadding");
    print("- Final display bounds: $displayBounds");
    
    // The cache image would be drawn into displayBounds
    // Calculate the scaling factor applied during drawImageRect
    if (cacheLogicalPath != null) {
      final cacheLogicalBounds = cacheLogicalPath.getBounds();
      final cachePadding = (testLine.width * scaleFactor) / 2;
      const baseResolution = 1.5;
      final actualDevicePixelRatio = devicePixelRatio.clamp(1.0, 3.0);
      final resolution = baseResolution * actualDevicePixelRatio;
      
      final cacheImageWidth = (cacheLogicalBounds.width + cachePadding * 2) * resolution;
      final cacheImageHeight = (cacheLogicalBounds.height + cachePadding * 2) * resolution;
      
      final drawImageScaleX = displayBounds.width / cacheImageWidth;
      final drawImageScaleY = displayBounds.height / cacheImageHeight;
      
      print("\n--- DRAWIMAGERECT SCALING ---");
      print("Cache image size: ${cacheImageWidth}x$cacheImageHeight");
      print("Display bounds size: ${displayBounds.width}x${displayBounds.height}");
      print("DrawImageRect scale: $drawImageScaleX x $drawImageScaleY");
      
      // Calculate final effective stroke width
      final originalStrokeInCache = testLine.width * 2 * scaleFactor * (resolution / scaleFactor);
      final finalStrokeWidth = originalStrokeInCache * drawImageScaleX;
      print("Original stroke in cache: $originalStrokeInCache");
      print("Final displayed stroke width: $finalStrokeWidth");
      print("Expected stroke width: ${testLine.width * 2 * scaleFactor}");
      
      final finalDiscrepancy = finalStrokeWidth - (testLine.width * 2 * scaleFactor);
      print("FINAL DISCREPANCY: $finalDiscrepancy");
    }
  }
  print("");
  
  // === STEP 4: IDENTIFY ROOT CAUSE ===
  print("=== STEP 4: ROOT CAUSE ANALYSIS ===");
  
  print("The issue is in the cache generation canvas scaling:");
  print("1. Path is generated with size: width * 2 * scaleFactor");
  print("2. Canvas is scaled by: resolution / scaleFactor");
  print("3. This effectively scales the stroke by: (resolution / scaleFactor)");
  print("4. When displayed, it's scaled again by the drawImageRect ratio");
  print("");
  print("SOLUTION:");
  print("The path should be generated with size: width * 2 * resolution");
  print("And canvas should NOT be scaled by resolution/scaleFactor");
  print("OR the path should be generated with size: width * 2 * scaleFactor");
  print("And canvas should be scaled by: resolution (not resolution/scaleFactor)");
}

/// Helper class to generate live paths
class LivePathGenerator with SketchLinePathMixin {
  LivePathGenerator({required this.simulatePressure});
  
  @override
  final bool simulatePressure;
}

/// Helper class to generate cache with debugging
class CacheGenerator with SketchLinePathMixin, SketchLineCacheMixin {
  CacheGenerator({required this.simulatePressure});
  
  @override
  final bool simulatePressure;
}