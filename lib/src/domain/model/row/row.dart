import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scribble/src/domain/model/row_index/row_index_models.dart';

part 'row.freezed.dart';
part 'row.g.dart';

/// {@template notebook_row}
/// Represents a single row in the line-by-line canvas.
/// Each row has a fixed Y position and dual index support:
/// - rendererIndex: Physical array position (0-based) for canvas operations
/// - normalIndex: User-visible line number (1-based, nullable for image rows)
/// {@endtemplate}
@Freezed()
abstract class NotebookRow with _$NotebookRow {
  /// {@macro notebook_row}
  const factory NotebookRow({
    /// The Y coordinate where the row line is positioned.
    required double startY,

    /// The renderer index - physical array position (0-based) for canvas operations.
    /// This maps directly to the position in the _rows array.
    required int rendererIndex,

    /// The normal index - user-visible line number (1-based).
    /// This is null for rows that contain image rows or free drawing spaces,
    /// since they don't have user-visible line numbers.
    int? normalIndex,

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

  /// Whether this row has a user-visible line number.
  bool get hasNormalIndex => normalIndex != null;

  /// Whether this row is used for text content (has a normal index).
  bool get isTextRow => hasNormalIndex;

  /// Whether this row contains non-text content (image row, free space).
  bool get isNonTextRow => !hasNormalIndex;

  /// Creates a RowIndex for this row's renderer index.
  RowIndex get rendererRowIndex => RowIndex.renderer(rendererIndex);

  /// Creates a RowIndex for this row's normal index, if it exists.
  RowIndex? get normalRowIndex {
    if (normalIndex == null) return null;
    return RowIndex.normal(normalIndex!);
  }

  /// Creates a new row with updated renderer index.
  NotebookRow withRendererIndex(int newRendererIndex) {
    return copyWith(rendererIndex: newRendererIndex);
  }

  /// Creates a new row with updated normal index.
  NotebookRow withNormalIndex(int? newNormalIndex) {
    return copyWith(normalIndex: newNormalIndex);
  }

  /// Creates a new row with both indices updated.
  NotebookRow withIndices({
    required int rendererIndex,
    int? normalIndex,
  }) {
    return copyWith(
      rendererIndex: rendererIndex,
      normalIndex: normalIndex,
    );
  }

  @override
  String toString() {
    final normalStr = normalIndex != null 
        ? 'normal: $normalIndex' 
        : 'no normal index';
    return 'NotebookRow(renderer: $rendererIndex, $normalStr, startY: $startY)';
  }
}
