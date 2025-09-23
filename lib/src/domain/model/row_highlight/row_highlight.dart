import 'package:flutter/material.dart';

/// Represents a row highlight with a specific color.
/// 
/// This allows individual rows to have different highlight colors
/// instead of using a single global highlight color for all rows.
@immutable
class RowHighlight {
  /// Creates a new row highlight.
  const RowHighlight({
    required this.index,
    required this.color,
  });

  /// The 1-based line number to highlight (1, 2, 3, etc.).
  /// 
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  final int index;
  
  /// The color to use for highlighting this specific row.
  final Color color;

  /// Creates a copy of this RowHighlight with updated values.
  RowHighlight copyWith({
    int? index,
    Color? color,
  }) {
    return RowHighlight(
      index: index ?? this.index,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RowHighlight &&
        other.index == index &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(index, color);

  @override
  String toString() => 'RowHighlight(index: $index, color: $color)';
}