import 'package:flutter/material.dart';

import 'package:scribble/src/domain/model/region/region_settings.dart';
import 'package:scribble/src/domain/model/region/region_type.dart';

/// A region within a notebook page that defines a specific drawing area.
@immutable
class PageRegion {
  /// Creates a page region.
  const PageRegion({
    required this.bounds,
    required this.type,
    this.settings = const RegionSettings(),
    this.preset,
  });

  /// The rectangular bounds of this region within the page coordinate system.
  final Rect bounds;

  /// The type of region (structured or free drawing).
  final RegionType type;

  /// Visual and behavioral settings for this region.
  final RegionSettings settings;

  /// The preset type if this is a free drawing region with predefined settings.
  final FreeDrawingPreset? preset;

  /// Creates a structured region (with row lines and constraints).
  factory PageRegion.structured({
    required Rect bounds,
  }) {
    return PageRegion(
      bounds: bounds,
      type: RegionType.structured,
      settings: RegionSettings.structured,
    );
  }

  /// Creates a free drawing region with the specified preset.
  factory PageRegion.freeDrawing({
    required Rect bounds,
    required FreeDrawingPreset preset,
  }) {
    final settings = switch (preset) {
      FreeDrawingPreset.math => RegionSettings.math,
      FreeDrawingPreset.graph => RegionSettings.graph,
      FreeDrawingPreset.diagram => RegionSettings.diagram,
      FreeDrawingPreset.sketch => RegionSettings.sketch,
      FreeDrawingPreset.custom => RegionSettings.freeDrawing,
    };

    return PageRegion(
      bounds: bounds,
      type: RegionType.freeDrawing,
      settings: settings,
      preset: preset,
    );
  }

  /// Creates a copy of this region with the specified changes.
  PageRegion copyWith({
    Rect? bounds,
    RegionType? type,
    RegionSettings? settings,
    FreeDrawingPreset? preset,
  }) {
    return PageRegion(
      bounds: bounds ?? this.bounds,
      type: type ?? this.type,
      settings: settings ?? this.settings,
      preset: preset ?? this.preset,
    );
  }

  /// Whether the given point is within this region.
  bool contains(Offset point) {
    return bounds.contains(point);
  }

  /// Whether this region intersects with another region.
  bool intersects(PageRegion other) {
    return bounds.overlaps(other.bounds);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PageRegion &&
        other.bounds == bounds &&
        other.type == type &&
        other.settings == settings &&
        other.preset == preset;
  }

  @override
  int get hashCode {
    return Object.hash(bounds, type, settings, preset);
  }

  @override
  String toString() {
    return 'PageRegion(bounds: $bounds, type: $type, preset: $preset)';
  }
}
