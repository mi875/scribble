import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scribble/src/domain/model/row_index/row_index_type.dart';

part 'row_index.freezed.dart';
part 'row_index.g.dart';

/// {@template row_index}
/// Represents a type-safe row index that distinguishes between normal 
/// (user-facing) and renderer (physical) index types.
/// 
/// This class provides validation, bounds checking, and conversion utilities
/// between different row indexing systems used in the canvas.
/// {@endtemplate}
@Freezed()
abstract class RowIndex with _$RowIndex {
  /// {@macro row_index}
  const factory RowIndex({
    /// The index value.
    required int value,

    /// The type of index this represents.
    required RowIndexType type,
  }) = _RowIndex;

  const RowIndex._();

  /// Constructs a row index from a JSON object.
  factory RowIndex.fromJson(Map<String, dynamic> json) =>
      _$RowIndexFromJson(json);

  /// Creates a normal (user-facing) row index.
  /// 
  /// Normal indices are 1-based and skip image rows/free spaces.
  factory RowIndex.normal(int lineNumber) {
    if (lineNumber < 1) {
      throw ArgumentError('Normal row index must be >= 1, got $lineNumber');
    }
    return RowIndex(value: lineNumber, type: RowIndexType.normal);
  }

  /// Creates a renderer (physical) row index.
  /// 
  /// Renderer indices are 0-based and include all row types.
  factory RowIndex.renderer(int arrayIndex) {
    if (arrayIndex < 0) {
      throw ArgumentError(
          'Renderer row index must be >= 0, got $arrayIndex',);
    }
    return RowIndex(value: arrayIndex, type: RowIndexType.renderer);
  }

  /// Whether this is a normal (user-facing) index.
  bool get isNormal => type == RowIndexType.normal;

  /// Whether this is a renderer (physical) index.
  bool get isRenderer => type == RowIndexType.renderer;

  /// Validates that this index is within the specified bounds.
  /// 
  /// [maxValue] should be the maximum valid index for this type:
  /// - For normal indices: maximum line number
  /// - For renderer indices: array length - 1
  bool isValidWithinBounds(int maxValue) {
    if (maxValue < 0) return false;
    
    switch (type) {
      case RowIndexType.normal:
        return value >= 1 && value <= maxValue;
      case RowIndexType.renderer:
        return value >= 0 && value <= maxValue;
    }
  }

  /// Ensures this index is of the expected type.
  /// 
  /// Throws [StateError] if the types don't match.
  void ensureType(RowIndexType expectedType) {
    if (type != expectedType) {
      throw StateError(
        'Expected ${expectedType.name} index, got ${type.name} index',);
    }
  }

  /// Returns the zero-based value for this index.
  /// 
  /// - Normal indices: returns value - 1 (converts 1-based to 0-based)
  /// - Renderer indices: returns value unchanged (already 0-based)
  int get zeroBasedValue {
    switch (type) {
      case RowIndexType.normal:
        return value - 1;
      case RowIndexType.renderer:
        return value;
    }
  }

  /// Returns the one-based value for this index.
  /// 
  /// - Normal indices: returns value unchanged (already 1-based)
  /// - Renderer indices: returns value + 1 (converts 0-based to 1-based)
  int get oneBasedValue {
    switch (type) {
      case RowIndexType.normal:
        return value;
      case RowIndexType.renderer:
        return value + 1;
    }
  }

  @override
  String toString() {
    return 'RowIndex.${type.name}($value)';
  }
}

/// Utility functions for working with row indices.
class RowIndexUtils {
  /// Validates a collection of row indices are all of the same type.
  static void validateSameType(List<RowIndex> indices) {
    if (indices.isEmpty) return;
    
    final expectedType = indices.first.type;
    for (var i = 1; i < indices.length; i++) {
      if (indices[i].type != expectedType) {
        throw ArgumentError(
          'Mixed index types: expected all ${expectedType.name}, '
          'but found ${indices[i].type.name} at position $i',);
      }
    }
  }

  /// Checks if all indices in the collection are within bounds.
  static bool areAllValidWithinBounds(List<RowIndex> indices, int maxValue) {
    return indices.every((index) => index.isValidWithinBounds(maxValue));
  }

  /// Filters indices to only include those within bounds.
  static List<RowIndex> filterValidIndices(
      List<RowIndex> indices, int maxValue,) {
    return indices.where((index) => index.isValidWithinBounds(maxValue))
        .toList();
  }
}
