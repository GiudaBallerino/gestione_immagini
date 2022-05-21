import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:selection_api/selection_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:img_api/img_api.dart';

/// {@template local_storage_imgs_api}
/// A Flutter implementation of the [ImgApi] that uses local storage.
/// {@endtemplate}
class LocalStorageImgsApi extends ImgApi {
  /// {@macro local_storage_imgs_api}
  LocalStorageImgsApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _imgStreamController = BehaviorSubject<List<Img>>.seeded(const []);
  final _selectionStreamController =
      BehaviorSubject<List<Selection>>.seeded(const []);

  /// The key used for storing the img locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kImgsCollectionKey = '__imgs_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final imgsJson = _getValue(kImgsCollectionKey);
    if (imgsJson != null) {
      final imgs = List<Map>.from(json.decode(imgsJson) as List)
          .map((jsonMap) => Img.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _imgStreamController.add(imgs);
    } else {
      _imgStreamController.add(const []);
    }
  }

  @override
  Stream<List<Img>> getImgs() => _imgStreamController.asBroadcastStream();

  @override
  Stream<List<Selection>> getSelections(String path) {
    _selectionStreamController.add(_imgStreamController.value
        .singleWhere((img) => img.path == path)
        .selections);

    return _selectionStreamController.asBroadcastStream();
  }

  @override
  Future<void> saveImg(Img img) {
    final imgs = [..._imgStreamController.value];
    final imgIndex = imgs.indexWhere((t) => t.path == img.path);
    if (imgIndex >= 0) {
      imgs[imgIndex] = img;
    } else {
      imgs.add(img);
    }

    _imgStreamController.add(imgs);
    return _setValue(kImgsCollectionKey, json.encode(imgs));
  }

  @override
  Future<void> saveSelection(String path, Selection selection) {
    final imgs = [..._imgStreamController.value];
    final imgIndex = imgs.indexWhere((img) => img.path == path);

    if (imgIndex == -1) {
      throw ImgNotFoundException();
    } else {
      imgs[imgIndex].selections.add(selection);
      _imgStreamController.add(imgs);
      return _setValue(kImgsCollectionKey, json.encode(imgs));
    }
  }

  @override
  Future<void> deleteImg(String path) async {
    final imgs = [..._imgStreamController.value];
    final imgIndex = imgs.indexWhere((t) => t.path == path);
    if (imgIndex == -1) {
      throw ImgNotFoundException();
    } else {
      imgs.removeAt(imgIndex);
      _imgStreamController.add(imgs);
      return _setValue(kImgsCollectionKey, json.encode(imgs));
    }
  }

  @override
  Future<void> deleteSelection(String path, String id) async {
    final imgs = [..._imgStreamController.value];
    final imgIndex = imgs.indexWhere((img) => img.path == path);

    if (imgIndex == -1) {
      throw ImgNotFoundException();
    } else {
      final selections = imgs[imgIndex].selections;
      final selectionIndex =
          selections.indexWhere((selection) => selection.id == id);

      if (selectionIndex == -1) {
        throw SelectionNotFoundException();
      } else {
        imgs[imgIndex].selections.removeAt(selectionIndex);
        _imgStreamController.add(imgs);
        return _setValue(kImgsCollectionKey, json.encode(imgs));
      }
    }
  }
}
