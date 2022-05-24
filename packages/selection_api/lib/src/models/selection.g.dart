// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Selection _$SelectionFromJson(Map<String, dynamic> json) => Selection(
    id: json['id'] as String,
    tag: model.Tag.fromJson(json['tag']),
    points: List.from(json['points']).map((item)=>Offset(item['dx'] as double ,item["dy"] as double)).toList(),
);

Map<String, dynamic> _$SelectionToJson(Selection instance) => <String, dynamic>{
  'id': instance.id,
  'tag': instance.tag,
  'points': instance.points,
};