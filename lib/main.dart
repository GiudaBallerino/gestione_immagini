import 'package:flutter/material.dart';
import 'package:gestione_immagini/bootstrap.dart';
import 'package:local_storage_imgs_api/local_storage_imgs_api.dart';
import 'package:local_storage_tags_api/local_storage_tags_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final imgApi = LocalStorageImgsApi(
    plugin: await SharedPreferences.getInstance(),
  );

  final tagApi = LocalStorageTagsApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(imgApi: imgApi,tagApi: tagApi);
}