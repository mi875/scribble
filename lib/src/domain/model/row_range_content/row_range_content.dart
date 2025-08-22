import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scribble/src/domain/model/sketch_line/sketch_line.dart';
import 'package:scribble/src/domain/model/free_drawing_space/free_drawing_space.dart';
import 'package:scribble/src/domain/model/image_row/image_row.dart';

part 'row_range_content.freezed.dart';
part 'row_range_content.g.dart';

/// Represents content within a specific row range for export purposes.
/// Contains all sketch lines, free drawing spaces, and image rows within the range.
@freezed
abstract class RowRangeContent with _$RowRangeContent {
  const factory RowRangeContent({
    /// The starting Y coordinate of the row range.
    required double startY,

    /// The ending Y coordinate of the row range.
    required double endY,

    /// Sketch lines within the row range.
    required List<SketchLine> sketchLines,

    /// Free drawing spaces within the row range.
    required List<FreeDrawingSpace> freeDrawingSpaces,

    /// Image rows within the row range.
    required List<ImageRow> imageRows,
  }) = _RowRangeContent;

  /// Constructs a RowRangeContent from a JSON object.
  factory RowRangeContent.fromJson(Map<String, dynamic> json) =>
      _$RowRangeContentFromJson(json);
}
