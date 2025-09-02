/// {@template row_index_type}
/// Defines the type of row index being used in the canvas system.
/// 
/// This enum helps distinguish between different indexing systems:
/// - Normal: User-visible sequential line numbers (1, 2, 3...) that skip 
///   image rows/free spaces
/// - Renderer: Physical array indices (0, 1, 2...) that include all rows 
///   for canvas operations
/// {@endtemplate}
enum RowIndexType {
  /// Normal row index - user-facing sequential line numbers.
  /// 
  /// Used for:
  /// - Line number display to users
  /// - User-initiated operations (highlighting, selection)
  /// - Export operations that need to reference user-visible content
  /// 
  /// Characteristics:
  /// - 1-based indexing (first visible line is 1)
  /// - Skips image rows and free drawing spaces
  /// - Sequential numbering of only text content rows
  normal,

  /// Renderer row index - physical array positions.
  /// 
  /// Used for:
  /// - Internal canvas rendering operations
  /// - Physical positioning calculations
  /// - Image row placement and rendering
  /// - Direct array access to _rows list
  /// 
  /// Characteristics:
  /// - 0-based indexing (matches array indices)
  /// - Includes all row types (text, image, free spaces)
  /// - Direct mapping to internal data structures
  renderer,
}

/// Extension methods for [RowIndexType] to provide additional functionality.
extension RowIndexTypeExtension on RowIndexType {
  /// Whether this index type is user-facing.
  bool get isUserFacing => this == RowIndexType.normal;

  /// Whether this index type is for internal operations.
  bool get isInternal => this == RowIndexType.renderer;

  /// Human-readable description of the index type.
  String get description {
    switch (this) {
      case RowIndexType.normal:
        return 'User-visible sequential line numbers';
      case RowIndexType.renderer:
        return 'Physical array positions for rendering';
    }
  }
}
