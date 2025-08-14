// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_drawing_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FreeDrawingSpace _$FreeDrawingSpaceFromJson(Map<String, dynamic> json) =>
    _FreeDrawingSpace(
      startY: (json['startY'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$FreeDrawingSpaceToJson(_FreeDrawingSpace instance) =>
    <String, dynamic>{
      'startY': instance.startY,
      'height': instance.height,
      'id': instance.id,
    };
