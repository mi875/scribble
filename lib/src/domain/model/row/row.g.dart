// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotebookRow _$NotebookRowFromJson(Map<String, dynamic> json) => _NotebookRow(
      startY: (json['startY'] as num).toDouble(),
      rendererIndex: (json['rendererIndex'] as num).toInt(),
      normalIndex: (json['normalIndex'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toDouble() ?? 24.0,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$NotebookRowToJson(_NotebookRow instance) =>
    <String, dynamic>{
      'startY': instance.startY,
      'rendererIndex': instance.rendererIndex,
      'normalIndex': instance.normalIndex,
      'height': instance.height,
      'id': instance.id,
    };
