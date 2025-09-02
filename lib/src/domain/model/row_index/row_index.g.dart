// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RowIndex _$RowIndexFromJson(Map<String, dynamic> json) => _RowIndex(
      value: (json['value'] as num).toInt(),
      type: $enumDecode(_$RowIndexTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$RowIndexToJson(_RowIndex instance) => <String, dynamic>{
      'value': instance.value,
      'type': _$RowIndexTypeEnumMap[instance.type]!,
    };

const _$RowIndexTypeEnumMap = {
  RowIndexType.normal: 'normal',
  RowIndexType.renderer: 'renderer',
};
