import 'package:tag_api/tag_api.dart';

/// {@template tag_api}
/// The interface for an API that provides access to a list of tags.
/// {@endtemplate}
abstract class TagApi {
  /// {@macro tag_api}
  TagApi();

  /// Provides a [Stream] of all tags.
  Stream<List<Tag>> getTags();

  /// Saves a [tag].
  ///
  /// If a [tag] with the same name already exists, it will be replaced.
  Future<void> saveTag(Tag tag);

  /// Deletes the tag with the given id.
  ///
  /// If no tag with the given id exists, a [TagNotFoundException] error is
  /// thrown.
  Future<void> deleteTag(String id);

}

/// Error thrown when a [Tag] with a given id is not found.
class TagNotFoundException implements Exception {}