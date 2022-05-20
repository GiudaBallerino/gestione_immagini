import 'package:tag_api/tag_api.dart';

/// {@template tags_repository}
/// A repository that handles tag related requests.
/// {@endtemplate}
class TagsRepository {
  /// {@macro tags_repository}
  const TagsRepository({
    required TagApi tagApi,
  }) : _tagApi = tagApi;

  final TagApi _tagApi;

  /// Provides a [Stream] of all tags.
  Stream<List<Tag>> getTags() => _tagApi.getTags();

  /// Saves a [img].
  ///
  /// If a [img] with the same id already exists, it will be replaced.
  Future<void> saveTag(Tag tag) => _tagApi.saveTag(tag);

  /// Deletes the tag with the given id.
  ///
  /// If no tag with the given id exists, a [TagNotFoundException] error is
  /// thrown.
  Future<void> deleteTag(String id) => _tagApi.deleteTag(id);
}