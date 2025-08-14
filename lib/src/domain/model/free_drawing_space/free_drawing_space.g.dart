// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_drawing_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FreeDrawingSpaceImpl _$$FreeDrawingSpaceImplFromJson(
        Map<String, dynamic> json) =>
    _$FreeDrawingSpaceImpl(
      startY: (json['startY'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$FreeDrawingSpaceImplToJson(
        _$FreeDrawingSpaceImpl instance) =>
    <String, dynamic>{
      'startY': instance.startY,
      'height': instance.height,
      'id': instance.id,
    };
