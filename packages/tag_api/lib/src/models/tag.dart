import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../tag_api.dart';

part 'tag.g.dart';

/// {@template tag}
/// A single img item.
///
/// Contains a [path].
///
/// [Img]s are immutable and can be copied using [copyWith], in addition to
/// {@endtemplate}
@immutable
@JsonSerializable()
class Tag extends Equatable {
  /// {@macro tag}
  Tag({
    String? id,
    required this.name,
  })  : assert(
  id == null || id.isNotEmpty,
  'id can not be null and should be empty',
  ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the tag.
  ///
  /// Cannot be empty.
  final String id;

  /// The name of the tag.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this img with the given values updated.
  ///
  /// {@macro todo}
  Tag copyWith({
    String? id,
    String? name,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name
    );
  }

  /// Deserializes the given [JsonMap] into a [Tag].
  static Tag fromJson(JsonMap json) => _$TagFromJson(json);

  /// Converts this [Tag] into a [JsonMap].
  JsonMap toJson() => _$TagToJson(this);

  @override
  List<Object> get props => [id,name];
}