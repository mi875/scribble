// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RowChangeInfo _$RowChangeInfoFromJson(Map<String, dynamic> json) =>
    _RowChangeInfo(
      affectedRendererIndices:
          (json['affectedRendererIndices'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toSet(),
      affectedNormalIndices: (json['affectedNormalIndices'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toSet(),
      changeType: $enumDecode(_$RowChangeTypeEnumMap, json['changeType']),
      minY: (json['minY'] as num?)?.toDouble(),
      maxY: (json['maxY'] as num?)?.toDouble(),
      lineDelta: (json['lineDelta'] as num?)?.toInt() ?? 0,
      structuralChange: json['structuralChange'] as bool? ?? false,
      isCheckpointComparison: json['isCheckpointComparison'] as bool? ?? false,
      checkpointTimestamp: json['checkpointTimestamp'] == null
          ? null
          : DateTime.parse(json['checkpointTimestamp'] as String),
    );

Map<String, dynamic> _$RowChangeInfoToJson(_RowChangeInfo instance) =>
    <String, dynamic>{
      'affectedRendererIndices': instance.affectedRendererIndices.toList(),
      'affectedNormalIndices': instance.affectedNormalIndices.toList(),
      'changeType': _$RowChangeTypeEnumMap[instance.changeType]!,
      'minY': instance.minY,
      'maxY': instance.maxY,
      'lineDelta': instance.lineDelta,
      'structuralChange': instance.structuralChange,
      'isCheckpointComparison': instance.isCheckpointComparison,
      'checkpointTimestamp': instance.checkpointTimestamp?.toIso8601String(),
    };

const _$RowChangeTypeEnumMap = {
  RowChangeType.contentAdded: 'contentAdded',
  RowChangeType.contentRemoved: 'contentRemoved',
  RowChangeType.contentModified: 'contentModified',
  RowChangeType.mixed: 'mixed',
  RowChangeType.structural: 'structural',
};

_RowContentChange _$RowContentChangeFromJson(Map<String, dynamic> json) =>
    _RowContentChange(
      row: NotebookRow.fromJson(json['row'] as Map<String, dynamic>),
      oldLineCount: (json['oldLineCount'] as num).toInt(),
      newLineCount: (json['newLineCount'] as num).toInt(),
      hasChanged: json['hasChanged'] as bool,
      oldMinY: (json['oldMinY'] as num?)?.toDouble(),
      oldMaxY: (json['oldMaxY'] as num?)?.toDouble(),
      newMinY: (json['newMinY'] as num?)?.toDouble(),
      newMaxY: (json['newMaxY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RowContentChangeToJson(_RowContentChange instance) =>
    <String, dynamic>{
      'row': instance.row.toJson(),
      'oldLineCount': instance.oldLineCount,
      'newLineCount': instance.newLineCount,
      'hasChanged': instance.hasChanged,
      'oldMinY': instance.oldMinY,
      'oldMaxY': instance.oldMaxY,
      'newMinY': instance.newMinY,
      'newMaxY': instance.newMaxY,
    };
