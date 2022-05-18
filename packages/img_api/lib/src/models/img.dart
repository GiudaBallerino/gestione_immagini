import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:img_api/img_api.dart';

part 'img.g.dart';

/// {@template img}
/// A single img item.
///
/// Contains a [path].
///
/// [Img]s are immutable and can be copied using [copyWith], in addition to
/// {@endtemplate}
@immutable
@JsonSerializable()
class Img extends Equatable {
  /// {@macro img}
  Img({
    required this.path,
  });

  /// The unique identifier of the img.
  ///
  /// Cannot be empty.
  final String path;

  /// Returns a copy of this img with the given values updated.
  ///
  /// {@macro todo}
  Img copyWith({
    String? path,
  }) {
    return Img(
      path: path ?? this.path,
    );
  }

  /// Deserializes the given [JsonMap] into a [Img].
  static Img fromJson(JsonMap json) => _$ImgFromJson(json);

  /// Converts this [Todo] into a [JsonMap].
  JsonMap toJson() => _$TodoToJson(this);

  @override
  List<Object> get props => [path];
}