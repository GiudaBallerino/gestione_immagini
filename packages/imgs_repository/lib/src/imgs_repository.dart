import 'package:img_api/img_api.dart';
import 'package:selection_api/selection_api.dart';

/// {@template imgs_repository}
/// A repository that handles img related requests.
/// {@endtemplate}
class ImgsRepository {
  /// {@macro imgs_repository}
  const ImgsRepository({
    required ImgApi imgApi,
  }) : _imgApi = imgApi;

  final ImgApi _imgApi;

  /// Provides a [Stream] of all imgs.
  Stream<List<Img>> getImgs() => _imgApi.getImgs();

  /// Provides a [Stream] of all selections.
  Stream<List<Selection>> getSelections(String path) => _imgApi.getSelections(path);

  /// Saves a [img].
  ///
  /// If a [img] with the same path already exists, it will be replaced.
  Future<void> saveImg(Img img) => _imgApi.saveImg(img);

  /// Saves a [selection].
  ///
  /// If a [selection] with the same id already exists, it will be replaced.
  Future<void> saveSelection(String path, Selection selection) => _imgApi.saveSelection(path, selection);

  /// Deletes the img with the given path.
  ///
  /// If no img with the given path exists, a [ImgNotFoundException] error is
  /// thrown.
  Future<void> deleteImg(String path) => _imgApi.deleteImg(path);

  /// Deletes the selection with the given id.
  ///
  /// If no selection with the given id exists, a [SelectionNotFoundException] error is
  /// thrown.
  Future<void> deleteSelection(String path, String id) => _imgApi.deleteSelection(path,id);
}