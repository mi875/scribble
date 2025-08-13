import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/domain/model/region/page_region.dart';
import 'package:scribble/src/domain/model/region/region_type.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';

/// Represents a single page in a notebook with a fixed paper size and content.
@immutable
class NotebookPage {
  /// Creates a new notebook page with the specified properties.
  const NotebookPage({
    required this.id,
    required this.paperSize,
    this.sketch = const Sketch(lines: []),
    this.backgroundColor,
    this.regions = const <PageRegion>[],
  });

  /// Creates a new blank page with the specified paper size.
  factory NotebookPage.blank({
    required String id,
    required PaperSize paperSize,
    Color? backgroundColor,
  }) {
    return NotebookPage(
      id: id,
      paperSize: paperSize,
      backgroundColor: backgroundColor,
    );
  }

  /// Unique identifier for this page.
  final String id;

  /// The paper size that defines the dimensions of this page.
  final PaperSize paperSize;

  /// The sketch content drawn on this page.
  final Sketch sketch;

  /// Optional background color for the page. If null, uses default paper color.
  final Color? backgroundColor;

  /// List of regions within this page that define specific drawing areas.
  final List<PageRegion> regions;

  /// Creates a copy of this page with optional overrides.
  NotebookPage copyWith({
    String? id,
    PaperSize? paperSize,
    Sketch? sketch,
    Color? backgroundColor,
    List<PageRegion>? regions,
  }) {
    return NotebookPage(
      id: id ?? this.id,
      paperSize: paperSize ?? this.paperSize,
      sketch: sketch ?? this.sketch,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      regions: regions ?? this.regions,
    );
  }

  /// Returns true if this page has no content (empty sketch).
  bool get isEmpty => sketch.lines.isEmpty;

  /// Returns true if this page has content.
  bool get isNotEmpty => sketch.lines.isNotEmpty;

  /// Returns the region that contains the given point, or null if none found.
  PageRegion? getRegionAt(Offset point) {
    for (final region in regions) {
      if (region.contains(point)) {
        return region;
      }
    }
    return null;
  }

  /// Returns all free drawing regions on this page.
  List<PageRegion> get freeDrawingRegions {
    return regions.where((region) => region.type == RegionType.freeDrawing).toList();
  }

  /// Returns all structured regions on this page.
  List<PageRegion> get structuredRegions {
    return regions.where((region) => region.type == RegionType.structured).toList();
  }

  /// Creates a copy of this page with an added region.
  NotebookPage withAddedRegion(PageRegion region) {
    return copyWith(regions: [...regions, region]);
  }

  /// Creates a copy of this page with a removed region.
  NotebookPage withRemovedRegion(PageRegion region) {
    final newRegions = regions.where((r) => r != region).toList();
    return copyWith(regions: newRegions);
  }

  /// Creates a copy of this page with an updated region.
  NotebookPage withUpdatedRegion(PageRegion oldRegion, PageRegion newRegion) {
    final newRegions = regions.map((r) => r == oldRegion ? newRegion : r).toList();
    return copyWith(regions: newRegions);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotebookPage &&
        other.id == id &&
        other.paperSize == paperSize &&
        other.sketch == sketch &&
        other.backgroundColor == backgroundColor &&
        other.regions == regions;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        paperSize.hashCode ^
        sketch.hashCode ^
        backgroundColor.hashCode ^
        regions.hashCode;
  }

  @override
  String toString() {
    return 'NotebookPage(id: $id, paperSize: $paperSize, '
        'sketch: $sketch, backgroundColor: $backgroundColor)';
  }
}
