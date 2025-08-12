import 'package:flutter/material.dart';

/// Settings for a page region that control its appearance and behavior.
class RegionSettings {
  /// Creates region settings.
  const RegionSettings({
    this.showBackground = true,
    this.showBorder = true,
    this.backgroundColor,
    this.borderColor = Colors.grey,
    this.borderWidth = 1,
    this.showGrid = false,
    this.gridSpacing = 20,
    this.gridColor = Colors.grey,
    this.opacity = 0.1,
  });

  /// Whether to show a subtle background tint for visual distinction
  final bool showBackground;
  
  /// Whether to show border lines around the region
  final bool showBorder;
  
  /// Background color for the region (null for transparent)
  final Color? backgroundColor;
  
  /// Border color for the region
  final Color borderColor;
  
  /// Border width in logical pixels
  final double borderWidth;
  
  /// Whether to show a grid overlay within free drawing regions
  final bool showGrid;
  
  /// Grid spacing for overlay (if enabled)
  final double gridSpacing;
  
  /// Grid color for overlay
  final Color gridColor;
  
  /// Opacity for all region visual elements
  final double opacity;
  
  /// Default settings for structured regions.
  static const structured = RegionSettings(
    showBackground: false,
    showBorder: false,
    opacity: 0,
  );
  
  /// Default settings for free drawing regions.
  static const freeDrawing = RegionSettings(
    backgroundColor: Color(0xFFF8F9FA), // Very light gray
    borderColor: Color(0xFFE9ECEF), // Light gray border
    opacity: 0.3,
  );
  
  /// Settings optimized for mathematical content.
  static const math = RegionSettings(
    backgroundColor: Color(0xFFF0F8FF), // Light blue tint
    borderColor: Color(0xFFE1F5FE),
    opacity: 0.2,
  );
  
  /// Settings optimized for graphs and charts.
  static const graph = RegionSettings(
    showGrid: true,
    gridSpacing: 15,
    backgroundColor: Color(0xFFF9FFF9), // Very light green
    borderColor: Color(0xFFE8F5E8),
    gridColor: Color(0xFFE8F5E8),
    opacity: 0.3,
  );
  
  /// Settings optimized for diagrams and flowcharts.
  static const diagram = RegionSettings(
    backgroundColor: Color(0xFFFFF8F0), // Very light orange
    borderColor: Color(0xFFFFF2E1),
    opacity: 0.25,
  );
  
  /// Settings for general sketching.
  static const sketch = RegionSettings(
    backgroundColor: Color(0xFFFFFFF8), // Very light yellow
    borderColor: Color(0xFFFFFEF5),
    opacity: 0.15,
  );
}
