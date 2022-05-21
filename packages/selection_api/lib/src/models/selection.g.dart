// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Selection _$SelectionFromJson(Map<String, dynamic> json) => Selection(
    id: json['id'] as String,
    tag: json['tag'] as model.Tag,
    left: json['left'] as double,
    top: json['top'] as double,
    right: json['right'] as double,
    bottom: json['bottom'] as double,
);

Map<String, dynamic> _$SelectionToJson(Selection instance) => <String, dynamic>{
  'id': instance.id,
  'tag': instance.tag,
  'left': instance.left,
  'top': instance.top,
  'right': instance.right,
  'bottom': instance.bottom,
};