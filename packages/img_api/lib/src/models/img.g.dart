// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'img.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Img _$ImgFromJson(Map<String, dynamic> json) => Img(
  path: json['path'] as String,
  selections:  json['selections'] as List<model.Selection>,
);

Map<String, dynamic> _$ImgToJson(Img instance) => <String, dynamic>{
  'path': instance.path,
  'selections':instance.selections,
};