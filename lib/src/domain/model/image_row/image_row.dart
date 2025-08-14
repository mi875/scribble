import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_row.freezed.dart';
part 'image_row.g.dart';

/// {@template image_row}
/// Represents an image row region in the canvas.
/// This is an area that contains an image instead of drawing lines.
/// {@endtemplate}
@Freezed()
class ImageRow with _$ImageRow {
  /// {@macro image_row}
  const factory ImageRow({
    /// The Y coordinate where the image row starts.
    required double startY,
    
    /// The height of the image row region.
    required double height,
    
    /// The image data as bytes (for JSON serialization).
    @Uint8ListConverter() Uint8List? imageBytes,
    
    /// Optional identifier for the image row.
    String? id,
  }) = _ImageRow;
  
  const ImageRow._();

  /// Constructs an image row from a JSON object.
  factory ImageRow.fromJson(Map<String, dynamic> json) => 
      _$ImageRowFromJson(json);
  
  /// The Y coordinate where the image row ends.
  double get endY => startY + height;
  
  /// Checks if a given Y coordinate is within this image row.
  bool containsY(double y) => y >= startY && y <= endY;
  
  /// Checks if this image row overlaps with another region.
  bool overlaps(double otherStartY, double otherEndY) {
    return !(endY <= otherStartY || startY >= otherEndY);
  }
  
  /// Creates a new image row with the specified height adjustment.
  ImageRow expandBy(double additionalHeight) {
    return copyWith(height: height + additionalHeight);
  }
  
  /// Creates a new image row moved by the specified Y offset.
  ImageRow moveBy(double yOffset) {
    return copyWith(startY: startY + yOffset);
  }
  
  /// Creates an ImageProvider from the stored image bytes.
  ImageProvider? get imageProvider {
    if (imageBytes == null) return null;
    return MemoryImage(imageBytes!);
  }
  
  /// Creates a new ImageRow with updated image data.
  ImageRow withImageBytes(Uint8List bytes) {
    return copyWith(imageBytes: bytes);
  }
}

/// Custom converter for Uint8List to handle JSON serialization.
class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    if (json == null) return null;
    return Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    return object?.toList();
  }
}