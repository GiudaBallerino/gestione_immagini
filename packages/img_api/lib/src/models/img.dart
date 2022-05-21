import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:img_api/img_api.dart';
import 'package:selection_api/selection_api.dart' as model;

part 'img.g.dart';

/// {@template img}
/// A single img item.
///
/// Contains a [path] and [selections].
///
/// [Img]s are immutable and can be copied using [copyWith], in addition to
/// {@endtemplate}
@immutable
@JsonSerializable()
class Img extends Equatable {
  /// {@macro img}
  Img({
    required this.path,
    required this.selections,
  });

  /// The unique identifier of the img.
  ///
  /// Cannot be empty.
  final String path;

  /// A list of unique selection.
  ///
  /// Cannot be empty.
  final List<model.Selection> selections;

  /// Returns a copy of this img with the given values updated.
  ///
  /// {@macro todo}
  Img copyWith({
    String? path,
    List<model.Selection>? selections,
  }) {
    return Img(
      path: path ?? this.path,
      selections: selections ?? this.selections
    );
  }

  /// Deserializes the given [JsonMap] into a [Img].
  static Img fromJson(JsonMap json) => _$ImgFromJson(json);

  /// Converts this [Img] into a [JsonMap].
  JsonMap toJson() => _$ImgToJson(this);

  @override
  List<Object> get props => [path,selections];
}