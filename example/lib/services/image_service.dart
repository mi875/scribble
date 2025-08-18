import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

/// Service for handling image operations in the line-by-line demo.
class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static final Map<String, ui.Image> _imageCache = {};

  /// Picks an image from the device gallery.
  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return await pickedFile.readAsBytes();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Picks an image from the device camera.
  static Future<Uint8List?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return await pickedFile.readAsBytes();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  /// Decodes image bytes to a ui.Image object.
  static Future<ui.Image?> decodeImageFromBytes(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      throw Exception('Failed to decode image: $e');
    }
  }

  /// Gets or loads a ui.Image from cache using the image ID.
  static Future<ui.Image?> getCachedImage(String imageId, Uint8List bytes) async {
    if (_imageCache.containsKey(imageId)) {
      return _imageCache[imageId];
    }

    final image = await decodeImageFromBytes(bytes);
    if (image != null) {
      _imageCache[imageId] = image;
    }
    return image;
  }

  /// Removes an image from cache.
  static void removeFromCache(String imageId) {
    final image = _imageCache.remove(imageId);
    image?.dispose();
  }

  /// Clears the entire image cache.
  static void clearCache() {
    for (final image in _imageCache.values) {
      image.dispose();
    }
    _imageCache.clear();
  }

  /// Resizes image bytes to fit within the specified dimensions while maintaining aspect ratio.
  static Future<Uint8List?> resizeImage(
    Uint8List bytes, {
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) return null;

      img.Image resizedImage;
      
      if (maxWidth != null && maxHeight != null) {
        // Resize to fit within both constraints
        final double aspectRatio = originalImage.width / originalImage.height;
        final double targetAspectRatio = maxWidth / maxHeight;
        
        if (aspectRatio > targetAspectRatio) {
          // Image is wider, constrain by width
          resizedImage = img.copyResize(originalImage, width: maxWidth);
        } else {
          // Image is taller, constrain by height
          resizedImage = img.copyResize(originalImage, height: maxHeight);
        }
      } else if (maxWidth != null) {
        resizedImage = img.copyResize(originalImage, width: maxWidth);
      } else if (maxHeight != null) {
        resizedImage = img.copyResize(originalImage, height: maxHeight);
      } else {
        return bytes; // No resize needed
      }

      return Uint8List.fromList(img.encodePng(resizedImage));
    } catch (e) {
      throw Exception('Failed to resize image: $e');
    }
  }

  /// Validates if the provided bytes represent a valid image.
  static bool isValidImage(Uint8List bytes) {
    try {
      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }

  /// Gets image dimensions without fully decoding the image.
  static Future<Size?> getImageDimensions(Uint8List bytes) async {
    try {
      final image = img.decodeImage(bytes);
      if (image != null) {
        return Size(image.width.toDouble(), image.height.toDouble());
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Represents image dimensions.
class Size {
  final double width;
  final double height;

  const Size(this.width, this.height);

  double get aspectRatio => width / height;

  @override
  String toString() => 'Size(${width.toInt()}x${height.toInt()})';
}