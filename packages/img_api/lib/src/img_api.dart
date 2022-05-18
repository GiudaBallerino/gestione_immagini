import 'package:img_api/img_api.dart';

/// {@template todos_api}
/// The interface for an API that provides access to a list of todos.
/// {@endtemplate}
abstract class ImgApi {
  /// {@macro todos_api}
  ImgApi();

  /// Provides a [Stream] of all imgs.
  Stream<List<Img>> getImgs();

  /// Saves a [img].
  ///
  /// If a [img] with the same name already exists, it will be replaced.
  Future<void> saveImg(Img image);

  /// Deletes the img with the given path.
  ///
  /// If no img with the given path exists, a [ImgNotFoundException] error is
  /// thrown.
  Future<void> deleteImg(String path);

}

/// Error thrown when a [Img] with a given path is not found.
class ImgNotFoundException implements Exception {}