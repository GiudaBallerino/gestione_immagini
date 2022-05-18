import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
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
}