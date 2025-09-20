// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageRow _$ImageRowFromJson(Map<String, dynamic> json) => _ImageRow(
      startY: (json['startY'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rendererIndex: (json['rendererIndex'] as num?)?.toInt() ?? 0,
      visualIndex: (json['visualIndex'] as num?)?.toInt() ?? 1,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$ImageRowToJson(_ImageRow instance) => <String, dynamic>{
      'startY': instance.startY,
      'height': instance.height,
      'rendererIndex': instance.rendererIndex,
      'visualIndex': instance.visualIndex,
      'id': instance.id,
    };
