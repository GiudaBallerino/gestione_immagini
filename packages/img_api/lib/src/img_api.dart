import 'package:img_api/img_api.dart';
import 'package:selection_api/selection_api.dart';

/// {@template todos_api}
/// The interface for an API that provides access to a list of todos.
/// {@endtemplate}
abstract class ImgApi {
  /// {@macro todos_api}
  ImgApi();

  /// Provides a [Stream] of all imgs.
  Stream<List<Img>> getImgs();

  /// Provides a [List] of all selections.
  Stream<List<Selection>> getSelections(String path);

  /// Saves a [img].
  ///
  /// If a [img] with the same name already exists, it will be replaced.
  Future<void> saveImg(Img image);

  /// Saves a [selection].
  ///
  /// If a [selection] with the same id already exists, it will be replaced.
  Future<void> saveSelection(String path, Selection selection);

  /// Deletes the img with the given path.
  ///
  /// If no img with the given path exists, a [ImgNotFoundException] error is
  /// thrown.
  Future<void> deleteImg(String path);

  /// Deletes the selection with the given id.
  ///
  /// If no selection with the given id exists, a [SelectionNotFoundException] error is
  /// thrown.
  Future<void> deleteSelection(String path, String id);

}

/// Error thrown when a [Img] with a given path is not found.
class ImgNotFoundException implements Exception {}

/// Error thrown when a [Selection] with a given id is not found.
class SelectionNotFoundException implements Exception {}