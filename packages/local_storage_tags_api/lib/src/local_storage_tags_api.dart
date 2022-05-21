import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_api/tag_api.dart';

/// {@template local_storage_tags_api}
/// A Flutter implementation of the [ImgApi] that uses local storage.
/// {@endtemplate}
class LocalStorageTagsApi extends TagApi {
  /// {@macro local_storage_tags_api}
  LocalStorageTagsApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _tagStreamController = BehaviorSubject<List<Tag>>.seeded(const []);

  /// The key used for storing the img locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kTagsCollectionKey = '__tags_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final tagsJson = _getValue(kTagsCollectionKey);
    if (tagsJson != null) {
      final tags = List<Map>.from(json.decode(tagsJson) as List)
          .map((jsonMap) => Tag.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _tagStreamController.add(tags);
    } else {
      _tagStreamController.add(const []);
    }
  }

  @override
  Stream<List<Tag>> getTags() => _tagStreamController.asBroadcastStream();

  @override
  Future<void> saveTag(Tag tag) {
    final tags = [..._tagStreamController.value];
    final tagIndex = tags.indexWhere((t) => t.id == tag.id);
    if (tagIndex >= 0) {
      tags[tagIndex] = tag;
    } else {
      tags.add(tag);
    }

    _tagStreamController.add(tags);
    return _setValue(kTagsCollectionKey, json.encode(tags));
  }

  @override
  Future<void> deleteTag(String id) async {
    final tags = [..._tagStreamController.value];
    final tagIndex = tags.indexWhere((t) => t.id == id);
    if (tagIndex == -1) {
      throw TagNotFoundException();
    } else {
      tags.removeAt(tagIndex);
      _tagStreamController.add(tags);
      return _setValue(kTagsCollectionKey, json.encode(tags));
    }
  }
}