import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tag_api/tag_api.dart' as model;
import 'package:uuid/uuid.dart';

import '../../selection_api.dart';

part 'selection.g.dart';

/// {@template selection}
/// A single selection item.
///
/// Contains a [id], [tag], [left], [top], [right], [bottom].
///
/// [Selection]s are immutable and can be copied using [copyWith], in addition to
/// {@endtemplate}
@immutable
@JsonSerializable()
class Selection extends Equatable {
  /// {@macro selection}
  Selection({
    String? id,
    required this.tag,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  })  : assert(
  id == null || id.isNotEmpty,
  'id can not be null and should be empty',
  ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the selection.
  ///
  /// Cannot be empty.
  final String id;

  /// The name of the tag.
  ///
  /// Cannot be empty.
  final model.Tag tag;

  /// The top offset of the selection.
  ///
  /// Cannot be empty.
  final double top;

  /// The left offset of the selection.
  ///
  /// Cannot be empty.
  final double left;

  /// The right offset of the selection..
  ///
  /// Cannot be empty.
  final double right;

  /// The bottom offset of the selection.
  ///
  /// Cannot be empty.
  final double bottom;

  /// Returns a copy of this selection with the given values updated.
  ///
  /// {@macro selection}
  Selection copyWith({
    String? id,
    model.Tag? tag,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Selection(
        id: id ?? this.id,
        tag: tag ?? this.tag,
        left: left ?? this.left,
        top: top ?? this.top,
        right: right ?? this.right,
        bottom: bottom ?? this.bottom,
    );
  }

  /// Deserializes the given [JsonMap] into a [Selection].
  static Selection fromJson(JsonMap json) => _$SelectionFromJson(json);

  /// Converts this [Selection] into a [JsonMap].
  JsonMap toJson() => _$SelectionToJson(this);

  @override
  List<Object> get props => [id,tag, left, top, right, bottom];
}