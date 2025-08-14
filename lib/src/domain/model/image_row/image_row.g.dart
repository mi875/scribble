// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageRowImpl _$$ImageRowImplFromJson(Map<String, dynamic> json) =>
    _$ImageRowImpl(
      startY: (json['startY'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      imageBytes:
          const Uint8ListConverter().fromJson(json['imageBytes'] as List<int>?),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$ImageRowImplToJson(_$ImageRowImpl instance) =>
    <String, dynamic>{
      'startY': instance.startY,
      'height': instance.height,
      'imageBytes': const Uint8ListConverter().toJson(instance.imageBytes),
      'id': instance.id,
    };
