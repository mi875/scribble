// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageRow _$ImageRowFromJson(Map<String, dynamic> json) => _ImageRow(
      startY: (json['startY'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$ImageRowToJson(_ImageRow instance) => <String, dynamic>{
      'startY': instance.startY,
      'height': instance.height,
      'id': instance.id,
    };
