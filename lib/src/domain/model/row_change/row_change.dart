import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scribble/src/domain/model/row/row.dart';

part 'row_change.freezed.dart';
part 'row_change.g.dart';

/// Represents a change that occurred to canvas rows.
@freezed
abstract class RowChangeInfo with _$RowChangeInfo {
  /// Creates a new row change info.
  const factory RowChangeInfo({
    /// The rows that were affected by the change.
    /// Uses renderer indices for physical positioning.
    required Set<int> affectedRendererIndices,

    /// The normal indices (user-visible line numbers) that were affected.
    /// Only includes rows with normal indices (text rows).
    required Set<int> affectedNormalIndices,

    /// The type of change that occurred.
    required RowChangeType changeType,

    /// Optional Y-coordinate range that was affected.
    double? minY,
    double? maxY,

    /// Number of lines added or removed (for content changes).
    @Default(0) int lineDelta,

    /// Whether this change affects row structure (not just content).
    @Default(false) bool structuralChange,

    /// Whether this change info was generated from a checkpoint comparison.
    @Default(false) bool isCheckpointComparison,

    /// Timestamp of the checkpoint used for comparison (if applicable).
    DateTime? checkpointTimestamp,
  }) = _RowChangeInfo;

  const RowChangeInfo._();

  /// Creates a row change info from JSON.
  factory RowChangeInfo.fromJson(Map<String, dynamic> json) =>
      _$RowChangeInfoFromJson(json);

  /// Whether any rows were affected.
  bool get hasChanges => affectedRendererIndices.isNotEmpty;

  /// Whether this affects user-visible content rows.
  bool get affectsTextRows => affectedNormalIndices.isNotEmpty;

  /// Gets the range of affected renderer indices.
  ({int min, int max})? get rendererIndexRange {
    if (affectedRendererIndices.isEmpty) return null;
    final sorted = affectedRendererIndices.toList()..sort();
    return (min: sorted.first, max: sorted.last);
  }

  /// Gets the range of affected normal indices.
  ({int min, int max})? get normalIndexRange {
    if (affectedNormalIndices.isEmpty) return null;
    final sorted = affectedNormalIndices.toList()..sort();
    return (min: sorted.first, max: sorted.last);
  }

  /// Checks if a specific row was affected.
  bool isRowAffected(NotebookRow row) {
    return affectedRendererIndices.contains(row.rendererIndex);
  }

  /// Checks if a specific normal index was affected.
  bool isNormalIndexAffected(int normalIndex) {
    return affectedNormalIndices.contains(normalIndex);
  }

  /// Merges this change info with another.
  RowChangeInfo merge(RowChangeInfo other) {
    return RowChangeInfo(
      affectedRendererIndices: {
        ...affectedRendererIndices,
        ...other.affectedRendererIndices,
      },
      affectedNormalIndices: {
        ...affectedNormalIndices,
        ...other.affectedNormalIndices,
      },
      changeType: _mergeChangeTypes(changeType, other.changeType),
      minY: minY != null && other.minY != null
          ? (minY! < other.minY! ? minY : other.minY)
          : minY ?? other.minY,
      maxY: maxY != null && other.maxY != null
          ? (maxY! > other.maxY! ? maxY : other.maxY)
          : maxY ?? other.maxY,
      lineDelta: lineDelta + other.lineDelta,
      structuralChange: structuralChange || other.structuralChange,
    );
  }

  /// Merges two change types.
  RowChangeType _mergeChangeTypes(RowChangeType a, RowChangeType b) {
    if (a == RowChangeType.mixed || b == RowChangeType.mixed) {
      return RowChangeType.mixed;
    }
    if (a != b) return RowChangeType.mixed;
    return a;
  }
}

/// The type of change that occurred to rows.
enum RowChangeType {
  /// Content was added to previously empty rows.
  contentAdded,

  /// Content was removed from rows.
  contentRemoved,

  /// Content was modified within rows.
  contentModified,

  /// Mixed changes (combination of add/remove/modify).
  mixed,

  /// Row structure changed (rows added/removed).
  structural,
}

/// Tracks changes between canvas states for a specific row.
@freezed
abstract class RowContentChange with _$RowContentChange {
  /// Creates a new row content change.
  const factory RowContentChange({
    /// The row that changed.
    required NotebookRow row,

    /// Number of sketch lines in the old state.
    required int oldLineCount,

    /// Number of sketch lines in the new state.
    required int newLineCount,

    /// Whether the content actually changed.
    required bool hasChanged,

    /// Y-coordinate bounds of old content.
    double? oldMinY,
    double? oldMaxY,

    /// Y-coordinate bounds of new content.
    double? newMinY,
    double? newMaxY,
  }) = _RowContentChange;

  const RowContentChange._();

  /// Creates a row content change from JSON.
  factory RowContentChange.fromJson(Map<String, dynamic> json) =>
      _$RowContentChangeFromJson(json);

  /// Gets the type of change for this row.
  RowChangeType get changeType {
    if (!hasChanged) return RowChangeType.contentModified;

    if (oldLineCount == 0 && newLineCount > 0) {
      return RowChangeType.contentAdded;
    } else if (oldLineCount > 0 && newLineCount == 0) {
      return RowChangeType.contentRemoved;
    } else {
      return RowChangeType.contentModified;
    }
  }

  /// The difference in line count.
  int get lineDelta => newLineCount - oldLineCount;
}
