import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:scribble/src/view/painting/background_image_painter.dart';

/// A widget that renders a background image with proper image loading and management.
class BackgroundImageWidget extends StatefulWidget {
  /// Creates a [BackgroundImageWidget].
  const BackgroundImageWidget({
    required this.imageProvider,
    required this.scaleFactor,
    required this.panOffset,
    required this.child,
    this.canvasSize,
    this.backgroundImageSize,
    this.fit = BoxFit.contain,
    super.key,
  });

  /// The image provider for the background image.
  final ImageProvider imageProvider;

  /// The current scale factor for zoom.
  final double scaleFactor;

  /// The current pan offset.
  final Offset panOffset;

  /// The canvas size constraint, if any.
  final Size? canvasSize;

  /// The size of the background image, if specified.
  final Size? backgroundImageSize;

  /// How the image should be fit within the canvas.
  final BoxFit fit;

  /// The child widget to render on top of the background.
  final Widget child;

  @override
  State<BackgroundImageWidget> createState() => _BackgroundImageWidgetState();
}

class _BackgroundImageWidgetState extends State<BackgroundImageWidget> {
  ui.Image? _image;
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(BackgroundImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    _imageStreamListener?.let((listener) {
      _imageStream?.removeListener(listener);
    });
    super.dispose();
  }

  void _loadImage() {
    _imageStreamListener?.let((listener) {
      _imageStream?.removeListener(listener);
    });

    _imageStream = widget.imageProvider.resolve(ImageConfiguration.empty);
    _imageStreamListener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (mounted) {
          setState(() {
            _image = info.image;
          });
        }
      },
      onError: (exception, stackTrace) {
        if (mounted) {
          setState(() {
            _image = null;
          });
        }
      },
    );

    _imageStream?.addListener(_imageStreamListener!);
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      // Return child without background while image is loading
      return widget.child;
    }

    return CustomPaint(
      painter: BackgroundImagePainter(
        image: _image!,
        scaleFactor: widget.scaleFactor,
        panOffset: widget.panOffset,
        canvasSize: widget.canvasSize,
        backgroundImageSize: widget.backgroundImageSize,
        fit: widget.fit,
      ),
      child: widget.child,
    );
  }
}

extension _NullableExtension<T> on T? {
  R? let<R>(R Function(T) fn) {
    final self = this;
    return self != null ? fn(self) : null;
  }
}
