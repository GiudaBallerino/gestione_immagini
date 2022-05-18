import 'package:img_api/img_api.dart';

/// {@template todos_repository}
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

  /// Saves a [img].
  ///
  /// If a [img] with the same path already exists, it will be replaced.
  Future<void> saveImg(Img img) => _imgApi.saveImg(img);

  /// Deletes the img with the given path.
  ///
  /// If no img with the given path exists, a [ImgNotFoundException] error is
  /// thrown.
  Future<void> deleteImg(String path) => _imgApi.deleteImg(path);
}