import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';
import 'package:scribble/src/domain/model/sketch/sketch.dart';

/// Represents a simple page in a notebook with basic content only.
@immutable
class SimpleNotebookPage {
  /// Creates a new simple notebook page with the specified properties.
  const SimpleNotebookPage({
    required this.id,
    required this.paperSize,
    this.sketch = const Sketch(lines: []),
    this.backgroundColor,
  });

  /// Creates a new blank page with the specified paper size.
  factory SimpleNotebookPage.blank({
    required String id,
    required PaperSize paperSize,
    Color? backgroundColor,
  }) {
    return SimpleNotebookPage(
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

  /// Creates a copy of this page with optional overrides.
  SimpleNotebookPage copyWith({
    String? id,
    PaperSize? paperSize,
    Sketch? sketch,
    Color? backgroundColor,
  }) {
    return SimpleNotebookPage(
      id: id ?? this.id,
      paperSize: paperSize ?? this.paperSize,
      sketch: sketch ?? this.sketch,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Returns true if this page has no content (empty sketch).
  bool get isEmpty => sketch.lines.isEmpty;

  /// Returns true if this page has content.
  bool get isNotEmpty => sketch.lines.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SimpleNotebookPage &&
        other.id == id &&
        other.paperSize == paperSize &&
        other.sketch == sketch &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        paperSize.hashCode ^
        sketch.hashCode ^
        backgroundColor.hashCode;
  }

  @override
  String toString() {
    return 'SimpleNotebookPage(id: $id, paperSize: $paperSize, '
        'sketch: $sketch)';
  }

}
