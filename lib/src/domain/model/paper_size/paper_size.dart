import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Enum representing different standard paper size types.
enum PaperSizeType {
  /// A4 paper size (210 × 297 mm).
  a4,

  /// US Letter paper size (8.5 × 11 inches).
  letter,

  /// US Legal paper size (8.5 × 14 inches).
  legal,

  /// A3 paper size (297 × 420 mm).
  a3,

  /// A5 paper size (148 × 210 mm).
  a5,

  /// Custom paper size with user-defined dimensions.
  custom,
}

/// Represents a paper size with dimensions and metadata.
@immutable
class PaperSize {
  const PaperSize({
    required this.type,
    required this.width,
    required this.height,
    required this.name,
  });

  /// The type of paper size.
  final PaperSizeType type;

  /// The width of the paper in points.
  final double width;

  /// The height of the paper in points.
  final double height;

  /// The display name of the paper size.
  final String name;

  /// Standard A4 paper size (210 × 297 mm).
  static const PaperSize a4 = PaperSize(
    type: PaperSizeType.a4,
    width: 595, // A4 width in points (8.27 inches)
    height: 842, // A4 height in points (11.69 inches)
    name: 'A4',
  );

  /// Standard US Letter paper size (8.5 × 11 inches).
  static const PaperSize letter = PaperSize(
    type: PaperSizeType.letter,
    width: 612, // Letter width in points (8.5 inches)
    height: 792, // Letter height in points (11 inches)
    name: 'Letter',
  );

  /// Standard US Legal paper size (8.5 × 14 inches).
  static const PaperSize legal = PaperSize(
    type: PaperSizeType.legal,
    width: 612, // Legal width in points (8.5 inches)
    height: 1008, // Legal height in points (14 inches)
    name: 'Legal',
  );

  /// Standard A3 paper size (297 × 420 mm).
  static const PaperSize a3 = PaperSize(
    type: PaperSizeType.a3,
    width: 842, // A3 width in points (11.69 inches)
    height: 1191, // A3 height in points (16.54 inches)
    name: 'A3',
  );

  /// Standard A5 paper size (148 × 210 mm).
  static const PaperSize a5 = PaperSize(
    type: PaperSizeType.a5,
    width: 420, // A5 width in points (5.83 inches)
    height: 595, // A5 height in points (8.27 inches)
    name: 'A5',
  );

  /// List of all predefined paper sizes.
  static const List<PaperSize> predefinedSizes = [
    a4,
    letter,
    legal,
    a3,
    a5,
  ];

  /// Returns the paper size as a Flutter [Size] object.
  Size get size => Size(width, height);

  /// Creates a copy of this paper size with optional overrides.
  PaperSize copyWith({
    PaperSizeType? type,
    double? width,
    double? height,
    String? name,
  }) {
    return PaperSize(
      type: type ?? this.type,
      width: width ?? this.width,
      height: height ?? this.height,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaperSize &&
        other.type == type &&
        other.width == width &&
        other.height == height &&
        other.name == name;
  }

  @override
  int get hashCode {
    return type.hashCode ^ width.hashCode ^ height.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'PaperSize(type: $type, width: $width, height: $height, '
        'name: $name)';
  }
}
