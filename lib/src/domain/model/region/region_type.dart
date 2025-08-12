/// Types of regions that can exist within a notebook page.
enum RegionType {
  /// Structured region with row lines and constraints
  structured,
  
  /// Free drawing region without lines or constraints
  freeDrawing,
}

/// Preset types for free drawing regions optimized for specific content.
enum FreeDrawingPreset {
  /// Small area optimized for mathematical equations and formulas
  math,
  
  /// Medium area for charts, graphs, and plots
  graph,
  
  /// Area for diagrams, flowcharts, and tables
  diagram,
  
  /// Large unrestricted area for complex sketches
  sketch,
  
  /// Custom size defined by user
  custom,
}

/// Extension to provide default dimensions for free drawing presets.
extension FreeDrawingPresetDimensions on FreeDrawingPreset {
  /// Default height multiplier relative to row spacing
  double get heightMultiplier {
    switch (this) {
      case FreeDrawingPreset.math:
        return 3; // 3x row height for equations
      case FreeDrawingPreset.graph:
        return 8; // 8x row height for graphs
      case FreeDrawingPreset.diagram:
        return 6; // 6x row height for diagrams
      case FreeDrawingPreset.sketch:
        return 12; // 12x row height for sketches
      case FreeDrawingPreset.custom:
        return 4; // Default for custom
    }
  }
  
  /// Display name for UI
  String get displayName {
    switch (this) {
      case FreeDrawingPreset.math:
        return 'Math';
      case FreeDrawingPreset.graph:
        return 'Graph';
      case FreeDrawingPreset.diagram:
        return 'Diagram';
      case FreeDrawingPreset.sketch:
        return 'Sketch';
      case FreeDrawingPreset.custom:
        return 'Custom';
    }
  }
  
  /// Description for UI
  String get description {
    switch (this) {
      case FreeDrawingPreset.math:
        return 'For equations and formulas';
      case FreeDrawingPreset.graph:
        return 'For charts and plots';
      case FreeDrawingPreset.diagram:
        return 'For flowcharts and tables';
      case FreeDrawingPreset.sketch:
        return 'For complex drawings';
      case FreeDrawingPreset.custom:
        return 'Custom size';
    }
  }
}
