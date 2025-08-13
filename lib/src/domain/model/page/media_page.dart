import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

enum MediaType {
  image,
  pdf,
  sketch,
}

class MediaPage {
  const MediaPage({
    required this.sketch,
    required this.size,
    this.mediaType = MediaType.sketch,
    this.imageData,
    this.pdfPath,
  });

  final Sketch sketch;
  final Size size;
  final MediaType mediaType;
  final Uint8List? imageData;
  final String? pdfPath;
}
