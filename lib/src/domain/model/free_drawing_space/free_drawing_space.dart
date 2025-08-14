import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_drawing_space.freezed.dart';
part 'free_drawing_space.g.dart';

/// {@template free_drawing_space}
/// Represents a line-free drawing space region in the canvas.
/// This is a blank area without row lines where users can draw freely.
/// {@endtemplate}
@Freezed()
abstract class FreeDrawingSpace with _$FreeDrawingSpace {
  /// {@macro free_drawing_space}
  const factory FreeDrawingSpace({
    /// The Y coordinate where the free drawing space starts.
    required double startY,

    /// The height of the free drawing space region.
    required double height,

    /// Optional identifier for the free drawing space.
    String? id,
  }) = _FreeDrawingSpace;

  const FreeDrawingSpace._();

  /// Constructs a free drawing space from a JSON object.
  factory FreeDrawingSpace.fromJson(Map<String, dynamic> json) =>
      _$FreeDrawingSpaceFromJson(json);

  /// The Y coordinate where the free drawing space ends.
  double get endY => startY + height;

  /// Checks if a given Y coordinate is within this free drawing space.
  bool containsY(double y) => y >= startY && y <= endY;

  /// Checks if this free drawing space overlaps with another region.
  bool overlaps(double otherStartY, double otherEndY) {
    return !(endY <= otherStartY || startY >= otherEndY);
  }

  /// Creates a new free drawing space with the specified height adjustment.
  FreeDrawingSpace expandBy(double additionalHeight) {
    return copyWith(height: height + additionalHeight);
  }

  /// Creates a new free drawing space moved by the specified Y offset.
  FreeDrawingSpace moveBy(double yOffset) {
    return copyWith(startY: startY + yOffset);
  }
}
