// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row_range_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RowRangeContent _$RowRangeContentFromJson(Map<String, dynamic> json) =>
    _RowRangeContent(
      startY: (json['startY'] as num).toDouble(),
      endY: (json['endY'] as num).toDouble(),
      sketchLines: (json['sketchLines'] as List<dynamic>)
          .map((e) => SketchLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      freeDrawingSpaces: (json['freeDrawingSpaces'] as List<dynamic>)
          .map((e) => FreeDrawingSpace.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageRows: (json['imageRows'] as List<dynamic>)
          .map((e) => ImageRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RowRangeContentToJson(_RowRangeContent instance) =>
    <String, dynamic>{
      'startY': instance.startY,
      'endY': instance.endY,
      'sketchLines': instance.sketchLines.map((e) => e.toJson()).toList(),
      'freeDrawingSpaces':
          instance.freeDrawingSpaces.map((e) => e.toJson()).toList(),
      'imageRows': instance.imageRows.map((e) => e.toJson()).toList(),
    };
