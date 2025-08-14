import 'package:freezed_annotation/freezed_annotation.dart';

part 'row.freezed.dart';
part 'row.g.dart';

/// {@template notebook_row}
/// Represents a single row in the line-by-line canvas.
/// Each row has a fixed Y position and properties for layout.
/// {@endtemplate}
@Freezed()
abstract class NotebookRow with _$NotebookRow {
  /// {@macro notebook_row}
  const factory NotebookRow({
    /// The Y coordinate where the row line is positioned.
    required double startY,

    /// The zero-based index of this row.
    required int index,

    /// The height/spacing of this row (distance to next row).
    /// Defaults to the standard row line spacing.
    @Default(24.0) double height,

    /// Optional identifier for the row.
    String? id,
  }) = _NotebookRow;

  const NotebookRow._();

  /// Constructs a row from a JSON object.
  factory NotebookRow.fromJson(Map<String, dynamic> json) => _$NotebookRowFromJson(json);

  /// The Y coordinate where this row ends (start of next row).
  double get endY => startY + height;

  /// Checks if a given Y coordinate is within this row's bounds.
  bool containsY(double y) => y >= startY && y < endY;

  /// Checks if this row overlaps with another Y range.
  bool overlaps(double otherStartY, double otherEndY) {
    return !(endY <= otherStartY || startY >= otherEndY);
  }

  /// Creates a new row moved by the specified Y offset.
  NotebookRow moveBy(double yOffset) {
    return copyWith(startY: startY + yOffset);
  }

  /// Creates a new row with updated height.
  NotebookRow withHeight(double newHeight) {
    return copyWith(height: newHeight);
  }

  /// Creates a new row at the specified Y position.
  NotebookRow withStartY(double newStartY) {
    return copyWith(startY: newStartY);
  }
}
