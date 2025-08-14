// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotebookRow _$NotebookRowFromJson(Map<String, dynamic> json) => _NotebookRow(
      startY: (json['startY'] as num).toDouble(),
      index: (json['index'] as num).toInt(),
      height: (json['height'] as num?)?.toDouble() ?? 24.0,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$NotebookRowToJson(_NotebookRow instance) =>
    <String, dynamic>{
      'startY': instance.startY,
      'index': instance.index,
      'height': instance.height,
      'id': instance.id,
    };
